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

if ($ID -ne 0)
then 
echo -e "$G Error:: Not a root user $N"
exit 1
else
echo -e "$R Logged in as root user $N"
fi

VALIDATE ()
{
    if ($? -ne 0)
    then
    echo -e "$2 - is $R unsuccessful $N"
    else
    echo -e "$2 - is $G Successful"
}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LogFile
VALIDATE $? "Copying of Mongo Repo"















ID=$( id -u )
echo "The value of ID: $ID"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at : $TIMESTAMP"

VALIDATE ()
{
    if ( $1 -ne 0 )
    then 
    echo "$2 .. FAILED"
    else
    echo "$2 .. PASSED"
    fi
}
if [ $ID -ne 0 ]
echo " ERROR:: Not a root user"
exit 1
else
echo " Logged in as root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copying of MongoDB Repo"

