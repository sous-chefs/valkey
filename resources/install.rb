# frozen_string_literal: true

provides :valkey_install
unified_mode true

property :package_name, [String, NilClass]
property :version, [String, NilClass]
property :install_compat_package, [true, false], default: false
property :compat_package_name, [String, NilClass]
property :install_doc_package, [true, false], default: false
property :doc_package_name, [String, NilClass]

default_action :install

action_class do
  def resolved_package_name
    new_resource.package_name || 'valkey'
  end

  def resolved_compat_package_name
    return new_resource.compat_package_name if new_resource.compat_package_name

    platform_family?('debian') ? 'valkey-redis-compat' : 'valkey-compat-redis'
  end

  def resolved_doc_package_name
    new_resource.doc_package_name || 'valkey-doc'
  end
end

action :install do
  apt_update 'valkey-package-cache' do
    action :update
    only_if { platform_family?('debian') }
  end

  package resolved_package_name do
    version new_resource.version unless new_resource.version.nil?
    action :install
  end

  package resolved_compat_package_name do
    action :install
    only_if { new_resource.install_compat_package }
  end

  package resolved_doc_package_name do
    action :install
    only_if { new_resource.install_doc_package }
  end
end

action :remove do
  package resolved_doc_package_name do
    action :remove
    only_if { new_resource.install_doc_package }
  end

  package resolved_compat_package_name do
    action :remove
    only_if { new_resource.install_compat_package }
  end

  package resolved_package_name do
    action :remove
  end
end
