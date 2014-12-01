#! /bin/bash -e

#print env variables
echo "cloudify_packager_dir=$cloudify_packager_dir"


install_docker()
{
  curl -sSL https://get.docker.com/ubuntu/ | sudo sh
}

clone_packager()
{
  git clone https://github.com/cloudify-cosmo/cloudify-packager.git $1
}

# $1 - path to dockerfile folder
# $2 - docker build command
build_image()
{
  pushd $1
    # docker build sometimes failes for no reason. Retry 
    for i in 1 2 3 4 5 
    do sudo docker build -t $2 . && break || sleep 2; done
  popd
}

build_images()
{ 
  echo "###Building cloudify stack image"
  build_image $cloudify_packager_dir/docker cloudify:latest
  echo "###Building cloudify data image"
  build_image $cloudify_packager_dir/docker/data_container data:latest
}

start_and_export_containers()
{
  sudo docker run -t --name=cloudify -d cloudify:latest /bin/bash
  sudo docker run -t -d --name data data /bin/bash
  sudo docker export cloudify > /cloudify/cloudify_docker
  sudo docker export data > /cloudify/cloudify_docker_data
}

main() 
{
  build_images
  start_and_export_containers
}

main
