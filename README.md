# logstash-forwarder [![Build Status](https://secure.travis-ci.org/hectcastro/chef-logstash-forwarder.png?branch=master)](http://travis-ci.org/hectcastro/chef-logstash-forwarder)

## Description

Installs and configures [Lumberjack](https://github.com/jordansissel/logstash-forwarder).

## Requirements

### Platforms

* Ubuntu 12.04 (Precise)

### Cookbooks

* logrotate
* logstash

## Attributes

* `node["logstash-forwarder"]["version"]` - Version of Lumberjack to install.
* `node["logstash-forwarder"]["user"]` - User for Lumberjack.
* `node["logstash-forwarder"]["group"]` - Group for Lumberjack.
* `node["logstash-forwarder"]["dir"]` - Directory to install into.
* `node["logstash-forwarder"]["log_dir"]` - Log directory.
* `node["logstash-forwarder"]["host"]` - Host for Lumberjack to connect to.
* `node["logstash-forwarder"]["port"]` - Port for Lumberjack to connect to.
* `node["logstash-forwarder"]["ssl_key"]` - SSL key for Lumberjack communication.
* `node["logstash-forwarder"]["ssl_certificate"]` - SSL certificate for Lumberjack
  communication.
* `node["logstash-forwarder"]["files_to_watch"]` - Array of files to watch.
* `node["logstash-forwarder"]["logstash_role"]` – Role assigned to Logstash server for search.
* `node["logstash-forwarder"]["logstash_fqdn"]` – FQDN to Logstash server if you're trying to
  target one that isn't searchable.

## Recipes

* `recipe[logstash-forwarder]` will install Lumberjack.
* `recipe[logstash-forwarder::certificates]` will configure a Lumberjack key and
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
will be populated with the contents of the Lumberjack certificate to
secure client/server communication.  The default recipe uses this attribute to
create a client-side certificate.
