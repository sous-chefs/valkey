# frozen_string_literal: true

name              'valkey'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides custom resources for installing and managing Valkey server instances'
version           '1.0.0'
source_url        'https://github.com/sous-chefs/valkey'
issues_url        'https://github.com/sous-chefs/valkey/issues'
chef_version      '>= 16.0'

supports 'almalinux', '>= 9.0'
supports 'ubuntu', '>= 24.04'
