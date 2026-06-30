# frozen_string_literal: true

require 'spec_helper'

describe 'valkey_server' do
  step_into :valkey_server
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      valkey_server 'default'
    end

    it { is_expected.to create_group('valkey') }
    it { is_expected.to create_user('valkey') }
    it { is_expected.to create_directory('/etc/valkey') }
    it { is_expected.to create_file('/etc/valkey/valkey.conf').with_content(/port 6379/) }
    it { is_expected.to create_systemd_unit('valkey.service') }
    it { is_expected.to enable_systemd_unit('valkey.service') }
  end

  context 'with a named instance' do
    recipe do
      valkey_server 'cache' do
        port 6380
        maxmemory '256mb'
        extra_config lazyfree_lazy_eviction: 'yes'
      end
    end

    it { is_expected.to create_file('/etc/valkey/valkey-cache.conf').with_content(/port 6380/) }
    it { is_expected.to create_file('/etc/valkey/valkey-cache.conf').with_content(/maxmemory 256mb/) }
    it { is_expected.to create_file('/etc/valkey/valkey-cache.conf').with_content(/lazyfree_lazy_eviction yes/) }
    it { is_expected.to create_systemd_unit('valkey-cache.service') }
  end
end
