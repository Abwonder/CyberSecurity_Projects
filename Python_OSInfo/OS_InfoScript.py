#!/bin/python3

print('''Developer Details:
Name: Abioye Oyatoye
user: S4
Date: 04.18.2023

This code output Operating System details of either and Os or Linux''')
## need time module here!!!
import time
print("Loading.................\n")
time.sleep(5)

## Library work in both window and linux
import platform

             ## Code for Windows OS....................
if platform.system() == "Windows":
    ## import all neede libraries
    import urllib.request as request
    import socket
    import subprocess
    import shutil
    import psutil
    import os
    
    #1. OS system name and version
    
    # Get the operating system name
    print("*"*5,"OS system name and version","*"*5)
    os_name = platform.system()
    print('OS Name:', os_name)

    # Get the operating system version
    os_version = platform.version()
    print('OS Version:', os_version)
    print("-" * 20)
    time.sleep(3)
    
    #2. Display the private IP address, public IP address, and 
    #the default gateway
    print("*"*5,"Private IP, Public IP and Gateway IP","*"*5)
    try:
        private_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        private_ip.connect(("8.8.8.8", 80))
        print('Private IP:', private_ip.getsockname()[0])
        private_ip.close()
    except:
        print("Unable to resolve the Private IP")
    
    try:
        public_ip = request.urlopen('https://ident.me').read().decode('utf8')
        print('Public IP:', public_ip)
    except:
        print("Unable to resolve the Public IP")
        

    # Get the default gateway IP address using ipconfig command
    result = subprocess.run('ipconfig', capture_output=True, text=True)
    ipconfig_output = result.stdout.split('\n')

    for line in ipconfig_output:
        #print(line)
        if 'Default Gateway' in line:
            gateway_ip = line.split(': ')[-1].strip()
            #print(type(gateway_ip))
            if type(gateway_ip) == str:
                #print(gateway_ip)
                continue

    if gateway_ip is not None:
        print('Gateway IP:', gateway_ip)
        print("-" * 20)
        time.sleep(3)
    else:
        print('Unable to get gateway IP')
        print("-" * 20)
        time.sleep(3)
        
        
    #3. Display the hard disk size; free and used space
    # Get information about the primary disk
    print("*"*5,"Hard disk size; free and used space","*"*5)
    total, used, free = shutil.disk_usage('/')

    # Display the size, free space, and used space
    print(f'Total size: {total / (1024**3):.2f} GB')
    print(f'Free space: {free / (1024**3):.2f} GB')
    print(f'Used space: {used / (1024**3):.2f} GB')
    print("-" * 20)
    time.sleep(3)
    
    
    #4.  Display the top five (5) directories and their size
    # Get the sizes of all directories in the current directory
    print("*"*5,"Top 5 directories in the current path","*"*5)
    dir_sizes = [(os.path.getsize(entry.path), entry.path)
                 for entry in os.scandir('.')
                 if entry.is_dir()]
    #print(dir_sizes)
    # Sort the directories by size in descending order
    dir_sizes.sort(reverse=True)
    #print(dir_sizes)

    # Display the top five directories and their size
    for size, path in dir_sizes[:5]:
        print(f'{path}: {size / (1024**2):.2f} MB')
    print("-" * 20)
    time.sleep(3)
        
    
    #5. Display the CPU usage; refresh every 10 seconds
    print("*"*5,"Cpu Usage","*"*5)
    def display_usage(cpu_usage,bars=50):
        cpu_percent = (cpu_usage/100.0)
        
        cpu_bar = "▌" * int(cpu_percent)  + "-" * (bars - int(cpu_percent * bars))
        print(f"\r CPU Usage: | |{cpu_bar}| {cpu_usage:.2f}%", end="")
    
    while True:
        display_usage(psutil.cpu_percent(),30)
        time.sleep(0.5)





####################  THIS WORKS FOR LINUX ############################





elif platform.system() == "Linux":
    ### libraries to import
    import distro 
    import urllib.request as request
    import socket
    import netifaces
    import os
    
    
    #1. OS system name and version
    
    # Get the operating system name
    print("*"*5,"OS system name and version","*"*5)

    print(f"OS Name: {distro.name()}")
    print(f"OS Version: {distro.version()}")
    print("-" * 20)
    time.sleep(3)



    #2. Display the private IP address, public IP address, and 
    #the default gateway
    print("*"*5,"Private IP, Public IP and Gateway IP","*"*5)

    try:
        public_ip = request.urlopen('https://ident.me').read().decode('utf8')
        print('Public IP:', public_ip)
    except:
        print("Unable to resolve the Public IP")

    try:
        private_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        private_ip.connect(("8.8.8.8", 80))
        print('Private IP:', private_ip.getsockname()[0])
        private_ip.close()
    except:
        print("Unable to resolve the Private IP")

    
    try:
        gateways = netifaces.gateways()
        default_gateway = gateways['default'][netifaces.AF_INET][0]
        print(f'Default gateway: {default_gateway}')
        print("-" * 20)
        time.sleep(3)

    except:
        print("Unable to determine Default Gateway")
        print("-" * 20)
        time.sleep(3)
        
        
    
    #3. Display the hard disk size; free and used space
    # Get information about the primary disk
    print("*"*5,"Hard disk size; free and used space","*"*5)

    # Get disk usage statistics
    st = os.statvfs('/')

    # Calculate disk size, free space, and used space
    total_space = st.f_frsize * st.f_blocks
    free_space = st.f_frsize * st.f_bfree
    used_space = total_space - free_space

    # Print disk size, free space, and used space
    print(f"Total disk size: {total_space / (1024*1024*1024):.2f} GB")
    print(f"Free disk space: {free_space / (1024*1024*1024):.2f} GB")
    print(f"Used disk space: {used_space / (1024*1024*1024):.2f} GB")
    print("-" * 20)
    time.sleep(3)
    
    
    #4.  Display the top five (5) directories and their size
    # Get the sizes of all directories in the current directory
    print("*"*5,"Top 5 directories in the current path","*"*5)

    dir_sizes = os.popen("du -h *| sort -rh | head -n 5").read().split('\n')
    for item in dir_sizes:
        if item:
            size, path = item.split()
            print(f"{path}\t{size}")
    print()


    #5. Display the CPU usage; refresh every 10 seconds
    print("*"*5,"Cpu Usage","*"*5)

    def display_usage(cpu_usage,bars=50):
        cpu_percent = (cpu_usage/100.0)
        cpu_bar = "▌▌" * int(cpu_percent)  + "-" * (bars - int(cpu_percent * bars))
        print(f"\r CPU Usage: | |{cpu_bar}| {cpu_usage:.2f}%", end="", flush=True)
    while True:
        cpu_usage = float(os.popen("top -bn1 | awk '/^%Cpu/{print $2}'").read().strip())
        display_usage(cpu_usage, 20)
        time.sleep(0.5)
        #print(f"\rCPU Usage: {cpu_usage}%", end = "", flush=True)

