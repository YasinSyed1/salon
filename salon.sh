#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  echo -e "\n~~~~~~~ Welcome to the Salon ~~~~~~~\n"
  echo -e "How may I help you?"

  MENU=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")

  echo "$MENU" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) Hair_Care;;
  2) Facial_Treatment;;
  3) Manicures_Pedicures;;
  4) Exit;;
  *) MAIN_MENU "Please select a valid option";;
  esac
}

Hair_Care(){
  echo "Hair_Care"
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL " SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  

  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    
  fi
  CUSTOMER_ID=$($PSQL " SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nEnter your service time,$CUSTOMER_NAME:"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

Facial_Treatment(){
  echo "Facial_Treatment"
}

Manicures_Pedicures(){
  echo "Manicures_Pedicures"
}

Exit(){
  echo "Thank You!!"
}

MAIN_MENU
