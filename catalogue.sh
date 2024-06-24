#!/bin/bash

ID=( id -u )
echo "Value of ID is : $ID"
if [ $ID -ne 0 ]
then 
echo "Error:: Not a root user"
else 
echo "Logged in as root user"
fi
