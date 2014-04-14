#####################################################
# 	installations for packaging server	          #
#####################################################						
# apt-get update
# make
# python setup-tools python-dev fabric
# ruby2.1
# gem install fpm
# pip
# pip install virtualenv jinja2
# create log dirs:
# sudo mkdir -p /var/log/packager &&
#       sudo touch /var/log/packager/packager.log &&
#####################################################

import commands
import sys
import os
import shutil, errno
from fabric.api import * #NOQA
from get import *  # NOQA
from pkg import *  # NOQA
import packages
from packman import *  # NOQA
import glob
import params
from boto.s3.connection import S3Connection

#os.environ["TARZAN_BUILDS"]="/export/builds/cloudify3"
#os.environ["PACK_COMPONENTS"]="yes" 
#os.environ["PACK_CORE"]="yes" 
#os.environ["PACK_UI"]="yes"
#os.environ["BUILD_NUM"]="1-1"  
#os.environ["CONFIGURATION_NAME"]="NightlyBuild" 

TARZAN_BUILDS=os.environ["TARZAN_BUILDS"] 
PACK_COMPONENTS=os.environ["PACK_COMPONENTS"]
PACK_CORE=os.environ["PACK_CORE"]
PACK_UI=os.environ["PACK_UI"]
BUILD_NUM=os.environ["BUILD_NUM"]
CONFIGURATION_NAME=os.environ["CONFIGURATION_NAME"]

print TARZAN_BUILDS 
print PACK_COMPONENTS
print PACK_CORE
print PACK_UI
print BUILD_NUM
print CONFIGURATION_NAME

def mkdirp(directory):
    if not os.path.isdir(directory):
        os.makedirs(directory)

def copy_dir(src,dst):
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.copytree(src, dst)

current_dir=os.path.dirname(os.path.realpath(__file__))
print("current dir: "+current_dir)
parent_dir=os.path.abspath('../..')
print("root dir: "+parent_dir)

cloudify_components_conf = packages.PACKAGES['cloudify-components']
cloudify_core_conf = packages.PACKAGES['cloudify-core']
cloudify_ui_conf = packages.PACKAGES['cloudify-ui']
ubuntu_agent_conf = packages.PACKAGES['ubuntu-agent']

## copy cloudify3 package
PACKAGE_SOURCE_PATH='{0}'.format(cloudify_core_conf['package_path'])
if CONFIGURATION_NAME == "NightlyBuild":
	PACKAGE_DEST_DIR="nightly"
else:
	PACKAGE_DEST_DIR="continuous"
PACKAGE_DEST_BUILD_DIR=PACKAGE_DEST_DIR+"_"+BUILD_NUM
PACKAGE_DEST_PATH="org/cloudify3/"+PACKAGE_DEST_DIR
PACKAGE_DEST_BUILD_PATH="org/cloudify3/"+PACKAGE_DEST_BUILD_DIR

print "check that all deb files exist in /cloudify folder"

#This will be removed when the pkg_components will be ready
if PACK_COMPONENTS == "yes":
	print "copy 3rd parties deb from /packages folder"
	shutil.copyfile('/packages/cloudify3-components_3.0.0_amd64.deb','{0}/cloudify-components_3.0.0_amd64.deb'.format(PACKAGE_SOURCE_PATH))

components_package = glob.glob('{0}/{1}*.deb'.format(PACKAGE_SOURCE_PATH,cloudify_components_conf['name']))
print components_package
core_package = glob.glob('{0}/{1}*.deb'.format(PACKAGE_SOURCE_PATH,cloudify_core_conf['name']))
print core_package
ui_package = glob.glob('{0}/{1}*.deb'.format(PACKAGE_SOURCE_PATH,cloudify_ui_conf['name']))
print ui_package
ubuntu_package = glob.glob('{0}/{1}*.deb'.format(PACKAGE_SOURCE_PATH,ubuntu_agent_conf['name']))
print ubuntu_package
filenames=[]


if PACK_COMPONENTS == "yes":
	if components_package:
		a=components_package[0].split("/")		
		filenames.append(a[2]) 
	else:
		print "*** components deb file is missing ***"
if PACK_CORE == "yes":	
	if core_package and ubuntu_package:
		a=core_package[0].split("/")		
		filenames.append(a[2])
		b=ubuntu_package[0].split("/")		
		filenames.append(b[2])		
	else:
		print "*** core deb files are missing ***"
if PACK_UI == "yes":
	if ui_package:
		a=ui_package[0].split("/")		
		filenames.append(a[2])	
	else:
		print "*** ui deb file is missing ***"
print filenames

#commands.getoutput('sudo chown tgrid -R {0}'.format(PACKAGE_SOURCE_PATH))
local('sudo chown tgrid -R {0}'.format(PACKAGE_SOURCE_PATH),capture=False)


print "uploading cloudify3 packages to s3 and tarzan/builds"


os.chdir( PACKAGE_SOURCE_PATH )
conn = S3Connection(aws_access_key_id=params.AWS_KEY, aws_secret_access_key=params.AWS_SECRET)
for fname in filenames:				
	mkdirp(TARZAN_BUILDS+"/"+PACKAGE_DEST_DIR)
	shutil.copyfile(PACKAGE_SOURCE_PATH+"/"+fname,TARZAN_BUILDS+"/"+PACKAGE_DEST_DIR+"/"+fname)
	
	mkdirp(TARZAN_BUILDS+"/"+PACKAGE_DEST_BUILD_DIR)
	shutil.copyfile(PACKAGE_SOURCE_PATH+"/"+fname,TARZAN_BUILDS+"/"+PACKAGE_DEST_BUILD_DIR+"/"+fname)

    	bucket = conn.get_bucket("gigaspaces-repository-eu")  
	full_key_name = os.path.join(PACKAGE_DEST_BUILD_PATH, fname)   	 	
	key = bucket.new_key(full_key_name).set_contents_from_filename(fname, policy='public-read')
	   		
    	full_key_name = os.path.join(PACKAGE_DEST_PATH, fname)   	 	
	key = bucket.new_key(full_key_name).set_contents_from_filename(fname, policy='public-read') 		
   	print "uploaded file %s" % fname



