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

mongosh --host mongodb.daws84s.site </app/db/master-data.js
VALIDATE $? "Loading data to mongodb"

PRINT_TIME
