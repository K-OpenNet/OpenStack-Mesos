#!/bin/bash

# Mesos install and configuration script
# version: 0.3
# Date: 2016-05-19
# Author: Namgon Lucas Kim


# check parameters
# mesos-configure-master.sh [eth_interface] 
# ex) mesos-configure-master.sh eth1

if [ $# -ne 1 ]
  then
    echo "Usage: mesos-provision-master.sh [eth_interface]"
	exit
fi
ETH_IF=$1

# check OS either ubuntu or centos
python -mplatform | grep -qi Ubuntu && OS="ubuntu" || OS="centos"

if [ $OS = "ubuntu" ]; then
echo "install on ubuntu"
# get IP address for input ehternet interface
IPADDR=$(ifconfig $ETH_IF | awk '/inet addr/{print substr($2,6)}')

# add repository for openjdk8
sudo add-apt-repository -y ppa:openjdk-r/ppa

# add repository for mesos 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" |  sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update
sudo apt-get -y install openjdk-8-jdk
sudo apt-get -y install mesos
sudo apt-get -y install marathon

#Disable slave
sudo service mesos-slave stop
sudo bash -c "echo manual > /etc/init/mesos-slave.override"

#Zookeeper
ZKADDR="zk://"$IPADDR':2181/mesos'
CHGZKADDR="echo $ZKADDR > /etc/mesos/zk"

sudo bash -c "$CHGZKADDR"

#Restart services
sudo service zookeeper restart 
sudo service mesos-master restart 
sudo service marathon restart

elif [ $OS = "centos" ]; then
echo "install on centos"
IPADDR=$(ifconfig $ETH_IF | grep 'inet' | awk '{print $2}' | cut -d: -f 2)

# Add the repository
sudo rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm

sudo yum -y install mesos marathon
sudo yum -y install mesosphere-zookeeper

sudo systemctl start zookeeper
sudo systemctl stop mesos-slave.service
sudo systemctl disable mesos-slave.service

systemctl stop mesos-slave.service
systemctl disable mesos-slave.service

#Zookeeper
ZKADDR="zk://"$IPADDR':2181/mesos'
CHGZKADDR="echo $ZKADDR > /etc/mesos/zk"

sudo bash -c "$CHGZKADDR"

sudo systemctl restart zookeeper
sudo systemctl restart mesos-master
sudo systemctl restart marathon

fi



