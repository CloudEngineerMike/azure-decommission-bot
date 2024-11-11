# Sky Sweeper
A Bash script that handles all Azure subscription resource deletion; clearing out a targeted subscription to essentially create an empty shell.

![vecteezy_street-cleaning-with-garbage-truck-and-sweepers_15426926](https://github.com/user-attachments/assets/4c5693f7-a652-4e5d-85a2-747cb320f275)

## The Problem

Over the years, many Azure subscriptions become obsolete, whether because they’re no longer needed or the owner has left the company. As a result, these accounts often need to be decommissioned.

No one wants the tedious task of combing through a long list of resources and repeatedly clicking delete. We all have better things to do! So, what if we created a script to handle this for us?


## The Solution

Sky Sweeper is a tool designed to handle Azure subscription resource deletion, clearing out all resources in a targeted subscription to leave an empty shell.
 
## Architecture

 ![skySweeper drawio](https://github.com/user-attachments/assets/3a78be7e-da5f-4bdc-8fcb-8b016afb9548)
 

### Order of Operations

1. After stopping any running/connected resources, the user must authenticate the Azure CLI.

2. Run the script.

> If this is your first time running the script, you will need to make it executable on your machine: `chmod +x <SCRIPT_NAME>.sh`, and then you can run it

3. The script prompts only a few questions, then performs `delete` commands, iterating through various resources in the subscription. The final result is an empty subscription.
