#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: false

require 'json'
require 'open3'
require 'puppet'

def tester_reader(_major, _minor)
  expected_result = <<-INDENTED_HEREDOC
  [kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
  [init] Using Kubernetes version: v1.8.0
  [init] Using Authorization modes: [Node RBAC]
  [preflight] Running pre-flight checks
  [kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)
  [certificates] Generated ca certificate and key.
  [certificates] Generated apiserver certificate and key.
  [certificates] apiserver serving cert is signed for DNS names [kubeadm-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.138.0.4]
  [certificates] Generated apiserver-kubelet-client certificate and key.
  [certificates] Generated sa key and public key.
  [certificates] Generated front-proxy-ca certificate and key.
  [certificates] Generated front-proxy-client certificate and key.
  [certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
  [kubeconfig] Wrote KubeConfig file to disk: "admin.conf"
  [kubeconfig] Wrote KubeConfig file to disk: "kubelet.conf"
  [kubeconfig] Wrote KubeConfig file to disk: "controller-manager.conf"
  [kubeconfig] Wrote KubeConfig file to disk: "scheduler.conf"
  [controlplane] Wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
  [controlplane] Wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
  [controlplane] Wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
  [etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
  [init] Waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
  [init] This often takes around a minute; or longer if the control plane images have to be pulled.
  [apiclient] All control plane components are healthy after 39.511972 seconds
  [uploadconfig] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
  [markmaster] Will mark node master as master by adding a label and a taint
  [markmaster] Master master tainted and labelled with key/value: node-role.kubernetes.io/master=""
  [bootstraptoken] Using token: <token>
  [bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
  [bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
  [bootstraptoken] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
  [addons] Applied essential addon: kube-dns
  [addons] Applied essential addon: kube-proxy

  Your Kubernetes master has initialized successfully!

  To start using your cluster, you need to run (as a regular user):

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

  You should now deploy a pod network to the cluster.
  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    http://kubernetes.io/docs/admin/addons/

  You can now join any number of machines by running the following on each node
  as root:

    kubeadm join --token Hubba 127.0.0.1:3000 --discovery-token-ca-cert-hash sha256:xxxyyyzz
  INDENTED_HEREDOC

  # stdout, stderr, status = Open3.capture3("{ \"major\": \"#{major}\", \"minor\": \"#{minor}\" }")
  # raise Puppet::Error, "stderr: '#{stderr}'" if status != 0
  # stdout.strip
  # { "major": major.to_s, "minor": minor.to_s }
  {
    "discovery-token-ca-cert-hash": /sha256:\S+/.match(expected_result),
    "token": /--token +(?<token>\S+ +\S+)/.match(expected_result)[:token],
    "veg": ENV["VEG"],
  }
end

params = JSON.parse(STDIN.read)
major = params['major']
minor = params['minor']

begin
  result = tester_reader(major, minor)
  puts JSON.pretty_generate(result)
  # puts result
  exit 0
rescue Puppet::Error => e
  puts(status: 'failure', error: e.message)
  exit 1
end
