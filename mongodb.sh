#!/bin/bash

source ./main_common.sh
app_name=mongodb

CHECK_ROOT


cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$LOG_FILE
VALIDATE $? "Copying mongodb repo"

dnf install mongodb-org -y   &>>$LOG_FILE
VALIDATE $? "MongoDB installation"

systemctl enable mongod   &>>$LOG_FILE
VALIDATE $? "Enabling MongoDB Service "

systemctl start mongod    &>>$LOG_FILE
VALIDATE $? "Starting MongoDB Service "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf     &>>$LOG_FILE
VALIDATE $? "Editing mongodb conf file for remote connection "

systemctl restart mongod    &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB Service "

PRINT_TIME