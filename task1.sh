#!/bin/bash
# The script sozdat polzovatelja iz txt s parametrami
echo "___Script for creation users___"
echo -e "\n\n"
echo "vse document s polzovateli iz txt raspolozeni v directory src"
echo -e "\n"
read -p "sprs file: " FILE_USERS
 
USERS_PATH="./src/$FILE_USERS"
if [[ -f $USERS_PATH ]]; then
        IFS=$'\n'
 
    for LINE in  `(cat $USERS_PATH)`
    do
 
 
        username=`echo "$LINE" | cut -d ":" -f1`
        user_group=`echo "$LINE" | cut -d ":" -f2`
        user_password=`echo "$LINE" | cut -d ":" -f3`
        ssl_password=`openssl passwd -1 "$user_password"`
        user_shell=`echo "$LINE" | cut -d ":" -f4`
 
        if ! grep -q $username "/etc/passwd";  then
            echo "$username was not i the system!"
            read -p "do yuo want create a new user $username? (yes/no): " ANS_NEW
            case $ANS_NEW in
                [yY]|[yY][eE][sS])
                    if [[ `grep $user_group /etc/group` ]]; then
                        echo "Group $user_group already exists in the system"
                        useradd $username -s $user_shell -m -g $user_group -p $ssl_password
                    else 
                        echo -e "Group $user_group doenst exists in the system"
                        groupadd $user_group
                    
                        useradd $username -s $user_shell -m -g $user_group -p $ssl_password
                    fi
                        echo -e "username was created!\n"
                        ;;
                [nN]|[nN][oO])
                        echo "The creation will be skipped!"
                        ;;

                *)
                        echo -e "Please enter [yes/no] only!\n"
                        ;;
            esac

        elif [[ `grep $username "/etc/passwd"` ]]; then
                echo -e "$username naiden!"
 
            read -p "do yuo want to make for $username? (yes/no): " ANSWER_CHANGES
            case $ANSWER_CHANGES in
                 [Yy]|[Yy][Ee][Ss])
                echo "you answered yes";;
                 [Nn]|[Nn][Oo])
                echo "You answered no!";;
                *)
                echo "Yo need of create new file";;
 
 
 
            esac
 
    fi
 
                echo "$FILE_USERS "
 
done
fi