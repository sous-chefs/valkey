# AGENTS.md

## Cookbook Purpose

This cookbook manages Valkey package installation and systemd-managed Valkey server instances through custom resources.

## Agent Findings

* Valkey is Redis-compatible, but this cookbook deliberately exposes `valkey_*` resources instead of extending `redisio`.
* The first implementation is package-first. Source builds are intentionally left out until maintainers decide how much Redis-style source-install surface should be carried forward.
* `valkey_server` creates its own systemd unit so instances have predictable config, data, log, and runtime paths across distributions.

## Package Availability

### APT (Ubuntu)

* Ubuntu 24.04 provides the `valkey` package.
* Ubuntu documents `valkey-redis-compat` for Redis-compatible binary symlinks.

### DNF/YUM (RHEL family)

* Fedora/RHEL-family documentation uses the `valkey` package.
* The Redis-compatible symlink package is documented as `valkey-compat-redis`.
* Documentation packages are available as `valkey-doc` where the distribution publishes them.

### Zypper (SUSE)

* Valkey documents `zypper install valkey`, but this initial cookbook does not include SUSE in the verified Kitchen matrix.

## Architecture Limitations

* This cookbook follows distribution packages and does not currently maintain per-architecture package repository metadata.

## Source/Compiled Installation

Source installation is not implemented in the initial resource surface. Prefer adding a separate source-install resource later instead of overloading package properties.

## Known Issues

* Distribution-owned Valkey unit files may also exist after package installation. The cookbook-managed instance unit in `/etc/systemd/system` is authoritative for `valkey_server`.

## Test and CI Notes

* Dokken is appropriate for the default package/service workflow because Valkey does not require kernel modules or a hypervisor.
* The supported local and CI platform set is Ubuntu 24.04 and AlmaLinux 9.
