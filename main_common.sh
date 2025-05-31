#!/bin/bash
#variables
START_TIME=$(date +%S)
USERID=$(id -u)
SCRIPT_DIR=$PWD
LOG_FOLDER="/var/log/roboshop-shell-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOG_FOLDER
echo "Script execution started at $(date) " | tee -a $LOG_FILE

# ROOT PRIVILEGES CHECKING
CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then 
        echo -e " $R ERROR:$N Please run Script with the root access " | tee -a $LOG_FILE
        exit 1
    else 
        echo -e " You are already running with $Y ROOT $N access " | tee -a $LOG_FILE
    fi
}


# VALIDATION FUNCTION
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ........$G SUCCESSES $N"  | tee -a $LOG_FILE
    else    
        echo -e "$2 is .........$R FAILURE $N"   | tee -a $LOG_FILE
        exit 1
    fi
}

NODEJS_SETUP(){
    dnf module disable nodejs -y  &>>$LOG_FILE
    VALIDATE $? "Disabling Default nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enabling Default nodejs"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing nodejs:20 "

    npm install &>>$LOG_FILE
    VALIDATE $? "Installing Dependencies"
}

PYTHON_SETUP(){

    dnf install python3 gcc python3-devel -y &>>$LOG_FILE

    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "Installing Dependencies"

}

MAVEN_SETUP(){
    
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing MAVEN and JAVA"

    mvn clean package &>>$LOG_FILE
    VALIDATE $? "Packing the Sipping Application"

    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    VALIDATE $? "Moving and Renaming JAR file"
}


APP_SETUP(){
    id roboshop
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "Roboshop system user " roboshop 
        VALIDATE $? "Roboshop system user creating" 
    else
        echo -e "roboshop user is already Created ....$Y SKIPPING USER Creation $N"
    fi

    mkdir -p /app
    VALIDATE $? "Creating App directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name"

    cd /app 
    rm -rf /app/*
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Unzipping $app_name"

}

SYSTEMD_SETUP(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    VALIDATE $? "$app_name service file is copied "

    systemctl daemon-reload &>>$LOG_FILE
    VALIDATE $? "Daemon Reloading"

    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "$app_name is enabling"

    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "Staring the $app_name service"

}

PRINT_TIME(){
    END_TIME=$(date +%S)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo -e "Script Execution Completed Successfully, $Y time taken : $TOTAL_TIME Seconds $N " | tee -a $LOG_FILE
 }
