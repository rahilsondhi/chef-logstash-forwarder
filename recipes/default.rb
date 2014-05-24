include_recipe "logrotate"

if node["logstash-forwarder"]["ssl_ca_certificate_path"].empty?
  Chef::Application.fatal!("You must have the CA certificate installed which signed the server's certificate")
end

host_hash = ""
node["logstash-forwarder"]["hosts"].each do |host| 
  host_hash = host_hash + "\"#{host}:#{node["logstash-forwarder"]["port"]}\","
end
host_hash = host_hash[0...-1]

file_list = "  \"files\": ["
node["logstash-forwarder"]["files"].each do |type, files| 
  if !files.empty?
    file_list = file_list + "\n    {\n"
    file_list = file_list + "      \"paths\": #{files},\n"
    file_list = file_list + "      \"fields\": { \"type\": \"#{type}\" }\n"
    file_list = file_list + "    },"
  end
end
file_list = file_list[0...-1]
file_list = file_list + "\n  ]"

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
  variables(
    :hosts               => host_hash,
    :files               => file_list,
    :timeout             => node["logstash-forwarder"]["timeout"],
    :ssl_certificate     => node["logstash-forwarder"]["ssl_certificate_path"],
    :ssl_ca_certificate  => node["logstash-forwarder"]["ssl_ca_certificate_path"],
    :ssl_key             => node["logstash-forwarder"]["ssl_key_path"],
    :files_to_watch      => node["logstash-forwarder"]["files_to_watch"]
  )
  notifies :restart, "service[logstash-forwarder]"
end

case node["platform_family"]
when "debian"

  template "/etc/init/logstash-forwarder.conf" do
    mode "0644"
    source "logstash-forwarder.conf.erb"
    variables(
      :dir              => node["logstash-forwarder"]["dir"],
      :user             => node["logstash-forwarder"]["user"],
      :log_dir          => node["logstash-forwarder"]["log_dir"],
      :config_file      => node["logstash-forwarder"]["config_file"]
    )
    notifies :restart, "service[logstash-forwarder]"
  end

  service "logstash-forwarder" do
    provider Chef::Provider::Service::Upstart
    action [ :enable, :start ]
  end
end
