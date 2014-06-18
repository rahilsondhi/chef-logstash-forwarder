maintainer        "Rahil Sondhi"
maintainer_email  "rahilsondhi@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Logstash-Forwarder."
version           "0.0.6"
recipe            "logstash-forwarder", "Installs and configures Lumberjack"
name              "logstash-forwarder"

%w{ logrotate }.each do |d|
  depends d
end

%w{ logstash }.each do |s|
  suggests s
end

%w{ ubuntu debian rhel centos scientific amazon fedora}.each do |os|
    supports os
end
