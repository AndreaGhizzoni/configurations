#!/bin/bash

# Here nmap will do a ping scan and populate your arp cache. Once the scan is
# done, the arp command can be used to print the arp table and then you pull out
# the IP address with grep/awk. You could try replacing nmap with a broadcast
# ping, but that probably isn't as reliable. 

nmap -sP 192.168.2.0/24 >/dev/null && \
    arp -an | grep $1 | awk '{print $2}' | sed 's/[()]//g'
