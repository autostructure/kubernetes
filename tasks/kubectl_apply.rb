#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: false

require 'json'
require 'open3'
require 'puppet'

def kubectl_apply(annotate, api_versions, apply, attach, autoscale, cluster_info, config, create, delete, describe, edit, exec, explain,
                  expose, get, label, logs, patch, port_forward, proxy, replace, rolling_update, run, scale, stop, version)
  cmd_string = "kubectl apply"
  cmd_string << " --annotate=${annotate}" unless annotate.nil?
  cmd_string << " --api-versions=${api-versions}" unless api_versions.nil?
  cmd_string << " --apply=${apply}" unless apply.nil?
  cmd_string << " --attach=${attach}" unless attach.nil?
  cmd_string << " --autoscale=${autoscale}" unless autoscale.nil?
  cmd_string << " --cluster-info=${cluster-info}" unless cluster_info.nil?
  cmd_string << " --config=${config}" unless config.nil?
  cmd_string << " --create=${create}" unless create.nil?
  cmd_string << " --delete=${delete}" unless delete.nil?
  cmd_string << " --describe=${describe}" unless describe.nil?
  cmd_string << " --edit=${edit}" unless edit.nil?
  cmd_string << " --exec=${exec}" unless exec.nil?
  cmd_string << " --explain=${explain}" unless explain.nil?
  cmd_string << " --expose=${expose}" unless expose.nil?
  cmd_string << " --get=${get}" unless get.nil?
  cmd_string << " --label=${label}" unless label.nil?
  cmd_string << " --logs=${logs}" unless logs.nil?
  cmd_string << " --patch=${patch}" unless patch.nil?
  cmd_string << " --port-forward=${port-forward}" unless port_forward.nil?
  cmd_string << " --proxy=${proxy}" unless proxy.nil?
  cmd_string << " --replace=${replace}" unless replace.nil?
  cmd_string << " --rolling-update=${rolling-update}" unless rolling_update.nil?
  cmd_string << " --run=${run}" unless run.nil?
  cmd_string << " --scale=${scale}" unless scale.nil?
  cmd_string << " --stop=${stop}" unless stop.nil?
  cmd_string << " --version=${version}" unless version.nil?

  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  stdout.strip
end

params = JSON.parse(STDIN.read)
annotate = params['annotate']
api_versions = params['api_versions']
apply = params['apply']
attach = params['attach']
autoscale = params['autoscale']
cluster_info = params['cluster_info']
config = params['config']
create = params['create']
delete = params['delete']
describe = params['describe']
edit = params['edit']
exec = params['exec']
explain = params['explain']
expose = params['expose']
get = params['get']
label = params['label']
logs = params['logs']
patch = params['patch']
port_forward = params['port_forward']
proxy = params['proxy']
replace = params['replace']
rolling_update = params['rolling_update']
run = params['run']
scale = params['scale']
stop = params['stop']
version = params['version']

begin
  result = kubectl_apply(annotate, api_versions, apply, attach, autoscale, cluster_info, config, create, delete, describe, edit, exec,
                         explain, expose, get, label, logs, patch, port_forward, proxy, replace, rolling_update, run, scale, stop, version)
  puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
