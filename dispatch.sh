#!/bin/bash

source ./main_common.sh
app_name=dispatch
CHECK_ROOT

APP_SETUP

dnf install golang -y &>>$LOG_FILE
VALIDATE $? "Installing GoLang"

go mod init dispatch &>>$LOG_FILE
go get  &>>$LOG_FILE
go build  &>>$LOG_FILE
VALIDATE $? "Installing Dependencies"

SYSTEMD_SETUP

PRINT_TIME