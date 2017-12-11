#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: false

require 'json'
require 'open3'
require 'puppet'

def kubeadm_init(apiserver_advertise_address, apiserver_bind_port, apiserver_cert_extra_sans, cert_dir, config, dry_run, feature_gates,
                 kubernetes_version, node_name, pod_network_cidr, service_cidr, service_dns_domain, skip_preflight_checks,
                 skip_token_print, token, token_ttl)
  cmd_string = "kubeadm init"
  cmd_string << " --apiserver-advertise-address=#{apiserver_advertise_address}" unless apiserver_advertise_address.nil?
  cmd_string << " --apiserver-bind-port=#{apiserver_bind_port}" unless apiserver_bind_port.nil?
  cmd_string << " --apiserver-cert-extra-sans=#{apiserver_cert_extra_sans}" unless apiserver_cert_extra_sans.nil?
  cmd_string << " --cert-dir=#{cert_dir}" unless cert_dir.nil?
  cmd_string << " --config=#{config}" unless config.nil?
  cmd_string << " --dry-run" unless dry_run.nil?
  cmd_string << " --feature-gates=#{feature_gates}" unless feature_gates.nil?
  cmd_string << " --kubernetes-version=#{kubernetes_version}" unless kubernetes_version.nil?
  cmd_string << " --node-name=#{node_name}" unless node_name.nil?
  cmd_string << " --pod-network-cidr=#{pod_network_cidr}" unless pod_network_cidr.nil?
  cmd_string << " --service-cidr=#{service_cidr}" unless service_cidr.nil?
  cmd_string << " --service-dns-domain=#{service_dns_domain}" unless service_dns_domain.nil?
  cmd_string << " --skip-preflight-checks" unless skip_preflight_checks.nil?
  cmd_string << " --skip-token-print" unless skip_token_print.nil?
  cmd_string << " --token=#{token}" unless token.nil?
  cmd_string << " --token-ttl=#{token_ttl}" unless token_ttl.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
apiserver_advertise_address = params['apiserver_advertise_address']
apiserver_bind_port = params['apiserver_bind_port']
apiserver_cert_extra_sans = params['apiserver_cert_extra_sans']
cert_dir = params['cert_dir']
config = params['config']
dry_run = params['dry_run']
feature_gates = params['feature_gates']
kubernetes_version = params['kubernetes_version']
node_name = params['node_name']
pod_network_cidr = params['pod_network_cidr']
service_cidr = params['service_cidr']
service_dns_domain = params['service_dns_domain']
skip_preflight_checks = params['skip_preflight_checks']
skip_token_print = params['skip_token_print']
token = params['token']
token_ttl = params['token_ttl']

begin
  result = kubeadm_init(apiserver_advertise_address, apiserver_bind_port, apiserver_cert_extra_sans, cert_dir, config, dry_run,
                        feature_gates, kubernetes_version, node_name, pod_network_cidr, service_cidr, service_dns_domain,
                        skip_preflight_checks, skip_token_print, token, token_ttl)

  join_values =
    {
      "discovery-token-ca-cert-hash": /sha256:\S+/.match(result),
      "token": /--token +(?<token>\S+ +\S+)/.match(result)[:token]
    }

  puts JSON.pretty_generate(join_values)
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
