#!/bin/bash

source ./main_common.sh
app_name=mysql

CHECK_ROOT


echo "Please enter MySql Root Password"  | tee -a $LOG_FILE
read -s MYSQL_ROOT_PASSWORD

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySql"


systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "Enabling MySql Service"

systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "Starting MySql Service" 

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD
VALIDATE $? "Setting MySql Root Password"

PRINT_TIME
