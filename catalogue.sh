#!/bin/bash

ID=$( id -u )
echo "Value of ID is : $ID"
echo "Script Name is : $0"
TimeStamp=$(date +%F-%H-%M-%S)
echo "The script execution started at : $TimeStamp"
LogFile="/tmp/$0-$TimeStamp.log"
echo "LogFile name is :$LogFile"

if [ $ID -ne 0 ]
then 
echo "Error:: Not a root user"
else 
echo "Logged in as root user"
fi
