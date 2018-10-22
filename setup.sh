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
}

install_master(){
}


post_install_master(){
}

pre_install_node(){
}

install_node(){
}

post_install_node(){
}
