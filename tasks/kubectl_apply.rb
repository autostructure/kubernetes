#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: false

require 'json'
require 'open3'
require 'puppet'

def kubectl_apply(all, allow_missing_template_keys, cascade, dry_run, filename, force, grace_period, include_extended_apis,
                  include_uninitialized, no_headers, openapi_validation, output, overwrite, prune, prune_whitelist, record, recursive,
                  selector, show_all, show_labels, sort_by, template, timeout, validate)
  cmd_string = "kubectl apply --filename=#{filename}"
  cmd_string << " --all=#{all}" unless all.nil?
  cmd_string << " --allow-missing-template-keys=#{allow_missing_template_keys}" unless allow_missing_template_keys.nil?
  cmd_string << " --cascade=#{cascade}" unless cascade.nil?
  cmd_string << " --dry-run=#{dry_run}" unless dry_run.nil?
  cmd_string << " --force=#{force}" unless force.nil?
  cmd_string << " --grace_period=#{grace_period}" unless grace_period.nil?
  cmd_string << " --include_extended_apis=#{include_extended_apis}" unless include_extended_apis.nil?
  cmd_string << " --include-uninitialized=#{include_uninitialized}" unless include_uninitialized.nil?
  cmd_string << " --no-headers=#{no_headers}" unless no_headers.nil?
  cmd_string << " --openapi-validation=#{openapi_validation}" unless openapi_validation.nil?
  cmd_string << " --output=#{output}" unless output.nil?
  cmd_string << " --overwrite=#{overwrite}" unless overwrite.nil?
  cmd_string << " --prune=#{prune}" unless prune.nil?
  cmd_string << " --prune-whitelist=#{prune_whitelist}" unless prune_whitelist.nil?
  cmd_string << " --record=#{record}" unless record.nil?
  cmd_string << " --recursive=#{recursive}" unless recursive.nil?
  cmd_string << " --selector=#{selector}" unless selector.nil?
  cmd_string << " --show-all=#{show_all}" unless show_all.nil?
  cmd_string << " --show-labels=#{show_labels}" unless show_labels.nil?
  cmd_string << " --sort-by=#{sort_by}" unless sort_by.nil?
  cmd_string << " --template=#{template}" unless template.nil?
  cmd_string << " --timeout=#{timeout}" unless timeout.nil?
  cmd_string << " --validate=#{validate}" unless validate.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
all = params['all']
allow_missing_template_keys = params['allow_missing_template_keys']
cascade = params['cascade']
dry_run = params['dry_run']
filename = params['filename']
force = params['force']
grace_period = params['grace_period']
include_extended_apis = params['include_extended_apis']
include_uninitialized = params['include_uninitialized']
no_headers = params['no_headers']
openapi_validation = params['openapi_validation']
output = params['output']
overwrite = params['overwrite']
prune = params['prune']
prune_whitelist = params['prune_whitelist']
record = params['record']
recursive = params['recursive']
selector = params['selector']
show_all = params['show_all']
show_labels = params['show_labels']
sort_by = params['sort_by']
template = params['template']
timeout = params['timeout']
validate = params['validate']

begin
  result = kubectl_apply(all, allow_missing_template_keys, cascade, dry_run, filename, force, grace_period, include_extended_apis,
                         include_uninitialized, no_headers, openapi_validation, output, overwrite, prune, prune_whitelist, record,
                         recursive, selector, show_all, show_labels, sort_by, template, timeout, validate)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
