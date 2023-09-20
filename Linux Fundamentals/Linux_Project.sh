#!/bin/bash

#Linux Fundamental Project
## Output Linux Operating System

### Author: Abioye Elijah Oyatoye (S4)
## Date: March 2023

echo -e "\nThe Linux Operating System Information for this machine \n"


#1.
function Version()
{
	echo -e "\nVersion: $(hostnamectl | grep Kernel | cut -d ":" -f 2 | awk '{print $2}')\n"
}

Version


#2.
function Ippaddress()
{
	echo "Ip addresses"
	echo "Private IP: $(ifconfig |head -n 2 | grep "inet" | awk '{print $(2)}')"
	echo "Public IP: $(curl -s ifconfig.co)"
	echo "Default gateway: $(ip r | grep "via" | awk '{print $(3)}')"
}
Ippaddress

#3.
function Harddisk()
{

	echo -e "\nHard Disk Details"
	echo -e "Size: $(df -H | grep -e "sd" -e "Filesystem" | awk '{print $2}' | tail -n1) \t Used: $(df -H | grep -e "sd" -e "Filesystem" | awk '{print $3}' | tail -n1) \t Free: $(df -H | grep -e "sd" -e "Filesystem" | awk '{print $4}' | tail -n1)"
}
Harddisk

#4. 
function Top5Dir ()
{
	echo -e "\nTop Five Directories and Sizes"
	echo -e "$(du -sh /* 2>/dev/null | sort -rh | head -n5) \n\n"
}
Top5Dir

#5.
function CPUusage()
{
	while true
	do
		echo "CPU usage; Refreshes every 10seconds" 
		echo "%CPU used: $(top -b -n 5 -d1 | grep "%Cpu(s)" | tail -n 1 | awk '{print $2}' | awk -F. '{print $1}')%"
		sleep 10
			
	done
}
CPUusage





