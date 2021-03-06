import os
import sys
import subprocess
import shutil
import pip
from fabric.api import * #NOQA


pypi_branch_name=pypi-release

import yoci.travis.functional_api

#set variables
core_branch_name=3.3m7
plugins_branch_name=1.3m7
parent_repo='cloudify-cosmo/'
repo_list=['cloudify-cli','cloudify-plugins-common','cloudify-dsl-parser','cloudify-rest-client','cloudify-script-plugin','cloudify-diamond-plugin']

def test():
        print "### Creating virtualenv"
        if os.path.exists('env'):
                shutil.rmtree('env')
        os.system('virtualenv env')
        os.chdir('env')
        print "### Activating virtualenv"
        os.system('. bin/activate')
        print "### Install modules from pypi"
        modules = ['cloudify', 'cloudify-diamond-plugin']
        for module in modules:
                pip.main(['install', '--pre', '{0}'.format(module)]) 
        for module in repo_list:
                print '{0} -'.format(module)
                pip.main(['show', '{0} | grep Version:'.format(module)])
        if os.path.exists('env'):
                shutil.rmtree('env')


def remove_pypi_release_branch():
        print "remove_pypi_release_branch"
        print os.getcwd()
        local('git checkout master',capture=False)
        local('git pull',capture=False)
        with settings(warn_only=True):
                result=local('git branch | grep {0}'.format(pypi_branch_name,capture=False))
                if result.return_code == 0:
                        local('git branch -D {0}'.format(pypi_branch_name),capture=False)
                result=local('git branch -r | grep origin/{0}'.format(pypi_branch_name,capture=False))
                if result.return_code == 0:
                        local('git push origin --delete {0}'.format(pypi_branch_name),capture=False)


if __name__ == '__main__':

	parent_dir=os.path.abspath('..')
	print("root dir: "+parent_dir)
	os.chdir(parent_dir)
	print os.getcwd()
	fail_repos=""

	for repo in repo_list:
    print "### Create pypi branch for repository: {0}".format(repo)
    #get tag name
      	os.chdir('yo-ci')
        	get_name=subprocess.Popen(['bash', '-c', '. generic_functions.sh ; get_version_name {0} {1} {2}'.format(repo, core_branch_name, plugins_branch_name)],stdout = subprocess.PIPE).communicate()[0]
		tag_name=get_name.rstrip()

		print "current_location="+os.getcwd()
		print "tag_name="+tag_name
        	os.chdir(os.path.abspath('..'))
        
        	os.chdir(repo)
        	#Remove pypi_release_branch if exist
        	remove_pypi_release_branch()
        	local('git pull origin master',capture=False)
        	local('git reset --hard origin/master',capture=False)
        	local('git checkout -b {0} {1}'.format(pypi_branch_name,tag_name),capture=False)
        	local('git push origin {0}'.format(pypi_branch_name),capture=False)
        	os.chdir(os.path.abspath('..'))
	
	        os.chdir(os.path.abspath('..'))
	       
	test()
