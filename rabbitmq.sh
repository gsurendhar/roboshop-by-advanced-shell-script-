#!/bin/bash
source ./main_common.sh
app_name=rabbitmq

CHECK_ROOT

echo "Please enter RabbitMQ Password"  | tee -a $LOG_FILE
read -s RABBITMQ_PASSWORD

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Copying Rabbitmq Repo file"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing RabbitMQ"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling RabbitMQ Service"

systemctl start rabbitmq-server  &>>$LOG_FILE
VALIDATE $? "Starting RabbitMQ Service"

rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD  &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOG_FILE
VALIDATE $? "Giving All permissions to ALL QUEUES"

PRINT_TIME