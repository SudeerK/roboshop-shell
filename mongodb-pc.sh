#!/bin/bash

ID=$( id -u )
echo "The value of ID is :$ID"
echo "ScriptName is : $0"


TimeStamp=$( date +%F-%H-%M-%S )
LOGFILE="/tmp/$0-$TimeStamp.log"

R="\e[31m" #Red
G="\e[32m" #Green
Y="\e[33m" #Yellow
N="\e[0m"  #Normal color

if [ $ID -ne 0 ]
then
echo -e "$R Not a root user"
else 
echo -e "$G logged in as root user"
fi

VALIDATE()
{
if [ $1 -ne 0 ]
then 
echo -e "$2 - $R Failed $N"
else 
echo -e "$2 - $G Passed $N"
fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $?,"Copying of Mongo DB Repo"

dnf install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installing of Mongo DB"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabling of Mongo DB"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "Starting of Mongo DB"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "Remote access to Mongo DB"

systemctl restart mongod
VALIDATE $? "Restarting of Mongo DB"