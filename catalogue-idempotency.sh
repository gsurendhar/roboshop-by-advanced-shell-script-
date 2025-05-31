#!/bin/bash
source ./main_common.sh
app_name=catalogue

CHECK_ROOT

APP_SETUP

NODEJS_SETUP

SYSTEMD_SETUP

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo 

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing Mongodb Client"

STATUS=$(mongosh --host mongodb.gonela.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")') &>>$LOG_FILE
if [ $STATUS -lt 0 ]
then 
    mongosh --host mongodb.gonela.site < /app/db/master-data.js
    VALIDATE $? "Loading the Data into MongoDB"
else    
    echo -e "Data is already loaded ....$Y SKIPPING $N "
fi

PRINT_TIME