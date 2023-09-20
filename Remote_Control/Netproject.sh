#!/bin/bash

echo "            Network Research Project"

echo "Trainer: Thinkcyber"
echo

echo "Author: Abioye Elijah Oyatoye (S4)"
echo "Date developed: June 2023"

## save the current path to be used later!
path=$(pwd)
#echo "$path"
echo

#create function to check software needed
check_package_status1() {
    local package="$1"
    if [ "$(sudo dpkg -s "$package" | grep -i status | awk '{print $4}')" == "installed" ]; then
        echo "[+] $package is installed"
    else
        echo "[++] Not installed, initiating $package installation......"
        sudo apt-get install -y "$package" &> /dev/null
        echo "[+] $package installed completely!"
    fi
}

# second version of check, create function to check software needed
check_package_status2() {
    local package="$1"
    if command -v "$package" &> /dev/null; then
        echo "[+] $package is installed"
    else
        echo "[++] Not installed, initiating $package installation......"
        sudo apt-get install -y "$package" &> /dev/null
        echo "[+] $package installed completely!"
    fi
}

# Tor checking
check_package_status1 tor

# Torify, check
check_package_status2 torify

# Git checking
check_package_status1 git

# Geoip-bin checking
check_package_status1 geoip-bin

# sshpass checking
check_package_status2 sshpass

# Nipe is different from others, needed more checks
if ls -d nipe &> /dev/null && command -v tor &> /dev/null && command -v iptables &> /dev/null; then
    #checking for all the necessary dependencies for nipe to work
    if sudo perl -MLWP::UserAgent -e 'print "LWP::UserAgent module is installed\n"' &> /dev/null; then
        if sudo perl -MConfig::Simple -e 'print "Config::Simple module is installed\n"' &> /dev/null; then
            echo "[+] Nipe is installed"
        fi
    fi
else
    ## Handles when Nipe is not installed!!!
    echo "[+] nipe not installed"
    sleep 3

    ## To remove any existing folder named nipe in the current directory before installation
    rm -R nipe &> /dev/null

    #### Installing Nipe
    echo "[+++] Cloning nipe from GitHub"
    git clone https://github.com/htrgouvea/nipe.git &> /dev/null
    echo "[+] nipe cloned completely......."

    ## cd to nipe folder
    cd nipe

    ## Installation of Nipe Dependencies
    echo "Nipe installation initiated"
    yes | sudo cpan install -y Switch JSON LWP::UserAgent &> /dev/null
    sudo cpan install Config::Simple &> /dev/null

    ## installing nipe package using Perl
    sudo perl nipe.pl install &> /dev/null
    echo "Installation complete!"
    sleep 2
fi

#Saving original public IP of host
host_current_IP=$(curl -s ifconfig.me)
#echo "$host_current_IP"

#start Nipe service!!
cd nipe &> /dev/null   
#echo "Start Nipe ............"
sudo perl nipe.pl start
#echo "Nipe Started"

### Code Part Two, Get spoofed IP address

host_spoofed_IP=$(sudo perl nipe.pl status | grep -i ip | awk '{print $3}')
#echo "$host_spoofed_IP"

current_country=$(geoiplookup "$host_current_IP" | awk -F "," '{print $2}')
#echo "$current_country"

spoofed_country=$(geoiplookup "$host_spoofed_IP" | awk -F "," '{print $2}')
#echo "$spoofed_country"

# Detecting Anonymity
if [ "$current_country" == "$spoofed_country" ]; then
    echo "[#] You are not anonymous, you are exposed!"
    sleep 2
    echo "Stopping nipe!!!"
    perl nipe.pl stop
    echo "nipe stopped!!!"
    echo "[#] Exiting ................."
    exit
else
    echo "[*] You are anonymous..... Connecting to the remote server!"
    echo
fi

## Give Current details of the process
echo "[**] Your spoofed IP address is: $host_spoofed_IP, Spoofed country: $spoofed_country!!"
## Accept client-side info on the target to scan
read -p "[??] Specify a Domain/IP address to scan: " Domain_IP
echo

echo "[**] Connecting to the Remote Server:"

## Section for Remote logging and command executions ##

# Remote server details
remote_username="root"
remote_password="root"
remote_hostname="192.168.101.134"

# Output details of the remote server:uptime,IP
remote_execution1() {
    # Run the Nipe check again on the remote server
    sshpass -p "$remote_password" ssh -T "$remote_username@$remote_hostname" "
	# Check uptime of remote server
	echo -n 'Remote server uptime: '; uptime

	# Remote server IP 
	echo -n 'Remote current IP: '

	# remote IP
	curl -s ifconfig.me
	
	echo	
	"    
}
remote_execution1


# Function to check remote ip, store for future usage
remoteIP_store() {
    # Run the Nipe check again on the remote server
    sshpass -p "$remote_password" ssh -T "$remote_username@$remote_hostname" "
	curl -s ifconfig.me	
	" > "./serverIP.txt"
}
remoteIP_store


#cat serverIP.txt   #Test to check the saved IP, Only remove first #

# -n remove new line after echo
echo -n 'Remote country: '	

# obtain contry using geoip and stored IP	
geoiplookup $(cat serverIP.txt) | awk -F "," '{print $2}'
echo  

# remove stored IP file
rm serverIP.txt

echo "[*] Whoising victim's address: "
echo "[@] Whoising data was saved into $path/nipe/whois_$Domain_IP.txt"

# creating log file for whois process: netresearch.log
echo " $(date) - [*] Whois data collected for: $Domain_IP " >> /var/log/netresearch.log

# whois remote execution
whoisRemoteExecution() {
    # Run the Nipe check again on the remote server
    sshpass -p "$remote_password" ssh -T "$remote_username@$remote_hostname" "
	
	sudo whois "$Domain_IP"
	" > "./Whois_$Domain_IP"
}
whoisRemoteExecution

echo

echo "[*] Scanning victim's address: "
echo "[@] Nmap scan data was saved into $path/nipe/Nmap_$Domain_IP.txt"

# creating log file for Nmap process: netresearch.log
echo " $(date) - [*] Nmap data collected for: $Domain_IP " >> /var/log/netresearch.log

# Nmap remote command function
nmapRemoteExecution() {
    # Run the Nipe check again on the remote server
    sshpass -p "$remote_password" ssh -T "$remote_username@$remote_hostname" "
	
	sudo nmap -sS -sV -F "$Domain_IP"
	" > "./Nmap_$Domain_IP"
}
nmapRemoteExecution

#close_nipe
perl nipe.pl stop
