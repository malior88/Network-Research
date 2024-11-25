#!/bin/bash

# 1. Installations and Anonymity Check:

# Make a new directory for the scan output

mkdir -p /home/kali/Desktop/new_dir

# function to check and install tools
function install_tools {
    echo "Installing the needed tools..." >> /home/kali/Desktop/new_dir/all_results.txt
    tools=("sshpass" "nipe" "nmap" "geoiplookup")

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "$(date) - $tool is not installed, installing it now..." >> /home/kali/Desktop/new_dir/all_results.txt
            case "$tool" in
                sshpass)
                    install_sshpass
                    ;;
                nipe)
                    install_nipe
                    ;;
                nmap)
                    install_nmap
                    ;;
                geoiplookup)
                    install_geoiplookup
                    ;;
            esac
        else
            echo "$(date) - $tool is already installed." >> /home/kali/Desktop/new_dir/all_results.txt
        fi
    done
}

# Install functions

function install_nipe {
    echo "$(date) - Starting installation of Nipe..." >> /home/kali/Desktop/new_dir/all_results.txt
    git clone https://github.com/htrgouvea/nipe.git >> /dev/null 2>&1 && cd nipe
    cpanm --installdeps . >> /dev/null 2>&1
    sudo cpan install Try::Tiny Config::Simple JSON >> /dev/null 2>&1
    sudo perl nipe.pl install >> /dev/null 2>&1
    echo "$(date) - Nipe installation completed." >> /home/kali/Desktop/new_dir/all_results.txt
}

function install_geoiplookup {
    echo "$(date) - Installing geoiplookup..." >> /home/kali/Desktop/new_dir/all_results.txt
    sudo apt update >> /dev/null 2>&1
    sudo apt install -y geoip-bin >> /dev/null 2>&1
}

function install_sshpass {
    echo "$(date) - Installing sshpass..." >> /home/kali/Desktop/new_dir/all_results.txt
    sudo apt-get install -y sshpass >> /dev/null 2>&1
}

function install_nmap {
    echo "$(date) - Installing nmap..." >> /home/kali/Desktop/new_dir/all_results.txt
    sudo apt-get install -y nmap >> /dev/null 2>&1
}

# Anonymous check
function NIPE {
    echo "$(date) - Checking if you are anonymous..." >> /home/kali/Desktop/new_dir/all_results.txt
    sudo perl nipe.pl restart >> /dev/null 2>&1

    current_ip=$(sudo perl nipe.pl status | grep 'lp:' | awk '{print $3}')
    country=$(geoiplookup "$current_ip" | awk '{print $4}' | sed 's/,//g')

    if [ "$country" == "IL" ]; then
        echo "$(date) - You are not anonymous! Exiting." >> /home/kali/Desktop/new_dir/all_results.txt
        exit
    else
        echo "$(date) - You are anonymous! Country: $country" >> /home/kali/Desktop/new_dir/all_results.txt
    fi
}

# Start function to get user input and run the script
function START {
    # Request the username, password, and IP address from the user
    echo "Enter SSH username:"
    read ssh_user

    echo "Enter SSH password:"
    read -s ssh_pass  

    echo "Enter SSH IP address:"
    read ssh_ip

    # Install the tools
    install_tools
    NIPE

    # Connect to the remote server
    echo "$(date) - Connecting to the remote server..." >> /home/kali/Desktop/new_dir/all_results.txt
    sshpass -p "$ssh_pass" ssh -o StrictHostKeyChecking=no $ssh_user@$ssh_ip >> /dev/null 2>&1

    # Get the remote server details
    echo "$(date) - Fetching remote server details..." >> /home/kali/Desktop/new_dir/all_results.txt
    hostname -I | awk '{print $1}' >> /home/kali/Desktop/new_dir/all_results.txt
    geoiplookup $(hostname -I | awk '{print $1}') >> /home/kali/Desktop/new_dir/all_results.txt
    uptime >> /home/kali/Desktop/new_dir/all_results.txt

    # Whois and Nmap results
    echo "$(date) - Running Whois for $ssh_ip..." >> /home/kali/Desktop/new_dir/all_results.txt
    whois $ssh_ip >> /home/kali/Desktop/new_dir/all_results.txt

    echo "$(date) - Running Nmap scan for $ssh_ip..." >> /home/kali/Desktop/new_dir/all_results.txt
    nmap -Pn -p- $ssh_ip >> /home/kali/Desktop/new_dir/all_results.txt


    # 3. Copy the file from the remote server to the local machine
    echo "$(date) - Copying results to local machine..." >> /home/kali/Desktop/new_dir/all_results.txt
    sshpass -p "$ssh_pass" scp -o StrictHostKeyChecking=no $ssh_user@$ssh_ip:/home/kali/Desktop/new_dir/all_results.txt /home/kali/Desktop/all_results.txt
}

# Call the START function to initiate the script
START
