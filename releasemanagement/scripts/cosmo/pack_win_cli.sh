#!/bin/bash

#####################################################################
#install vagrant - https://www.vagrantup.com/downloads.html (1.6.2) #
#vagrant plugin install vagrant-aws (0.4.1)                         #
#vagrant plugin install unf                                         #
#####################################################################

source ../../cli_credentials.sh

function  exit_on_error {
      status=$?
      echo "exit code="$status    
      if [ $status != 0 ] ; then
         	echo "Failed (exit code $status)" 
		vagrant destroy -f windows            
		exit 1
      fi

}


rm -f /cloudify/cloudify-cli_*.exe


##destroy windows vm if exit
vagrant destroy -f windows
exit_on_error

vagrant up windows --provider=aws
exit_on_error

##get guest ip address
ip_address=`vagrant ssh-config windows | grep HostName | sed "s/HostName//g" | sed "s/ //g"`
echo "ip_address="$ip_address

##copy windows exe file
sudo chown tgrid -R /cloudify
sshpass -p 'abcd1234!!' scp -p vagrant@$ip_address:/home/vagrant/cloudify-cli-packager/packaging/windows/inno/Output/CloudifyCLI-3.0.exe /cloudify
exit_on_error

vagrant destroy -f windows
