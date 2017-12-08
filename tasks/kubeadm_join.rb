#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def kubernetes_join(config, discovery_file, discovery_token, discovery_token_ca_cert_hash, discovery_token_unsafe_skip_ca_verification,
                 node_name, tls_bootstrap_token, token, skip_preflight_checks)
  cmd_string = "kubernetes join"
  cmd_string << " --config=#{config}" unless config.nil?
  cmd_string << " --discovery-file=#{discovery_file}" unless discovery_file.nil?
  cmd_string << " --discovery-token=#{discovery_token}" unless discovery_token.nil?
  cmd_string << " --discovery-token-ca-cert-hash=#{discovery_token_ca_cert_hash}" unless discovery_token_ca_cert_hash.nil?
  cmd_string << " --discovery-token-unsafe-skip-ca-verification" unless discovery_token_unsafe_skip_ca_verification.nil?
  cmd_string << " --node-name=#{node_name}" unless node_name.nil?
  cmd_string << " --tls-bootstrap-token=#{tls_bootstrap_token}" unless tls_bootstrap_token.nil?
  cmd_string << " --token=#{token}" unless token.nil?
  cmd_string << " --skip-preflight-checks" unless skip_preflight_checks.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
config = params['config']
discovery_file = params['discovery_file']
discovery_token = params['discovery_token']
discovery_token_ca_cert_hash = params['discovery_token_ca_cert_hash']
discovery_token_unsafe_skip_ca_verification = params['discovery_token_unsafe_skip_ca_verification']
node_name = params['node_name']
tls_bootstrap_token = params['tls_bootstrap_token']
token = params['token']
skip_preflight_checks = params['skip_preflight_checks']

begin
  result = kubernetes_join(config, discovery_file, discovery_token, discovery_token_ca_cert_hash, discovery_token_unsafe_skip_ca_verification,
                        node_name, tls_bootstrap_token, token, skip_preflight_checks)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
