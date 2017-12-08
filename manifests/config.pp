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
}
