# Logstash-forwarder [![Build Status](https://secure.travis-ci.org/hectcastro/chef-lumberjack.png?branch=master)](http://travis-ci.org/hectcastro/chef-lumberjack)

## Description

Installs and configures [Logstash-forwarder](https://github.com/elasticsearch/logstash-forwarder).

## Requirements

### Platforms

* Ubuntu 12.04 (Precise)

### Cookbooks

* logrotate
* logstash

## Attributes

* `node["logstash-forwarder"]["version"]` - Version of Logstash-forwarder to install.
* `node["logstash-forwarder"]["user"]` - User for Logstash-forwarder.
* `node["logstash-forwarder"]["group"]` - Group for Logstash-forwarder.
* `node["logstash-forwarder"]["dir"]` - Directory to install into.
* `node["logstash-forwarder"]["log_dir"]` - Log directory.
* `node["logstash-forwarder"]["host"]` - Host for Logstash-forwarder to connect to.
* `node["logstash-forwarder"]["port"]` - Port for Logstash-forwarder to connect to.
* `node["logstash-forwarder"]["ssl_key"]` - SSL key for Logstash-forwarder communication.
* `node["logstash-forwarder"]["ssl_certificate"]` - SSL certificate for Logstash-forwarder
  communication.
* `node["logstash-forwarder"]["files"]` - Collection of files to watch.<br>
If you require a collection of files to watch. The structure looks like this:<br>
`{ "syslog" => ['/var/log/syslog'], "auth" => ['/var/log/auth.log'] }`

* `node["logstash-forwarder"]["logstash_role"]` – Role assigned to Logstash server for search.
* `node["logstash-forwarder"]["logstash_fqdn"]` – FQDN to Logstash server if you're trying to
  target one that isn't searchable.




## Recipes

* `recipe[logstash-forwarder]` will install Logstash-forwarder.
* `recipe[logstash-forwarder::certificates]` will configure a Logstash-forwarder key and
  certificate.

## Usage

In order to automatically discover Logstash, setup your roles like the
following:

```ruby
default_attributes(
  "logstash-forwarder" => {
    "logstash_fqdn" => "http://logstash.example.com"
  }
)
```

Or in a Chef Server environment:

```ruby
default_attributes()
  "logstash-forwarder" => {
    "logstash_role" => "logstash_server"
  }
)
```

If you use the `logstash-forwarder::certificates` recipe, `node["logstash-forwarder"]["ssl_certificate_contents"]`
will be populated with the contents of the Logstash-forwarder certificate to
secure client/server communication.  The default recipe uses this attribute to
create a client-side certificate.
