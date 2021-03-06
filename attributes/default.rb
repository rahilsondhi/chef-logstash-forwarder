default["logstash-forwarder"]["version"]                    = "0.3.1"
default["logstash-forwarder"]["user"]                       = "logstash-forwarder"
default["logstash-forwarder"]["group"]                      = "logstash-forwarder"
default["logstash-forwarder"]["dir"]                        = "/opt/logstash-forwarder"
default["logstash-forwarder"]["log_dir"]                    = "/var/log/logstash-forwarder"
default["logstash-forwarder"]["hosts"]                      = nil
default["logstash-forwarder"]["timeout"]                    = "15"
default["logstash-forwarder"]["ssl_certificate"]            = "/etc/logstash-forwarder/logstash-forwarder.crt"
default["logstash-forwarder"]["ssl_key"]                    = "/etc/logstash-forwarder/logstash-forwarder.key"
default["logstash-forwarder"]["ssl_ca"]                     = "/etc/logstash-forwarder/logstash-forwarder.crt"
default["logstash-forwarder"]["files"]                      = nil
default["logstash-forwarder"]["logstash_role"]              = "logstash"
default["logstash-forwarder"]["logstash_fqdn"]              = ""
default["logstash-forwarder"]["config_file"]                = "/etc/logstash-forwarder/logstash-forwarder.conf"
