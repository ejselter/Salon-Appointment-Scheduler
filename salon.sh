#! /bin/bash

PSQL="psql -A -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ FreeCodeCamp Salon ~~~~~\n"

MAIN_MENU() {
echo -e "\nWelcome to The FreeCodeCamp Salon, how can I help you?"
echo -e "\n1) trim\n2) cut\n3) color\n4) extensions"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU ;;
    2) APPOINTMENT_MENU ;;
    3) APPOINTMENT_MENU ;;
    4) APPOINTMENT_MENU ;;
    *) MAIN_MENU "I could not find that service. How can I help you today?" ;;
  esac

}

APPOINTMENT_MENU() {
  # look up phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  GET_PHONE=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if phone not in system
  if [[ -z $GET_PHONE ]]
  then
    #ask for name
    echo -e "\nSorry, you aren't in our system. What's your name?"
    read CUSTOMER_NAME
    INSERT_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  #ask for appointment time
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
  #echo "$CUSTOMER_ID"
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME"
  read SERVICE_TIME
  INSERT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

}


MAIN_MENU