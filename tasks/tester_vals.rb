#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: false

require 'json'

result = { "major": "7", "minor": "2" }
puts JSON.pretty_generate(result)
