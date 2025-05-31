#!/bin/bash
source ./main_common.sh
app_name=redis

CHECK_ROOT

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling Default Redis "

dnf module enable redis:7 -y  &>>$LOG_FILE
VALIDATE $? "Enabling Redis:7 "

dnf install redis -y   &>>$LOG_FILE
VALIDATE $? "Installing Redis:7 "

sed -i -e '/s/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf  &>>$LOG_FILE
VALIDATE $? "Edited Redis conf file to accept remote connections"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling Redis service"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Starting the Redis service"

PRINT_TIME