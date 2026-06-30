# frozen_string_literal: true

require 'spec_helper'

describe 'valkey_install' do
  step_into :valkey_install

  context 'on ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      valkey_install 'default' do
        install_compat_package true
      end
    end

    it { is_expected.to update_apt_update('valkey-package-cache') }
    it { is_expected.to install_package('valkey') }
    it { is_expected.to install_package('valkey-redis-compat') }
  end

  context 'on almalinux' do
    platform 'almalinux', '9'

    recipe do
      valkey_install 'default' do
        install_compat_package true
        install_doc_package true
      end
    end

    it { is_expected.to install_package('valkey') }
    it { is_expected.to install_package('valkey-compat-redis') }
    it { is_expected.to install_package('valkey-doc') }
  end
end
