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

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing MySQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enablelling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up root password"

#below code will be idempotence in nature

mysql -h db.b12nagafacebook.xyz -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "mysql root password set up"
else 
    echo -e "MySQL root password already setup...$Y SKIPPING $N"
fi
    
