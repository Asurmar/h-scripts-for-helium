# Hscripts for Helium hotspot
[1. Short intro](#1-short-intro)  
[2. Requirements](#2-requirements)  
[3. Installation](#3-installation)  
[4. Updating](#4-updating)  
[5. Compatibility](#5-compatibility)  
[6. FAQ](#6-faq)  
[7. Other stuff](#7-other-stuff)  

### 1. Short intro
Collection of handy shell scripts for day to day management of a Helium hotspot. Tired of rebooting your hotspot every time it hangs for few hours? Say NO MORE! You can use these scripts to:
- display miner app process information
- restart your miner app,
- restart the entire miner container,
- safely reboot your hotspot,
- display connections to validators
- display statistics and details of witnesses
- find your helium logs directory
- display other useful hotspot information (miner version, name, temperature, uptime, public IP)

### 2. Requirements
1. Access to your hotspot via ssh.
2. Basic knowledge of CLI (I mean really basic)

### 3. Installation
Download install script and run it, just copy and paste below commands (one line):  
<sub>`wget -O install.sh https://github.com/Asurmar/hscripts-for-helium/raw/main/install.sh; chmod +x install.sh; ./install.sh`</sub>  
On balena-based hotspots (Sensecap, Nebra, Nebra for 3rd party hotspots) first change directory to:  
`cd /mnt/data/`

### 4. Updating 
It's enough to just run previously downloaded install script:  
`./install.sh` : for non-balena hotspots  
`/mnt/data/install.sh` : for balena-based hotspots (Sensecap, Nebra)  

### 5. Compatibility
Hscripts work with every Helium hotspot brand that allows ssh access by default:
- PantherX (at least X1)
- Milesight
- Pisces (not tested though)
- Dusun (not tested)

They also work perfectly with balena-based hotspots, but it requires SD-card modification, which is very easy to do:
- Sensecap
- Nebra

Below listed brands can also turn into balena-based hotspots by using Nebra software for 3rd party hotspots:
- RAK/MNTD (YES!)  
- Cotx
- Controllino
- Finestra
- Helium OG
- Syncrobit
- Linxdot
- RisingHF
- Pycom

Other brands that you can tinker with to enable ssh, but it requires knowledge of hardware hacking, UART, serial console and stuff:
- Heltec
- Browan
- Midas
- Bobcat (?)

### 6. FAQ
**Q**: What the heck is ssh?  
**A**: Ssh is a secure shell protocol. It uses encryption to connect to a device's CLI (command line interface - the way geeks talk to computers, you know)

**Q**: Why do I need ssh?  
**A**: Because you want to be a geek. Just kidding. Ssh gives you the ability to get into the operating system of a hotspot, which allows you to retrieve detailed information (usually not available through other means), browse logs and do other fun staff with your device like automating, writing your own scripts, creating services, etc.

**Q**: How do these scripts work?  
**A**: They run shell commands to allow you interact with the software and provide valuable information mainly by using 3 different ways: browsing miner logs, talking to the miner app container and querying Helium API.

**Q**: What is Balena-based hotspot?  
**A**: balenaOS is an operating system designed to run docker containers and used specifically for IoT devices. balenaOS-powered hotspots include Sensecap, Nebra and Nebra for 3rd party hotspots.

**Q**: What is Nebra for 3rd party hotspots?  
**A**: It a software provided by Nebra for hotspots based on Raspberry Pi or Rock Compute Module 3, which include brands like: **RAK/MNTD, Cotx, Pisces, Syncrobit, Controllino, Finestra, Helium OG, Linxdot, RisingHF, Pycom**. In short: flash an SD card with Nebra software, insert it into your hotspot and turn it into a balenaOS-powered device with possibility to enable ssh (YES!). It works exactly as before, even the Explorer displays hardware manufacturer correctly.

### 7. Other stuff
So you CAN actually ssh into a Helium hotspot, now what? How about creating a centralized web dashboard, similar to that provided by Sensecap (as far as I know best Helium dashboard in business), but maybe better? How about adding more services to the dashboard like monitoring network availability, monitoring PoC activity, automating serivce restarts in case of flatlining, environment alerts? Reverse shell server? Looking for people with at least basic experience in creating Python web based aplications to participate in that project. No Helium knowledge required.
