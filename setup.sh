#!/usr/bin/env bash

set -e
set -x

if [ $EUID != 0 ];then
  echo -e "you MUST run as root"
  exit 1
fi

basedir=$(dirname $0)
cd $basedir

if [ -e functions ];then
  . ./functions
  else
  echo -e "error,fuctions not found"
  exit 1
fi

pre_install_master(){
  install_rpms_master
  install_etcd
  keygen
  gen_kubeconfig
}

install_master(){
  pre_install_master
  config_apiserver
  create_clusterrolebinding
  config_scheduler
  config_controller_manager
  install_node
  post_install_master
}

install_node(){
  install_rpms_node
  install_docker
  config_kubelet
  config_kube_proxy
}

post_install_master(){
  kubectl get cs
  kubectl get svc
  kubectl get nodes
}

case $1 in
  master)
  install_master
  ;;
  node)
  install_node
  ;;
  cleanup)
  cleanup
  ;;
  *)
  echo "Usage:$0 {master|node|cleanup}"
  exit 1
esac

# the end
