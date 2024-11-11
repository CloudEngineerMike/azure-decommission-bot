#!/bin/bash

set -e

cat << "EOF"
     _                                                  
 ___| | ___   _   _____      _____  ___ _ __   ___ _ __ 
/ __| |/ / | | | / __\ \ /\ / / _ \/ _ \ '_ \ / _ \ '__|
\__ \   <| |_| | \__ \\ V  V /  __/  __/ |_) |  __/ |   
|___/_|\_\\__, | |___/ \_/\_/ \___|\___| .__/ \___|_|   
          |___/                        |_|              
                                                        
EOF

 

red=`tput setaf 1`

green=`tput setaf 2`

yellow=`tput setaf 3`

blue=`tput setaf 4`

 

### Set your subscription as the environment ###

read -p "Please enter the subscription(s) that you want to decommission (separated by a space between each alias): " Subscriptions

 

echo "

The subscription(s) that you selected for decommission are:

"

 

for subs in $Subscriptions

do

echo $subs

done

 

### Confirm if the correct subscription(s) were selected ###

 

while true; do

    read -p "

Is what's above, correct? (yes/no): " input

    case "$input" in

        y|yes)

            echo "${green}Awesome! Cranking up the engine! "

            break

            ;;

        n|no)

            echo "${red}Goodbye. Comeback when you're ready."

            exit 1

            ;;

        *) echo "${yellow}Invalid Input. Try again."

    esac

    done

 

Bulldozer () {

 

    #Set subscription

    az account set --subscription $subs

 

    #Verify subscription was set

    echo "${yellow}Now Decommissioning: "

    az account show

 

    #List RG locks

    lock=$(az lock list --query '[].[name,resourceGroup]')

    VAR1=$(az lock list -o tsv --query [].name)

    VAR2=$(az lock list -o tsv --query [].resourceGroup)

 

    echo "Looking for any RG locks: "

    az lock list --query '[].[name,resourceGroup]';

 

    if [[ $lock != [] ]];

        then

            for j in $VAR2;

                do

                    for i in $VAR1;

                        do

                            az lock delete --name $i --resource-group $j;

                    done

            done

    else echo "No RG locks found...";

    fi;

 

    #List and remove RGs

    list=$(az group list)

    VAR3=$(az group list -o tsv --query [].name)

 

    echo "Looking for any available Resource Groups: "

    az group list

 

    if [[ $list != [] ]];

        then

            for i in $VAR3;

                do az group delete -n $i -y --no-wait;

            echo "${green}All Resource Groups and their items are being deleted!"

        done

    else echo "No Resource Groups were available.";

    fi;

}

 

for subs in $Subscriptions

do

Bulldozer

done

 

echo "${green}All resources are being deleted. If any resources remain, then they might be need to be disconnected manually."

 

cat << "EOF"

                                               )                               (

                                              (                                 )

                                      ________[]_                              []

                              ___    /^=^-^-^=^-^\                   /^~^~^~^~^~^~\ 

                      /======/      /^-^-^-^-^-^-^\                 /^ ^ ^  ^ ^ ^ ^\

            ____     //      \___  /__^_^_^_^^_^_^_\               /_^_^_^^_^_^_^_^_\

            |  \\   //              |  .==.       |       ___       |        .--.  |

     |______|____|_//             ^^|  |LI|  [}{] |^^^^^ /___\ ^^^^^|  [}{]  |[]|  |^^^^^

     |              \             &&|__|__|_______|&&   ." | ".   88|________|__|__|888

    _L______________/o                 ====             (o_|_o)              ====

____(CCCCCCCCCCCCCCCC)__________        ====             u   u              ====       __________

EOF
