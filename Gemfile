# frozen_string_literal: true

source 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint'
  gem 'puppet'
  gem 'puppetlabs_spec_helper'
  gem 'rake'
  gem 'rspec'
  gem 'rspec-puppet' # , git: 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'semantic_puppet'
  gem 'simplecov'
  gem 'simplecov-console'

  gem 'puppet-blacksmith'

  gem 'puppet-lint-absolute_classname-check'
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-resource_reference_syntax'
  gem 'puppet-lint-trailing_comma-check'
  gem 'puppet-lint-unquoted_string-check'
  gem 'puppet-lint-version_comparison-check'
end

group :development do
  gem 'guard-rake'
  gem 'travis'
  gem 'travis-lint'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-puppet_install_helper'
  gem 'beaker-rspec'

  gem 'fog-aws'
end
