#!/bin/bash

ID=$( id -u )
echo "Value of ID is : $ID"
echo "Script Name is : $0"
TimeStamp=$(date +%F-%H-%M-%S)
echo "The script execution started at : $TimeStamp"
LogFile="/tmp/$0-$TimeStamp.log"
echo "LogFile name is :$LogFile"

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then
    echo "$1 is unsuccessful"
    else
    echo "$2 is successful"
    fi
}
if [ $ID -ne 0 ]
then 
echo "Error:: Not a root user"
else 
echo "Logged in as root user"
fi

dnf module disable nodejs -y
VALIDATE $? "NodeJS is disabled"
dnf module enable nodejs:18 -y
VALIDATE $? "NodeJS 18 is enabled"