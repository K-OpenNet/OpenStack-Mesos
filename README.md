# OpenStack-Mesos: Mesos Clustering on OpenStack Cloud
======================

### What is OpenStack-Mesos?
OpenStack-Mesos is a provisioning and orchestration tool for HPC/BigData workloads which running on Mesos cluster with OpenStack cloud infrastructure. 

### Prerequisites
--------------------------
1. Installed base OS: Ubuntu 14.04 or CentOS 7

### Top-Level Features (now under developement)
--------------------------
* Provisioning bere-metal machines (OpenStack Ironic) and Mesos cluster (install and configuration of Mesos)
* Running HPC/BigData workloads using Mesos frameworks

### Using Mesos-Provisioning
--------------------------
1. Master: mesos-provision-master.sh [eth_interface]
2. Slave(s): mesos-provision-slave.sh [eth_interface] [master_ip]

Checkout out our [website](http://opennetworking.kr/projects/k-one-collaboration-project/wiki) for further Information about K-ONE Project

## Acknowledgement
--------------------------
This work was supported by Institute for Information & communications Technology Promotion(IITP) grant funded by the Korea government(MSIP)
(Global SDN/NFV OpenSource Software Module/Function Development)
