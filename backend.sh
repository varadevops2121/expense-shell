#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
     then 
     echo -e "$2...$R FAILURE $N"
     exit 1
    else
     echo -e "$2...$G SUCCESS $N"  
    fi
}

if [ $USERID -ne 0 ]
then 
    echo "please run this script with root access"
    exit 1 # manually exit if error comes.
else 
    echo "you are super user"
fi

dnf module disable nodejs -y &>>$LOGFILE 
VALIDATE $? "Disanleing default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enableing nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
    useradd expense  &>>$LOGFILE
    VALIDATE $? "creating expense user"
else
    echo -e "Expense user alreadecreated... $Y SKIPPING $N"
fi






