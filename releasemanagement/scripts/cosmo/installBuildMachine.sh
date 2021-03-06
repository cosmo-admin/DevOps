
sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git
sudo apt-get install -y python-setuptools python-dev build-essential
sudo apt-get install -y python-pip
sudo pip install virtualenv jinja2

#copy scripts
sudo apt-get install -y subversion

#docker integration tests
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker -y
sudo docker build --rm=true --tag="cosmo_tests" . (. is the location of Dockfile)
 
#build ui
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs -y
sudo npm install bower -g
sudo npm install -g grunt-cli

(Install rvm 
rvm install ruby-2.1.0
rvm use ruby-2.1.0
gem install bundler
)
rvm pkg install libyaml
rvm reinstall ruby-2.1.0
gem install compass

#packager
 # update
      sudo apt-get -y update &&

      # install prereqs
      sudo apt-get install -y vim make &&
      sudo apt-get install -y rubygems &&
*** to install fpm on root and not on user tgrid (sudo su ; gem install fpm --no-ri --no-rdoc)
      gem install fpm --no-ri --no-rdoc &&
      sudo apt-get -y purge ##pip
      ##sudo easy_install -U pip &&
      #sudo wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | sudo python &&
      sudo pip install virtualenv==1.11.4 jinja2==2.7.2 pika==0.9.13 fabric==1.8.3 &&
      ###cd /opt && sudo git clone https://github.com/sstephenson/ruby-build.git && cd /opt/ruby-build &&
      ###export PREFIX=/opt/ruby-build && sudo ./install.sh &&

      # configure gem and bundler
      ###echo -e 'gem: --no-ri --no-rdoc\ninstall: --no-rdoc --no-ri\nupdate:  --no-rdoc --no-ri' >> ~/.gemrc

      # create packman logfile
      sudo mkdir -p /var/log/packman &&
      sudo touch /var/log/packman/packman.log &&
*** sudo chown tgrid -R /var/log/packager/
    #sudo apt-get install rpm

#package cli
sudo dpkg -i vagrant_1.6.5_x86_64.deb
vagrant plugin install vagrant-aws --plugin-version 0.5.0
sudo vim /etc/environment
VAGRANT_HOME=/home/vagrant/
sudo apt-get install -y sshpass

#upload packages
sudo pip install boto 
apt-get install -y tofrodos

#packer
sudo apt-get update
sudo apt-get -y install unzip
unzip 0.6.1_linux_amd64.zip -d ~/packer
add to PATH ~/packer

#travis
sudo pip install requests
sudo pip install pyyaml

#quickbuild
sudo apt-get update
sudo apt-get install -y openjdk-7-jdk
copy buildagent.tar.gz to /opt
tar -xvzf buildagent.tar.gz
edit buildagent/bin/agent.sh RUN_AS=tgrid
sudo ./agent.sh install
sudo service quickbuild start

#s3cmd
sudo apt-get install s3cmd
s3cmd --configure

'''
Enter new values or accept defaults in brackets with Enter.
Refer to user manual for detailed description of all options.

Access key and Secret key are your identifiers for Amazon S3
Access Key: **xxxxxxxxxxxxxxxxxxxxxx**
Secret Key: **xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx**

Encryption password is used to protect your files from reading
by unauthorized persons while in transfer to S3
Encryption password: **[make up a password here; you don't have to remember it]**
Path to GPG program [/usr/bin/gpg]: **[Hit enter]**

When using secure HTTPS protocol all communication with Amazon S3
servers is protected from 3rd party eavesdropping. This method is
slower than plain HTTP and can't be used if you're behind a proxy
Use HTTPS protocol [No]: **Yes**

New settings:
  Access Key: xxxxxxxxxxxxxxxxxxxxxx
  Secret Key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  Encryption password: xxxxxxxxxx
  Path to GPG program: /usr/bin/gpg
  Use HTTPS protocol: True
  HTTP Proxy server name:
  HTTP Proxy server port: 0

Test access with supplied credentials? [Y/n] **Y**
Please wait, attempting to list all buckets...
Success. Your access key and secret key worked fine :-)

Now verifying that encryption works...
Success. Encryption and decryption worked fine :-)

Save settings? [y/N] **y**
Configuration saved to '/root/.s3cfg'
'''
