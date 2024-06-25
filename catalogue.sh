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
    echo "$1 Failed"
    exit 1
    else
    echo "$2 Passed"
    fi
}
if [ $ID -ne 0 ]
then 
echo "Error:: Not a root user"
else 
echo "Logged in as root user"
fi

dnf module disable nodejs -y &>>$LogFile
VALIDATE $? "Disabling NodeJS"
dnf module enable nodejs:18 -y &>>$LogFile
VALIDATE $? "Enabling NodeJS 18"

dnf install nodejs -y &>>$LogFile
VALIDATE $? "Installing NodeJS"

useradd roboshop &>>$LogFile
VALIDATE $? "Creating RoboShop user"

mkdir /app  &>>$LogFile
VALIDATE $? "Creating App Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Downloading Catalogue application"

cd /app 
unzip /tmp/catalogue.zip  &>>$LogFile
VALIDATE $? "Unziping Catalogue application"

cd /app

npm install  &>>$LogFile
VALIDATE $? "Installing dependencies"

#currently we are in cd /app location, but our catalogue.service is in another location. Hence use absolute path.
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service  &>>$LogFile
VALIDATE $? "Copying of Catalogue Service"

systemctl daemon-reload  &>>$LogFile
VALIDATE $? "Catalogue Daemon Reload"

systemctl enable catalogue  &>>$LogFile
VALIDATE $? "Enabling Catalogue Service"

systemctl start catalogue  &>>$LogFile
VALIDATE $? "Starting Catalogue Service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LogFile
VALIDATE $? "Copying of MongoDB Repo"

dnf install mongodb-org-shell -y
VALIDATE $? "Intalling MongoDB Shell"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
VALIDATE $? "Loading Catalogue Data into MongoDB"