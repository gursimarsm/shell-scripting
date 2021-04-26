#!/usr/bin/bash 
adduser() {
tput setaf 3
echo "-------------------ADD USER----------------------"
tput setaf 7
while :
do

  read -p "Username: " adduser
  read  -s -p "Password: " pass
  echo -e ""
  read -s -p "Confirm Password:"  cpass

  if [ -z $adduser ] && [ -z $pass ]
  then
    echo "You provided an empty username or password"
  else
    if id $adduser &> /dev/null 
    then
      echo "User $adduser already exist in the database.."
    else
      if [ $pass == $cpass ] &&  useradd $adduser && echo $pass | passwd --stdin $adduser
      then
        echo "User $adduser created successfully.."
        break
      else
        echo "User creation failed.."
      fi
    fi
  fi
done
return 1
}

deluser() {
tput setaf 3
echo "-------------------DELETE USER-------------------"
tput setaf 7
while :
do

  read -p "Username: "  deluser
  if [ -z $deluser ]
  then
    echo "Username should not be empty.."
  elif  id $deluser &> /dev/null 
  then
    userdel $deluser
    echo "User $deluser deleted successfully.."
    break
  else
    echo "User $deluser not exist provide a valid username.."
  fi
done
return 1
}


lockuser() {
tput setaf 3
echo "------------------LOCK USER----------------------"
tput setaf 7
while :
do
  read -p "Enter the username to lock & backup: " user
  if [ -z $user ]
  then
    echo "Provided username not exit.."
  else
    if id $user &> /dev/null
    then
      passwd  -l $user
      homedir=$(grep ^${user}: /etc/passwd | cut -f 6 -d ":")
      if [ -d $homedir ]
	then
	  echo "Home directory $homedir exist.."
	  tar -cf ${user}-`date +%F`.tar  $homedir
	 fi

      break
    else
      echo "Provided user $user not exist.."
    fi
  fi
done
return 0
}

menu() {
while :
do

  
  tput setaf 2
  echo -e "Press 1: ADDUSER \nPress 2: DELETEUSER \nPress 3: LOCK & BACKUP USER \nPress 4: Exit"
  read n
  tput setaf 7

  if [ $n -eq 1 ]
  then
    adduser
    
  elif [ $n -eq 2 ]
  then
    deluser
    
  elif [ $n -eq 3 ]
  then
    lockuser
     
  elif [ -z $n ]
  then 
    echo "Press any option..."
  elif [ $n == 4 ]
  then
    exit 130
  else
    echo "Press a valid option.. " 
  fi

done

exit 0
 
}


menu