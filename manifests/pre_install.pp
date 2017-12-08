# Add Kubernetes required yum repository
class kubernetes::pre_install {
  if $facts['osfamily'] == 'RedHat' {
    class { '::selinux':
      mode => 'disabled',
    }

    reboot { 'after_run':
      subscribe  => Class['Selinux'],
    }

    exec { '/usr/sbin/swapoff -a':
      unless => $facts['swapoff'],
    }

    yumrepo { 'kubernetes':
      ensure        => 'present',
      baseurl       => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
      descr         => 'Kubernetes',
      enabled       => '1',
      gpgcheck      => '1',
      gpgkey        => 'https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
      repo_gpgcheck => '1',
    }
  }
}
