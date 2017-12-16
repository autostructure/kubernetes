# Kubernetes

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with kubernetes](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kubernetes](#beginning-with-kubernetes)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

The Autostructure kubernetes module installs and configures Kubernetes using the kubeadm application.

## Description

This module installs, configures, and manages Kubernetes.

* Centos 7.0

## Setup

### Setup Requirements

Install ruby and bolt to use all of the functionality of this module.

#### Install ruby

You need to have ruby installed locally. If you are unfamiliar with ruby follow these instructions to install it on your machine. https://www.ruby-lang.org/en/documentation/installation/

#### Install bolt and puppet

In order to execute the tasks and plans of this module you will need puppet and bolt.

You also need to download the module locally.

Go ahead and install them.

```puppet
gem install puppet --no-ri --no-rdoc
gem install bolt --no-ri --no-rdoc
puppet module install autostructure-kubernetes
```

## Usage

If you have already installed the module with Puppet Enterprise go to [Using Puppet Enterprise.](#using_puppet_enterprise)

If you are doing an install on fresh boxes go to [Fresh Install without Puppet Enterprise.](#fresh_install_without_puppet_enterprise)

### Using Puppet Enterprise

If you are using Puppet Enterprise kubeadm can be installed by calling the main class.

To install kubernetes add a single class to the manifest file:

```puppet
include ::kubernetes
```

You also need to include docker. Docker must be assigned to the cgroupfs cgroupdriver. Turn off the firewall.

Both modules are required for the kubernetes module. The following snippet sets the minimal requirements for kubernetes.

```puppet
class { '::firewall':
  ensure => stopped,
}

class { '::docker':
  extra_parameters => ['--exec-opt native.cgroupdriver=cgroupfs'],
}
```

#### Using a username and password

```bolt
bolt plan run kubernetes::install_cluster master=<master_host_or_ip> worker_nodes=<worker1_host_or_ip>,<worker2__or_ip_2>,... --user <sudo_user> --password <sudo_user_password>  --modulepath puppet/modules/ -k --sudo
```

#### Using a username private key

```bolt
bolt plan run kubernetes::install_cluster master=<master_host_or_ip> worker_nodes=<worker1_host_or_ip>,<worker2__or_ip_2>,... --user <sudo_user> --private-key <path_to_private_key>  --modulepath puppet/modules/ -k --sudo
```

### Fresh Install without Puppet Enterprise

If kubeadm is not installed on your servers run one of the following commands to install your kubernetes cluster.

The user you use must have the ability to run sudo.

#### Using a username and password

```bolt
bolt plan run kubernetes::install_cluster master=<master_host_or_ip> worker_nodes=<worker1_host_or_ip>,<worker2__or_ip_2>,... --user <sudo_user> --password <sudo_user_password>  --modulepath puppet/modules/ -k --sudo
```

#### Using a username private key

```bolt
bolt plan run kubernetes::install_cluster master=<master_host_or_ip> worker_nodes=<worker1_host_or_ip>,<worker2__or_ip_2>,... --user <sudo_user> --private-key <path_to_private_key>  --modulepath puppet/modules/ -k --sudo
```

## Reference

### Classes

#### Public classes

* kubernetes: Main class, includes all other classes.

#### Private classes

* kubernetes::pre_install: Handles pre-installation tasks.
* kubernetes::install: Handles the packages.
* kubernetes::config: Handles the configuration files.
* kubernetes::service: Handles the service.

## Limitations

This module has only been tested on CentOS. Consider it alpha.

## Development

Puppet modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. Please follow our guidelines when contributing changes.

For more information, see our [module contribution guide.](https://docs.puppetlabs.com/forge/contributing.html)

## Contributors

To see who's already involved, see the [list of contributors.](https://github.com/autostructure/kubernetes/graphs/contributors)
