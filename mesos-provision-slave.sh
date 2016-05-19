#!/bin/bash

# Mesos install and configuration script
# version: v0.3
# Date: 2016-04-25
# Author: Namgon Lucas Kim


# check parameters
# mesos-configure-master.sh [eth_interface] 
# ex) mesos-configure-master.sh eth1

if [ $# -ne 2 ]
  then
    echo "Usage: mesos-provision-slave.sh [eth_interface] [master_ip]"
	exit
fi
ETH_IF=$1
MASTER=$2


# check OS either ubuntu or centos
python -mplatform | grep -qi Ubuntu && OS="ubuntu" || OS="centos"

if [ $OS = "ubuntu" ]; then
echo "install on ubuntu"
# get IP address for input ehternet interface
IPADDR=$(ifconfig $ETH_IF | awk '/inet addr/{print substr($2,6)}')

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" |  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update
sudo apt-get -y install mesos

#Disable Zookeeper
sudo service zookeeper stop
sudo bash -c "echo manual > /etc/init/zookeeper.override"

#Disable Master
sudo service mesos-master stop
sudo bash -c "echo manual > /etc/init/mesos-master.override"

#Zookeeper
ZKADDR="zk://$MASTER:2181/mesos"
CHGZKADDR="echo $ZKADDR > /etc/mesos/zk"

#sudo bash -c" echo $ZKADDR > /etc/mesos/zk"
sudo bash -c "$CHGZKADDR"

SETIP="echo $IPADDR > /etc/mesos-slave/ip"
SETHOSTNAME="echo $IPADDR > /etc/mesos-slave/hostname"

sudo bash -c "$SETIP"
sudo bash -c "$SETHOSTNAME"


#Restart services
sudo service mesos-slave restart 

elif [ $OS = "centos" ]; then
echo "install on centos"
IPADDR=$(ifconfig $ETH_IF | grep 'inet' | awk '{print $2}' | cut -d: -f 2)

# Add the repository
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm

sudo yum -y install mesos 

sudo systemctl stop mesos-master.service
sudo systemctl disable mesos-master.service

#Zookeeper
ZKADDR="zk://"$MASTER':2181/mesos'
CHGZKADDR="echo $ZKADDR > /etc/mesos/zk"

#sudo bash -c" echo $ZKADDR > /etc/mesos/zk"
sudo bash -c "$CHGZKADDR"

SETIP="echo $IPADDR > /etc/mesos-slave/ip"
SETHOSTNAME="echo $IPADDR > /etc/mesos-slave/hostname"

sudo bash -c "$SETIP"
sudo bash -c "$SETHOSTNAME"

sudo systemctl restart mesos-slave

fi



