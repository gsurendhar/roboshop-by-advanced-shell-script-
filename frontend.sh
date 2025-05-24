#!/bin/bash

source ./main_common.sh
app_name=frontend

CHECK_ROOT


dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? " Disabling Default nginx "

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "Enabling Nginx:1.24 "

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginx:1.24"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling Nginx service"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing Default Content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip  &>>$LOG_FILE
VALIDATE $? "Downloading Frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Unzipping Frontend"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Removing Default nginx conf file"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Adding nginx conf file"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarting Nginx"

PRINT_TIME