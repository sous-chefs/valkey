# frozen_string_literal: true

provides :valkey_server
unified_mode true

property :instance_name, String, name_property: true
property :user, String, default: 'valkey'
property :group, String, default: 'valkey'
property :system_user, [true, false], default: true
property :config_dir, String, default: '/etc/valkey'
property :data_dir, String, default: '/var/lib/valkey'
property :log_dir, String, default: '/var/log/valkey'
property :run_dir, String, default: '/run/valkey'
property :binary_path, String, default: '/usr/bin/valkey-server'
property :cli_path, String, default: '/usr/bin/valkey-cli'
property :service_name, [String, NilClass]
property :bind, String, default: '127.0.0.1'
property :port, Integer, default: 6379
property :protected_mode, [true, false], default: true
property :supervised, String, default: 'systemd'
property :appendonly, [true, false], default: false
property :requirepass, [String, NilClass], sensitive: true
property :maxmemory, [String, NilClass]
property :extra_config, Hash, default: {}

default_action :create

action_class do
  def resolved_service_name
    new_resource.service_name || (new_resource.instance_name == 'default' ? 'valkey' : "valkey-#{new_resource.instance_name}")
  end

  def config_path
    ::File.join(new_resource.config_dir, "#{resolved_service_name}.conf")
  end

  def config_content
    lines = [
      "bind #{new_resource.bind}",
      "port #{new_resource.port}",
      "protected-mode #{new_resource.protected_mode ? 'yes' : 'no'}",
      "supervised #{new_resource.supervised}",
      "dir #{new_resource.data_dir}",
      "pidfile #{new_resource.run_dir}/#{resolved_service_name}.pid",
      "logfile #{new_resource.log_dir}/#{resolved_service_name}.log",
      "appendonly #{new_resource.appendonly ? 'yes' : 'no'}",
    ]
    lines << "requirepass #{new_resource.requirepass}" if new_resource.requirepass
    lines << "maxmemory #{new_resource.maxmemory}" if new_resource.maxmemory
    new_resource.extra_config.sort.each { |key, value| lines << "#{key} #{value}" }
    "#{lines.join("\n")}\n"
  end

  def unit_content
    {
      Unit: {
        Description: "Valkey instance #{resolved_service_name}",
        After: 'network-online.target',
        Wants: 'network-online.target',
      },
      Service: {
        Type: 'notify',
        User: new_resource.user,
        Group: new_resource.group,
        RuntimeDirectory: resolved_service_name,
        RuntimeDirectoryMode: '0755',
        ExecStart: "#{new_resource.binary_path} #{config_path}",
        ExecStop: "#{new_resource.cli_path} -p #{new_resource.port} shutdown",
        Restart: 'on-failure',
        LimitNOFILE: 10_000,
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
    }
  end
end

action :create do
  group new_resource.group do
    system new_resource.system_user
  end

  user new_resource.user do
    gid new_resource.group
    system new_resource.system_user
    shell '/usr/sbin/nologin'
    home new_resource.data_dir
    manage_home false
  end

  [new_resource.config_dir, new_resource.data_dir, new_resource.log_dir, new_resource.run_dir].each do |dir_path|
    directory dir_path do
      owner new_resource.user
      group new_resource.group
      mode '0750'
      recursive true
    end
  end

  file config_path do
    content config_content
    owner new_resource.user
    group new_resource.group
    mode '0640'
    sensitive !new_resource.requirepass.nil?
    notifies :restart, "systemd_unit[#{resolved_service_name}.service]", :delayed
  end

  systemd_unit "#{resolved_service_name}.service" do
    content unit_content
    action [:create, :enable]
  end
end

action :start do
  systemd_unit "#{resolved_service_name}.service" do
    action :start
  end
end

action :stop do
  systemd_unit "#{resolved_service_name}.service" do
    action :stop
  end
end

action :restart do
  systemd_unit "#{resolved_service_name}.service" do
    action :restart
  end
end

action :reload do
  systemd_unit "#{resolved_service_name}.service" do
    action :reload_or_restart
  end
end

action :delete do
  systemd_unit "#{resolved_service_name}.service" do
    action [:stop, :disable, :delete]
  end

  file config_path do
    action :delete
  end

  [new_resource.run_dir, new_resource.log_dir, new_resource.data_dir, new_resource.config_dir].each do |dir_path|
    directory dir_path do
      recursive true
      action :delete
    end
  end
end
