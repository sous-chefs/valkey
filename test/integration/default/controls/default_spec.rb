# frozen_string_literal: true

control 'valkey-binaries-01' do
  impact 1.0
  title 'Valkey binaries are installed'

  describe command('/usr/bin/valkey-server --version') do
    its('exit_status') { should eq 0 }
  end

  describe command('/usr/bin/valkey-cli --version') do
    its('exit_status') { should eq 0 }
  end
end

control 'valkey-config-01' do
  impact 1.0
  title 'Valkey config is managed'

  describe file('/etc/valkey/valkey.conf') do
    it { should exist }
    its('mode') { should cmp '0640' }
    its('content') { should match(/^port 6379$/) }
  end
end

control 'valkey-service-01' do
  impact 1.0
  title 'Valkey service is enabled and running'

  describe systemd_service('valkey') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'valkey-command-01' do
  impact 1.0
  title 'Valkey responds to ping'

  describe command('/usr/bin/valkey-cli -p 6379 ping') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/PONG/) }
  end
end
