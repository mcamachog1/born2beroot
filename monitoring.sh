#!/bin/bash

#Architecture
echo "#Architecture: $(uname -a)"

#Physical processors
echo "#CPU physical : $(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)"

#Virtual processors
echo "#vCPU : $(grep -c processor /proc/cpuinfo)"

#Available RAM
TOTAL_MEMORY=$(free -m | awk '$1 == "Mem:" {print $2}')
USED_MEMORY=$(free -m | awk '$1 == "Mem:" {print $3}')
RATE_MEMORY=$(free -m | awk '$1 == "Mem:" {printf("%.2f%%\n", $3/$2*100)}')
printf "#Memory Usage: %d/%dMB (%s)\n" "$USED_MEMORY" "$TOTAL_MEMORY" "$RATE_MEMORY"

#Available storage
DISK_TOTAL=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
DISK_USE=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {printf disk_u}')
DISK_PERCENT=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t += $2} END {printf("%d", disk_u/disk_t*100)}')
printf "#Disk Usage: %d/%s (%d%%)\n" "$DISK_USE" "$DISK_TOTAL" "$DISK_PERCENT"

#Current processors utilization rate
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}')
printf "#CPU load: %.1f%%\n" "$CPU_LOAD"

#Date and time of the last reboot
LAST_BOOT=$(who -b | awk '$1 == "system" {print $3, $4}')
printf "#Last boot: %s\n" "$LAST_BOOT"

#LVM active
LVM_ACTIVE=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)
printf "#LVM use: %s\n" "$LVM_ACTIVE"

#Active connections
ACTIVE_CONNECTIONS=$(ss -ta | grep ESTAB | wc -l)
ESTABLISHED=$(if [ "$ACTIVE_CONNECTIONS" -gt 0 ]; then echo ESTABLISHED; else ""; fi)
printf "#Connections TCP :%d %s\n" "$ACTIVE_CONNECTIONS" "$ESTABLISHED" 

#Number of users
USERS=$(users | wc -w)
printf "#User log: %d\n" "$USERS" 

#IP Server Address
IP=$(hostname -I)
MAC=$(ip link | grep "link/ether" | awk '{print $2}')
printf "#Network: IP %s (%s)\n" "$IP" "$MAC" 

#Sudo comands executed
SUDO_COMMANDS=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
printf "#Sudo : %d cmd\n" "$SUDO_COMMANDS" 
