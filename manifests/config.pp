# Install Kubernetes required packages
class kubernetes::config {
  sysctl { 'net.bridge.bridge-nf-call-ip6tables':
    ensure => present,
    value  => '1',
  }

  sysctl { 'net.bridge.bridge-nf-call-iptables':
    ensure => present,
    value  => '1',
  }

  # Ensure kubelet runs cgroup driver cgroupfs
  $kubelet_cgroup_file = @("KUBELET_CGROUP"/L)
    [Service]
    Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs"
    | KUBELET_CGROUP

  file { '/etc/systemd/system/kubelet.service.d/05-custom.conf':
    ensure  => file,
    content => $kubelet_cgroup_file,
  }
}
