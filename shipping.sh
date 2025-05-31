#!/bin/bash
source ./main_common.sh
app_name=shipping

CHECK_ROOT

APP_SETUP

MAVEN_SETUP

SYSTEMD_SETUP

echo "Please enter MySql Root Password"  | tee -a $LOG_FILE
read -s MYSQL_ROOT_PASSWORD

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing MySql Client"

mysql -h mysql.gonela.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql  &>>$LOG_FILE
VALIDATE $? "Loading SCHEMAS to MySQL"

mysql -h mysql.gonela.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql &>>$LOG_FILE
VALIDATE $? "Loading APP-USER DATA to MySQL"

mysql -h mysql.gonela.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql &>>$LOG_FILE
VALIDATE $? "Loading MASTER_DATA to MySQL"

systemctl restart shipping  &>>$LOG_FILE
VALIDATE $? "Restarting Shipping Services" 

PRINT_TIME