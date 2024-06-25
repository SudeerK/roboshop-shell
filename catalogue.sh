#!/bin/bash

ID=$( id -u )
echo "Value of ID is : $ID"
echo "Script Name is : $0"
TimeStamp=$(date +%F-%H-%M-%S)
echo "The script execution started at : $TimeStamp"
LogFile="/tmp/$0-$TimeStamp.log"
echo "LogFile name is :$LogFile"

MONGODB_HOST=mongo1.sudeer.cloud
R="\e[31m" #Red Color
G="\e[32m" #Green Color
Y="\e[33m" #Yellow
N="\e[0m"  #Normal Color

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then
    echo -e "$1..$R Failed$N"
    #exit 1
    else
    echo -e "$2 $G Passed$N"
    fi
}
if [ $ID -ne 0 ]
then 
echo -e "$R Error:: Not a root user$N"
else 
echo -e "$G Logged in as root user$N"
fi

dnf module disable nodejs -y &>>$LogFile
VALIDATE $? "Disabling NodeJS"

dnf module enable nodejs:18 -y &>>$LogFile
VALIDATE $? "Enabling NodeJS 18"

dnf install nodejs -y &>>$LogFile
VALIDATE $? "Installing NodeJS"

id roboshop #Check for roboshop user already exits
if [$? -ne 0 ]
then
useradd roboshop &>>$LogFile
VALIDATE $? "RoboShop user creation"
else 
echo -e "Roboshop user already exists.. $Y Skipping $N"
fi

#mkdir /app  &>>$LogFile
mkdir -p /app &>>$LogFile #If dir available then it will not create else will create.

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

dnf install mongodb-org-shell -y &>>$LogFile
VALIDATE $? "Intalling MongoDB Shell"

mongo --host $MONGODB_HOST </app/schema/catalogue.js
VALIDATE $? "Loading Catalogue Data into MongoDB"