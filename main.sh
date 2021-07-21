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
