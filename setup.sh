sudo yum update -y;
sudo yum install gcc-c++ make -y;
sudo yum install gcc -y;
sudo yum install openssl-devel -y;
sudo yum install glibc-static -y;
sudo yum install ncurses-devel -y;
#Install Git
sudo yum install git -y;
#Install Node.js
git clone git://github.com/creationix/nvm.git ~/.nvm;
source ~/.nvm/nvm.sh;
echo "source ~/.nvm/nvm.sh" >> ~/.bash_profile;
nvm install v0.10.35;
nvm alias default v0.10.35;
sudo yum install docker -y;
sudo service docker start;
sudo docker pull paulwoodiii/baasbox;
#vim ~/.ssh/authorized_keys;
#nvm which default;
