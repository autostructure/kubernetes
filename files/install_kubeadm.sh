#!/usr/bin/env bash

# Installs Puppet and Needed modules for kubernetes install
rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum install -y puppet-agent-5.3.3

/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-docker --version 1.0.2
/opt/puppetlabs/puppet/bin/puppet module install autostructure-kubernetes
/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-firewall --version 1.11.0
/opt/puppetlabs/puppet/bin/puppet module install puppetlabs-accounts --version 1.2.1

# Apply Manifest
(
cat <<MANIFEST
class { '::firewall':
  ensure => stopped,
}

class { '::docker':
  extra_parameters => ['--exec-opt native.cgroupdriver=cgroupfs'],
}

class { '::kubernetes': }
MANIFEST
) > /tmp/manifest.pp

/opt/puppetlabs/puppet/bin/puppet apply /tmp/manifest.pp
