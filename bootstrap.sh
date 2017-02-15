#!/bin/bash

set -e
exec 3>&1 1>/dev/null
USER="jenkins"
#if [[ $USER == "root" ]]
#then sudo=""
#else sudo=sudo
#fi

chown :docker /var/run/docker.sock

echo >&3 "Installing Haskell Stack..."
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
apt-get update
apt-get -y install lsb-core

echo "deb http://download.fpcomplete.com/ubuntu $(lsb_release -s -c) main" | tee /etc/apt/sources.list.d/fpco.list
apt-get update
apt-get -y --allow-unauthenticated install stack git

echo >&3 "installing mgit"
git clone https://github.com/blockapps/mgit.git
cd mgit
stack setup
stack install --local-bin-path /usr/bin --allow-different-user
cd ..
