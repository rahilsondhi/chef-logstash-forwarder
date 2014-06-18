include_recipe "logrotate"

if node["logstash-forwarder"]["ssl_ca_certificate_path"].empty?
  Chef::Application.fatal!("You must have the CA certificate installed which signed the server's certificate")
end

group node["logstash-forwarder"]["group"] do
  system true
end

user node["logstash-forwarder"]["user"] do
  system true
  group node["logstash-forwarder"]["group"]
end

case node["platform_family"]
when "debian"
  cookbook_file "#{Chef::Config[:file_cache_path]}/logstash-forwarder_amd64.deb" do
    source "logstash-forwarder_#{node["logstash-forwarder"]["version"]}_amd64.deb"
  end

  package "logstash-forwarder" do
    source "#{Chef::Config[:file_cache_path]}/logstash-forwarder_amd64.deb"
    provider Chef::Provider::Package::Dpkg
    action :install
  end
end

directory node["logstash-forwarder"]["log_dir"] do
  mode "0755"
  owner node["logstash-forwarder"]["user"]
  group node["logstash-forwarder"]["group"]
  recursive true
end

logrotate_app "logstash-forwarder" do
  cookbook "logrotate"
  path "#{node["logstash-forwarder"]["log_dir"]}/*.log"
  frequency "daily"
  rotate 7
  create "644 root root"
end

template node["logstash-forwarder"]["config_file"] do
  mode "0644"
  source "logstash-forwarder.settings.conf.erb"
  notifies :restart, "service[logstash-forwarder]"
end

case node["platform_family"]
when "debian"
  template "/etc/init.d/logstash-forwarder" do
    mode "0755"
    source "logstash-forwarder.init.erb"
    notifies :restart, "service[logstash-forwarder]"
  end

  service "logstash-forwarder" do
    provider Chef::Provider::Service::Init::Debian
    action [ :enable, :start ]
  end
end
