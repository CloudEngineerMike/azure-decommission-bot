#!/bin/bash

set -e

# ASCII Art Banner
cat << "EOF"
     _                                                  
 ___| | ___   _   _____      _____  ___ _ __   ___ _ __ 
/ __| |/ / | | | / __\ \ /\ / / _ \/ _ \ '_ \ / _ \ '__|
\__ \   <| |_| | \__ \\ V  V /  __/  __/ |_) |  __/ |   
|___/_|\_\\__, | |___/ \_/\_/ \___|\___| .__/ \___|_|   
          |___/                        |_|              
                                                        
EOF

# Define color variables
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

#######################
### Set Environment ###
#######################

read -p "Please enter the subscription(s) that you want to decommission (separated by a space between each alias): " Subscriptions

echo -e "\nThe subscription(s) that you selected for decommission are:\n"

for subs in $Subscriptions; do
    echo "$subs"
done

### Confirm if the correct subscription(s) were selected ###
while true; do
    read -p "

Is what's above correct? (yes/no): " input

    case "$input" in
        y|yes)
            echo -e "${green}Awesome! Cranking up the engine!${reset}"
            break
            ;;
        n|no)
            echo -e "${red}Goodbye. Come back when you're ready.${reset}"
            exit 1
            ;;
        *) 
            echo -e "${yellow}Invalid Input. Try again.${reset}"
            ;;
    esac
done

# Function to decommission a subscription
Bulldozer() {
    # Set subscription
    az account set --subscription "$subs"

    # Verify subscription was set
    echo -e "${yellow}Now Decommissioning: ${reset}"
    az account show

    # List RG locks
    lock=$(az lock list --query '[].[name,resourceGroup]')
    VAR1=$(az lock list -o tsv --query [].name)
    VAR2=$(az lock list -o tsv --query [].resourceGroup)

    echo "Looking for any RG locks: "
    az lock list --query '[].[name,resourceGroup]'

    if [[ $lock != "[]" ]]; then
        for j in $VAR2; do
            for i in $VAR1; do
                az lock delete --name "$i" --resource-group "$j"
            done
        done
    else
        echo "No RG locks found..."
    fi

    # List and remove RGs
    list=$(az group list)
    VAR3=$(az group list -o tsv --query [].name)

    echo "Looking for any available Resource Groups: "
    az group list

    if [[ $list != "[]" ]]; then
        for i in $VAR3; do
            az group delete -n "$i" -y --no-wait
            echo -e "${green}All Resource Groups and their items are being deleted!${reset}"
        done
    else
        echo "No Resource Groups were available."
    fi
}

# Loop through all provided subscriptions
for subs in $Subscriptions; do
    Bulldozer
done

echo -e "${green}All resources are being deleted. If any resources remain, they might need to be disconnected manually.${reset}"

# ASCII Art at the end
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
