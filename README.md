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

Docker must be installed.

You can use the Puppet supported Docker module to install the basic Docker container engine.

```puppet
include ::docker
```

### Beginning with kubernetes

To install kubeadm and the necessary kube packages add a single class to the manifest file:

```puppet
include ::kubernetes
```

## Usage

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
