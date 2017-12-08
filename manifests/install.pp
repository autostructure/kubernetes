# Install Kubernetes required packages
class kubernetes::install {
  package { 'kubelet':
    ensure => present,
  }

  package { 'kubernetes':
    ensure => present,
  }

  package { 'kubectl':
    ensure => present,
  }
}
