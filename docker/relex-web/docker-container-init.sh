#!/bin/bash

# Create the directory needed to run the sshd daemon
mkdir /var/run/sshd

# Add docker user and generate a random password with 12 characters that includes at least one capital letter and number.
DOCKER_PASSWORD=`pwgen -c -n -1 12`
echo User: docker Password: $DOCKER_PASSWORD
DOCKER_ENCRYPYTED_PASSWORD=`perl -e 'print crypt('"$DOCKER_PASSWORD"', "aa"),"\n"'`
useradd -m -d /home/docker -p $DOCKER_ENCRYPYTED_PASSWORD docker
sed -Ei 's/adm:x:4:/docker:x:4:docker/' /etc/group
adduser docker sudo

# Set the default shell as bash for docker user.
chsh -s /bin/bash docker

# Copy the config files into the docker directory
#cd /src; tar -C /home/docker -xvf config.tar

#Set all the files and subdirectories from /home/docker with docker permissions.
chown -R docker:docker /home/docker /relex

# restarts the xdm service
#/etc/init.d/xdm restart

# Start the ssh service
/usr/sbin/sshd -D

# Start LinkGrammar and RelEx servers
cd /relex ; ./heroku-webapp-servers.sh
