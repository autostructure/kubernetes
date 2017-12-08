# Start up the kubelet
class kubernetes::service {
  service { 'kubelet':
    ensure => running,
    enable => true,
  }
}
