#!/bin/bash

function cpureport() {
    echo "CPU Report"
    echo "-----------"
    echo "CPU Manufacturer and Model: $(lscpu | grep "Model name:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
    echo "CPU Architecture: $(lscpu | grep "Architecture:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
    echo "CPU Core Count: $(lscpu | grep "Core(s) per socket:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
    echo "CPU Maximum Speed: $(lscpu | grep "CPU max MHz:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//') MHz"
    echo "Cache Sizes:"
    echo "  L1: $(lscpu | grep "L1d cache:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
    echo "  L2: $(lscpu | grep "L2 cache:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
    echo "  L3: $(lscpu | grep "L3 cache:" | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//')"
}

function computerreport() {
    echo "Computer Report"
    echo "---------------"
    echo "Computer Manufacturer: $(dmidecode -s system-manufacturer)"
    echo "Computer Description/Model: $(dmidecode -s system-product-name)"
    echo "Computer Serial Number: $(dmidecode -s system-serial-number)"
}

function osreport() {
    echo "OS Report"
    echo "---------"
    echo "Linux Distro: $(lsb_release -ds)"
    echo "Distro Version: $(lsb_release -rs)"
}

function ramreport() {
    echo "RAM Report"
    echo "----------"
    echo "Installed Memory Components:"
    echo "Manufacturer | Model | Size | Speed | Location"
    dmidecode -t memory | awk '/Manufacturer:|Part Number:|Size:|Speed:|Locator:/{printf $0 (NR%5?" | ":"\n")}'
    echo "Total Installed RAM: $(free -h | awk '/^Mem:/{print $2}')"
}

function videoreport() {
    echo "Video Report"
    echo "------------"
    echo "Video Card/Chipset Manufacturer: $(lspci | grep VGA | cut -d ':' -f3 | sed -e 's/^[[:space:]]*//')"
    echo "Video Card/Chipset Description/Model: $(lspci | grep VGA | cut -d ':' -f3 | sed -e 's/^[[:space:]]*//')"
}

function diskreport() {
    echo "Disk Report"
    echo "-----------"
    echo "Installed Disk Drives:"
    echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Free Space"
    lsblk -bo NAME,VENDOR,MODEL,SIZE,MOUNTPOINT,FSTYPE,FSSIZE,FSUSED | awk '/disk/{printf $2" | "$3" | "$4" | "$1" | "$5" (NF>5?" | "$6" | "$7" " / "$8:" | - | -\n")}'
}

function networkreport() {
    echo "Network Report"
    echo "--------------"
    echo "Installed Network Interfaces:"
    echo "Manufacturer | Model/Description | Link State | Current Speed | IP Addresses | Bridge Master | DNS Servers | Search Domain"
    lspci -nn | grep -i network | awk '{print $3}' | xargs -i% lspci -ks %
}
