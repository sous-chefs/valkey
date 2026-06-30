# Valkey Cookbook

Provides custom resources for installing Valkey and managing systemd Valkey server instances.

## Supported Platforms

* AlmaLinux 9
* Ubuntu 24.04

## Resources

* `valkey_install`
* `valkey_server`

## Basic Usage

```ruby
valkey_install 'default'

valkey_server 'default' do
  bind '127.0.0.1'
  port 6379
  action [:create, :start]
end
```

## Testing

```bash
cookstyle
chef exec rspec --format documentation
KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test default-ubuntu-2404 --destroy=always
```

Additional public API details live in `documentation/*.md`.
