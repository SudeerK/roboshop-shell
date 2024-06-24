#!/bin/bash

ID=$( id -u )
echo "Value of ID is : $ID"
echo "Name of the script : $0"

R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow
N="\e[0m"  #Normal Color

TimeStamp=$(date +%F-%H-%M-%S)
echo "Script execution started at $TimeStamp"

LogFile="/tmp/$0-$TimeStamp.log"

if [ $ID -ne 0 ]
then 
echo -e "$R Error:: Not a root user $N"
exit 1
else
echo -e "$G Logged in as root user $N"
fi

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then
    echo -e "$2 - is $R unsuccessful $N"
    else
    echo -e "$2 - is $G Successful $N"
    fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LogFile
VALIDATE $? "Copying of Mongo Repo"

dnf list installed mongodb-org &>>$LogFile #trying to improvise by checking if package is already installed

if [ $? -ne 0 ]
then
dnf install mongodb-org -y &>>LogFile.log
else 
echo -e "$Y Package is already installed $N"
fi

VALIDATE $? "MongoDB installation"

systemctl enable mongod
VALIDATE $? "Enabling of MongoDB"

systemctl start mongod
VALIDATE $? "Starting of MongoDB"

