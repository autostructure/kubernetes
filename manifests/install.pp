# Install Kubernetes required packages
class kubernetes::install {
  package { 'kubelet':
    ensure => present,
  }

  package { 'kubeadm':
    ensure => present,
  }

  package { 'kubectl':
    ensure => present,
  }
}
