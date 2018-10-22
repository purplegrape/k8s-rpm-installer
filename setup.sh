#!/usr/bin/env bash

set -x

if [ $EUID != 0 ];then
  echo -e "you MUST run as root"
  exit 1
fi

basedir=$(dirname $0)
cd $basedir

if [ -e fuctions ];then
  . fuctions
fi

pre_install_master(){
  yum_repo
  yum install kubernetes-master kubernetes-client etcd -y
  gen_CA
  keygen
  gen_kubeconfig
}

install_master(){
  pre_install_master
  config_apiserver
  config_scheduler
  config_controller_manager
  create_clusterrolebinding
  post_install_master
}

post_install_master(){
  start_apiserver
  start_scheduler
  start_controller_manager
}

pre_install_node(){
  install_docker
}

install_node(){
  yum_repo
  yum install kubernetes-node -y
}

post_install_node(){
  config_kubelet
  config_kube_proxy
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
