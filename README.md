# Install requirements of Cloud 9 onto the EC2 Instances

## SSH into the server

	chmod 400 pauls-dev.pem
	ssh -i pauls-dev.pem ec2-user@[IP Address]

## Vim GCC and GLib right?
	sudo yum update -y;
	sudo yum install gcc-c++ make -y;
	sudo yum install gcc -y;
	sudo yum install openssl-devel -y;
	sudo yum install git -y;
	sudo yum install glibc-static -y;
	sudo yum install ncurses-devel -y;

## Node
	```bash
	sudo yum install git -y;
	git clone git://github.com/creationix/nvm.git ~/.nvm;
	source ~/.nvm/nvm.sh;
	echo "source ~/.nvm/nvm.sh" >> ~/.bash_profile;
	nvm install v0.12;
	nvm alias default v0.12;
	nvm which default;
	```

## Docker

Learn Docker at: https://www.docker.com/tryit/

	```bash
	sudo yum update -y; \
	sudo yum install docker -y; \
	sudo service docker start;
	```

#Connected with Cloud 9 

Login to the Team account of Cloud 9 which is Christian's account

go to C9 and copy paste the ssh key it provides you into your clip board

go to your terminal connected to the ec2 instance and run:
`vim ~/.ssh/authorized_keys`

Append the ssh public key from Cloud 9 into the file 
`AA` will move the curose to the end of the current line
press i to insert, then paste in the authorized key into a new line
to save pres the `esc` key and then type: `ZZ` 

Go back to the browser and click check login

Once you can connect to the server with the "team account" of Cloud 9 be sure to share the instance with your personal account and your team mates so you can collaborate

#Setup Baasbox the hard way

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

Build and Run Baasbox using Docker, assuming you have aws configured for china

#Setup Docker the easy way using our cache on AWS

	```bash
	mkdir ~/stamps-baasbox
	cd ~/stamps-baasbox
	aws s3 cp s3://baasbox-docker-stamps/v1 [PATH_TO_DISTINATION]
	sudo docker build . 
	sudo docker tag [output of previous command] tmcl/stamps-baasbox:v1
	```

Then run the instance with this run command

	sudo docker run -d \
	-p 9000:9000 --name stamps_bb \
	-v ~/stamps-baasbox/logs/baasbox:/opt/baasbox/logs \
	-v ~/stamps-baasbox/db:/opt/baasbox/db \
	-v ~/stamps-baasbox/logs/supervisor:/var/log/supervisor \
	tmcl/stamps-baasbox:v1

baasbox should now be running on the computer and accessible at the [public url]:9000

#Stop Baasbox and Docker

	sudo docker exec stamps_bb /usr/bin/supervisorctl stop all
	#wait
	sudo docker stop stamps_bb

#Setting up GitHub Access

Follow the steps on this tutorial:
https://help.github.com/articles/generating-ssh-keys/
Then you can download the projects you need from Github

