#!/bin/bash

ID=$( id -u )
echo "Value of ID is : $ID"
echo "Script Name is : $0"
TimeStamp=$(date +%F-%H-%M-%S)
echo "The script execution started at : $TimeStamp"
LogFile="/tmp/$0-$TimeStamp.log"
echo "LogFile name is :$LogFile"

MONGODB_HOST=mongo1.sudeer.cloud
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

#id roboshop
#if [$? -ne 0 ]
#then
useradd roboshop &>>$LogFile
VALIDATE $? "RoboShop user creation"
#else 
#echo "Roboshop user already exits.. Skipping"
#fi

mkdir /app  &>>$LogFile
# mkdir -p /app &>>$LogFile #If dir available then it will not create else will create.

VALIDATE $? "Creating App Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "Downloading Catalogue application"

cd /app 
unzip -o /tmp/catalogue.zip  &>>$LogFile #unzip -o means it will overwrite without any prompting
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

mongo --host $MONGODB_HOST </app/schema/catalogue.js
VALIDATE $? "Loading Catalogue Data into MongoDB"