# valkey_server

Creates a systemd-managed Valkey server instance.

## Actions

- `:create`: Creates config, directories, and systemd unit (default)
- `:start`: Starts the service
- `:stop`: Stops the service
- `:restart`: Restarts the service
- `:reload`: Reloads or restarts the service
- `:delete`: Removes the unit, config, and managed directories

## Properties

- `instance_name` (`String`, name property): Instance name
- `user` (`String`, default: `valkey`): Service user
- `group` (`String`, default: `valkey`): Service group
- `system_user` (`Boolean`, default: `true`): Create a system user/group
- `config_dir` (`String`, default: `/etc/valkey`): Configuration directory
- `data_dir` (`String`, default: `/var/lib/valkey`): Data directory
- `log_dir` (`String`, default: `/var/log/valkey`): Log directory
- `run_dir` (`String`, default: `/run/valkey`): Runtime directory
- `binary_path` (`String`, default: `/usr/bin/valkey-server`): Server binary path
- `cli_path` (`String`, default: `/usr/bin/valkey-cli`): CLI binary path
- `service_name` (`String`, default: `nil`): Override systemd service name
- `bind` (`String`, default: `127.0.0.1`): Bind address
- `port` (`Integer`, default: `6379`): Listen port
- `protected_mode` (`Boolean`, default: `true`): Enable protected mode
- `supervised` (`String`, default: `systemd`): Valkey supervised mode
- `appendonly` (`Boolean`, default: `false`): Enable appendonly persistence
- `requirepass` (`String`, default: `nil`): Password, marked sensitive
- `maxmemory` (`String`, default: `nil`): Optional maxmemory value
- `extra_config` (`Hash`, default: `{}`): Additional config directives

## Examples

```ruby
valkey_server 'default' do
  action [:create, :start]
end
```

```ruby
valkey_server 'cache' do
  port 6380
  maxmemory '512mb'
  extra_config lazyfree_lazy_eviction: 'yes'
  action [:create, :start]
end
```
