# frozen_string_literal: true

valkey_install 'default'

valkey_server 'default' do
  bind '127.0.0.1'
  port 6379
  action [:create, :start]
end
