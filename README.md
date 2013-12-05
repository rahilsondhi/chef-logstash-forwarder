# lumberjack [![Build Status](https://secure.travis-ci.org/hectcastro/chef-lumberjack.png?branch=master)](http://travis-ci.org/hectcastro/chef-lumberjack)

## Description

Installs and configures [Lumberjack](https://github.com/jordansissel/lumberjack).

## Requirements

### Platforms

* Ubuntu 12.04 (Precise)

### Cookbooks

* logrotate
* logstash

## Attributes

* `node["lumberjack"]["version"]` - Version of Lumberjack to install.
* `node["lumberjack"]["user"]` - User for Lumberjack.
* `node["lumberjack"]["group"]` - Group for Lumberjack.
* `node["lumberjack"]["dir"]` - Directory to install into.
* `node["lumberjack"]["log_dir"]` - Log directory.
* `node["lumberjack"]["host"]` - Host for Lumberjack to connect to.
* `node["lumberjack"]["port"]` - Port for Lumberjack to connect to.
* `node["lumberjack"]["ssl_key"]` - SSL key for Lumberjack communication.
* `node["lumberjack"]["ssl_certificate"]` - SSL certificate for Lumberjack
  communication.
* `node["lumberjack"]["files_to_watch"]` - Array of files to watch.
* `node["lumberjack"]["logstash_role"]` – Role assigned to Logstash server for search.
* `node["lumberjack"]["logstash_fqdn"]` – FQDN to Logstash server if you're trying to
  target one that isn't searchable.

## Recipes

* `recipe[lumberjack]` will install Lumberjack.
* `recipe[lumberjack::certificates]` will configure a Lumberjack key and
  certificate.

## Usage

In order to automatically discover Logstash, setup your roles like the
following:

```ruby
default_attributes(
  "lumberjack" => {
    "logstash_fqdn" => "http://logstash.example.com"
  }
)
```

Or in a Chef Server environment:

```ruby
default_attributes()
  "lumberjack" => {
    "logstash_role" => "logstash_server"
  }
)
```

If you use the `lumberjack::certificates` recipe, `node["lumberjack"]["ssl_certificate_contents"]`
will be populated with the contents of the Lumberjack certificate to
secure client/server communication.  The default recipe uses this attribute to
create a client-side certificate.
