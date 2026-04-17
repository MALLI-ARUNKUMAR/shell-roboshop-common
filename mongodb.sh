#!/bin/bash

souece ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enable MongoDB"

systemctl restart mongod
VALIDATE $? "Start MongoDB"
PRINT_TOTAL_TIME