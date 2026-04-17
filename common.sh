#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOGS_FOLDER
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws88s.online

START_TIME=$(date +%s)
echo "$(date "+%Y-%m-%d :%H:%M:%S") |scrit started executing at :$(date)" | tee -a $LOGS_FILE
check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
        exit 1
    fi
}



VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e" $(date "+%Y-%m-%d :%H:%M:%S") |$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d :%H:%M:%S") |$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

NODEJS_SETUP(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disabling NodeJS Default version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling NodeJS 20"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Install NodeJS"

    npm install  &>>$LOGS_FILE
    VALIDATE $? "Installing dependencies"

}
APP_SETUP(){
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Creating system user"
    else
        echo -e "Roboshop user already exist ... $Y SKIPPING $N"
    fi

    mkdir -p /app 
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$APPNAME.zip https://roboshop-artifacts.s3.amazonaws.com/$APPNAME-v3.zip  &>>$LOGS_FILE
    VALIDATE $? "Downloading $APPNAME code"

    cd /app
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$APPNAME.zip &>>$LOGS_FILE
    VALIDATE $? "Uzip $APPNAME code"
}
SYSTEMD_SETUP(){
    cp $SCRIPT_DIR/$APPNAME.service /etc/systemd/system/$APPNAME.service
    VALIDATE $? "Created systemctl service"

    systemctl daemon-reload
    systemctl enable $APPNAME  &>>$LOGS_FILE
    systemctl start $APPNAME
    VALIDATE $? "Starting and enabling $APPNAME"
}    

APP_RESTART(){          
    systemctl restart catalogue
    VALIDATE $? "Restarting catalogue"
}

PRINT_TOTAL_TIME(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME -$START_TIME))
    echo -e "$(date "+%Y-%m-%d :%H:%M:%S") |script exicuted at the total time : $G  $TOTAL_TIME seconds $Y " | tee -a $LOGS_FILE

}