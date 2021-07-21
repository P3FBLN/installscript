#!/bin/bash

#ask for user to add
while true
do
  echo "Please Enter new Username"
  read -p 'Username: ' username
  read -p "Frage: '$username' correct? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		break
	fi
done

SSH_FOLDER="/home/$username/.ssh"

read -p "Update und Upgrade? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "                   Package Update and Upgrades                         "
	echo "***********************************************************************"
	sudo apt-get update
	sudo apt-get upgrade --yes
fi

read -p "Public Key download? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "                     Download Public Key                               "
	echo "***********************************************************************"
	wget https://raw.githubusercontent.com/P3FBLN/installscript/main/id_ecdsa.pub
fi

read -p "User $username anlegen? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "  Add User $username please enter password when asked                    "
	echo "***********************************************************************"
	sudo adduser $username
fi

read -p "Public Key installieren? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "  check if .ssh folder exist if not create and copy key                "
	echo "***********************************************************************"
	#chek if ssh folder exists creates it if not
	if [ ! -d $SSH_FOLDER ]; then
	echo "SSH Folder wird angelegt"
	sudo mkdir $SSH_FOLDER
	sudo chown $username:$username $SSH_FOLDER
	sudo touch $SSH_FOLDER"/authorized_keys"
	fi

	cat id_ecdsa.pub | sudo tee --append $SSH_FOLDER/authorized_keys > /dev/null
	sudo chmod 600 $SSH_FOLDER"/authorized_keys"
	sudo chown $username:$username $SSH_FOLDER"/authorized_keys"
fi

read -p "$username den Gruppen hinzufügen? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "            add to groups"
	echo "***********************************************************************"
	sudo adduser $username adm
	sudo adduser $username dialout
	sudo adduser $username cdrom
	sudo adduser $username sudo
	sudo adduser $username audio
	sudo adduser $username video
	sudo adduser $username plugdev
	sudo adduser $username games
	sudo adduser $username users
	sudo adduser $username netdev
	sudo adduser $username input
	sudo adduser $username spi
	sudo adduser $username i2c
	sudo adduser $username gpio
fi

read -p "Aliase anlegen? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "            adds alias to .bashrc"
	echo "***********************************************************************"
	echo "alias ll='ls -lah'" | sudo tee --append /home/$username/.bashrc > /dev/null
	echo "alias sano='sudo nano'" | sudo tee --append /home/$username/.bashrc > /dev/null
	echo "alias top='htop'" | sudo tee --append /home/$username/.bashrc > /dev/null
fi

read -p "$username den sudoers hinzufügen? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "                      add $username to sudoers                           "
	echo "***********************************************************************"
	echo "$username ALL=(ALL:ALL) ALL" | sudo tee --append /etc/sudoers > /dev/null
fi

read -p "htop installieren? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "***********************************************************************"
	echo "                  install apacha2 and php5                             "
	echo "***********************************************************************"
	sudo apt-get install htop
fi
