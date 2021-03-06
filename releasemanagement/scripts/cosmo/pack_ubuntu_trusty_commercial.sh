#!/bin/bash

#####################################################################
#install vagrant - https://www.vagrantup.com/downloads.html (1.6.2) #
#vagrant plugin install vagrant-aws (0.4.1)                         #
#vagrant plugin install unf                                         #
#####################################################################

source ../../../credentials.sh
source /etc/environment

function  exit_on_error {
      status=$?
      echo "exit code="$status    
      if [ $status != 0 ] ; then
         	echo "Failed (exit code $status)" 
		vagrant destroy -f ubuntu_trusty_commercial_aws            
		exit 1
      fi

}

sudo mkdir -p /cloudify
sudo chown tgrid -R /cloudify
sudo mkdir -p /cloudify_tmp
sudo chown tgrid -R /cloudify_tmp
#rm -f /cloudify/cloudify-ubuntu-agent*


##destroy ubuntu vm if exit
vagrant destroy -f ubuntu_trusty_commercial_aws

vagrant up ubuntu_trusty_commercial_aws --provider=aws
exit_on_error

##get guest ip address
ip_address=`vagrant ssh-config ubuntu_trusty_commercial_aws | grep HostName | sed "s/HostName//g" | sed "s/ //g"`
echo "ip_address="$ip_address

##copy ubuntu deb file
sudo mkdir -p /cloudify
sudo chown tgrid -R /cloudify
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/.ssh/aws/vagrant_build.pem ubuntu@$ip_address:/cloudify/*.deb /cloudify_tmp
exit_on_error
mv /cloudify_tmp/cloudify-ubuntu-trusty-agent*.deb /cloudify_tmp/cloudify-ubuntu-trusty-commercial-agent.deb
exit_on_error
cp /cloudify_tmp/cloudify-ubuntu-trusty-commercial-agent.deb /cloudify
exit_on_error

vagrant destroy -f ubuntu_trusty_commercial_aws
