#!/usr/bin/env bash
#user_directory=$(getent passwd $PT_kubectl_user | cut -d: -f6)/.kube

#mkdir -p $user_directory
#sudo cp -i /etc/kubernetes/admin.conf $user_directory/config
#sudo chown $(id -u $PT_kubectl_user):$(id -g $PT_kubectl_user) $user_directory/config

echo $PT_kubectl_user
