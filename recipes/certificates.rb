package "ssl-cert" do
  action :install
end

execute "generate-default-snakeoil" do
  command "make-ssl-cert generate-default-snakeoil"
  creates "/etc/ssl/certs/ssl-cert-snakeoil.pem"
end

directory "#{node["logstash-forwarder"]["dir"]}/ssl" do
  mode "0750"
  owner node["logstash"]["user"]
  group "ssl-cert"
  recursive true
end

[ [ "certs", "pem" ], [ "private", "key" ] ].each do |pair|
  subdirectory, extension = pair

  execute "copy-certificates-#{extension}" do
    command "cp /etc/ssl/#{subdirectory}/ssl-cert-snakeoil.#{extension} #{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.#{extension}"
    creates "#{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.#{extension}"
  end

  file "#{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.#{extension}" do
    mode (extension == "pem" ? "0644" : "640")
    owner node["logstash"]["user"]
    group "ssl-cert"
    action :touch
  end
end

ruby_block "ssl-certificate-setup" do
  block {
    node.set["logstash-forwarder"]["ssl_key"]                  = "#{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.key"
    node.set["logstash-forwarder"]["ssl_certificate"]          = "#{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.pem"
    node.set["logstash-forwarder"]["ssl_certificate_contents"] = File.read("#{node["logstash-forwarder"]["dir"]}/ssl/ssl-cert-logstash-forwarder.pem")
  }
end

group "ssl-cert" do
  action :modify
  members node["logstash"]["user"]
  append true
end
