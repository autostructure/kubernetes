#!/usr/bin/env bash
user_directory=$(getent passwd $PT_kubectl_user | cut -d: -f6)

pushd $user_directory
  mkdir .kube
  sudo cp -i /etc/kubernetes/admin.conf .kube/config
  sudo chown -R $(id -u $PT_kubectl_user):$(id -g $PT_kubectl_user) .kube
popd
