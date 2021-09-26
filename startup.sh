#! /bin/bash
# The following startup script is tested on GCP instance with os image Listed below
# ubuntu-1804-bionic-v20210825
LOGIN_USER=bmabir
STARTUP_SUCCESS_FILE=/home/$LOGIN_USER/.ran-startup-script

if test ! -f "$STARTUP_SUCCESS_FILE"; then
	echo "$STARTUP_SUCCESS_FILE does not exist. running startup..."

	# add user
	sudo useradd -m $LOGIN_USER ||

	# no more 'sudo docker' after this
	sudo groupadd docker &&
	sudo usermod -aG docker $LOGIN_USER &&
	newgrp docker
	#install Nvidia Driver(Only for GCP Deeplearning Image)
	# sudo /opt/deeplearning/install-driver.sh

	#Install Gcloud (For Aws)
	# curl https://sdk.cloud.google.com > install.sh
	# bash install.sh --disable-prompts --install-dir=/home/$LOGIN_USER
	# export PATH=$PATH:/home/$LOGIN_USER/google-cloud-sdk/bin
	# source /home/$LOGIN_USER/google-cloud-sdk/completion.bash.inc
	# source /home/$LOGIN_USER/google-cloud-sdk/path.bash.inc


	# host machine requires nvidia drivers. tensorflow image should contain the rest required
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
	sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
	sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
	sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
	sudo apt-get update && sudo apt-get install -y cuda-drivers

	# install docker
	sudo apt-get update && apt-get install -y \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    gnupg-agent \
	    software-properties-common

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Install Nvidia-doceker2
	echo "Docker installed. Installing Nvidia-docker2"
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - 
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update && sudo apt-get install -y nvidia-docker2
	sudo systemctl restart docker

	#install Docker-compose
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	# create file which will be checked on next reboot
	touch /home/$LOGIN_USER/.ran-startup-script
	echo "Startup Script Ran Succesfully"
	
else
	echo "$STARTUP_SUCCESS_FILE exists. not running startup script!"
fi