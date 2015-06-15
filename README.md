# config-4-c9
My configuration for setting up cloud 9 on AWS

## SSH into the AWS server

	chmod 400 [aws_pem_file].pem
	ssh -i [aws_pem_file].pem ec2-user@[aws_public_url]

## Vim GCC and GLib right?
	sudo yum update -y;
	sudo yum install gcc-c++ make -y;
	sudo yum install gcc -y;
	sudo yum install openssl-devel -y;
	sudo yum install git -y;
	sudo yum install glibc-static -y;
	sudo yum install ncurses-devel;

## Node
	```bash
	sudo yum install git -y;
	git clone git://github.com/creationix/nvm.git ~/.nvm;
	source ~/.nvm/nvm.sh;
	echo "source ~/.nvm/nvm.sh" >> ~/.bash_profile;
	nvm install v0.10.28;
	nvm alias default v0.10.28;
	nvm which default;
	```

## Docker

Learn Docker at: https://www.docker.com/tryit/

	```bash
	sudo yum update -y; \
	sudo yum install docker -y; \
	sudo service docker start;
	```

#Get it connected with Cloud 9 

Login to a Cloud 9 account

copy paste the ssh key it provides you into your clip board

go to your terminal connected to the ec2 instance and run:
`vim ~/.ssh/authorized_keys`

Append the ssh public key from Cloud 9 into the file 
`AA` will move the curose to the end of the current line
press i to insert, then paste in the authorized key into a new line
to save pres the `esc` key and then type: `ZZ` 

Go back to the browser and click check login

#Setup Baasbox

Dockerfile :

	FROM library/java:8-jdk
	MAINTAINER Paul Wood <paul@paulwoodiii.com>
	RUN apt-get update -y                             && \
	    apt-get install supervisor build-essential  -y
	RUN mkdir -p /var/log/supervisor
	RUN mkdir -p /logs
	ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf
	ADD baasbox-0.9.2 /opt/baasbox
	RUN chmod 755 /opt/baasbox/start
	EXPOSE 80 9000
	CMD "/usr/bin/supervisord"
	

supervisor.conf :

	[supervisord]
	nodaemon=true
	
	[program:baasbox]
	command= /opt/baasbox/start
	environment=PORT="9000"
	stdout_logfile=/logs/baasbox.log
	stdout_logfile_maxbytes=1GB
	redirect_stderr=true

Build and Run Baasbox using Docker

	```bash
	wget http://www.baasbox.com/download/baasbox-stable.zip;
	unzip baasbox-stable.zip;
	touch Dockerfile;
	# edit dockerfile with copy from other server
	touch supervisor.conf;
	# edit supervisor.conf with copy from other server
	sudo docker build .;
	sudo docker run \
	-p 9000:9000 \
	-v ~/baasbox-docker/logs/baasbox:/opt/baasbox/logs \
	-v ~/baasbox-docker/db:/opt/baasbox/db \
	-v ~/baasbox-docker/logs/supervisor:/var/log/supervisor
	```

	sudo docker run paulwoodiii/baasbox:latest \
	-p 9000:9000 \
	-v ~/baasbox-docker/logs/baasbox:/opt/baasbox/logs \
	-v ~/baasbox-docker/db:/opt/baasbox/db \
	-v ~/baasbox-docker/logs/supervisor:/var/log/supervisor

Baasbox should now be running on the computer and accessible at the [public url]:9000

#Setting up GitHub Access

Follow the steps on this tutorial:
https://help.github.com/articles/generating-ssh-keys/
Then you can download the projects you need from Github

