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
  else
  echo -e "error,fuctions not found"
  exit 1
fi

pre_install_master(){
  create_yum_repo
  install_etcd
  yum install kubernetes-master kubernetes-client -y
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
  install_docker
  create_yum_repo
  yum install kubernetes-node -y
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
