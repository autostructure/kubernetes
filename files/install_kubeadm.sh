#!/usr/bin/env bash

# Installs Puppet and Needed modules for kubernetes install
rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum install -y puppet-agent-5.3.3

/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-docker --version 1.0.2
/opt/puppetlabs/puppet/bin/puppet module install autostructure-kubernetes --version 0.1.4
/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-firewall --version 1.11.0
/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-accounts --version 1.2.1

# Apply Manifest
(
cat <<MANIFEST
class { '::firewall':
  ensure => stopped,
}

class { '::docker':
  extra_parameters => ['--exec-opt native.cgroupdriver=systemd'],
}

accounts::user { 'bryanbelanger':
  group   => 'wheel',
  shell   => '/bin/bash',
  locked  => false,
  sshkeys => ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdqCg4nG5zsz9eg/DEkE9sHiwr6r6N3oXFcNONBzQJjm0Hf8IfbH7xuNLCKWI8peUXeBawCrUoIrSf+PEkk/QHUN3Az6wlyfWJTxKBSnFBZeThn88PBW1kgh0z0t/rP1+PK9UeQ2iP+xko8hTpGDPCfiAwJPzNlf+yBB87BpoZpKjeXjk+BVH4n+BhV3nDAMRRPeTXU02OUetyNFHe2DcndMFHQmH/7/UiPGjdnYIEv5n9afa1L3G0uHfz2vnrmNfMkBjbe0+h8zKMvhBjpEUwlR4yFlgB84iwdRvDrAfZPlPpik5Ly40X4keSfh8gjahH4ns8XN6ujTptFNCWc5Wz bryanbelanger@Bryans-MacBook-Pro.local'],
}
-> class { '::kubernetes': }
MANIFEST
) > /tmp/manifest.pp

/opt/puppetlabs/puppet/bin/puppet apply /tmp/manifest.pp
