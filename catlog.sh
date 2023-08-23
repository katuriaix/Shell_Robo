#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/Shell_Robo-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? " downloded RPM "

yum install nodejs -y &>> $LOGFILE

VALIDATE $? " installed nodejs"

useradd roboshop &>> $LOGFILE
if [ $? -ne 0 ]; then
echo "user already exit"
else 
echo "user created"
fi
VALIDATE $? "user created "

mkdir /app &>> $LOGFILE
if [ $? -ne 0 ]; then
echo "dir already exit"
else 
echo "created dir"
fi
VALIDATE $? " created DIR app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? " Downloded path"

cd /app &>> $LOGFILE

VALIDATE $? "go to /app dir "

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unziped "

cd /app &>> $LOGFILE

VALIDATE $? " go to /app dir"

npm install -y &>> $LOGFILE

VALIDATE $? "NPM installed "

cp /home/centos/Shell_Robo/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? " Coped catalogue service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? " Reload daemon"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabled catalogu "

systemctl start catalogue &>> $LOGFILE

VALIDATE $? " Started catalog"

cp /home/centos/Shell_Robo/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "coped mongo.repo "

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installed mongo "

mongo --host mongo.katuri395.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? " connecting mongo"
