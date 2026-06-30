# valkey_install

Installs or removes Valkey packages.

## Actions

- `:install`: Installs Valkey packages (default)
- `:remove`: Removes Valkey packages

## Properties

- `package_name` (`String`, default: `nil`): Override the main package name
- `version` (`String`, default: `nil`): Optional package version
- `install_compat_package` (`Boolean`, default: `false`): Install Redis-compatible symlink package
- `compat_package_name` (`String`, default: `nil`): Override compat package name
- `install_doc_package` (`Boolean`, default: `false`): Install Valkey documentation package
- `doc_package_name` (`String`, default: `nil`): Override documentation package name

## Examples

```ruby
valkey_install 'default'
```

```ruby
valkey_install 'with compat package' do
  install_compat_package true
end
```
