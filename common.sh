#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOGS_FOLDER

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

PRINT_TOTAL_TIME(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME -$START_TIME))
    echo -e "$(date "+%Y-%m-%d :%H:%M:%S") |script exicuted at the total time : $G  $TOTAL_TIME seconds $Y " | tee -a $LOGS_FILE

}