#!/bin/bash

# Function to display help message
function display_help() {
    echo "Usage: systeminfo.sh [OPTION]"
    echo "Generate system reports using various options:"
    echo "-h          Display this help message and exit"
    echo "-v          Run script verbosely, showing errors to the user instead of logging them"
    echo "-system     Run computer, OS, CPU, RAM, and video reports"
    echo "-disk       Run disk report"
    echo "-network    Run network report"
}

# Function to log error message
function errormessage() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="/var/log/systeminfo.log"
    echo "[ERROR] $timestamp: $1" >> "$log_file"
    echo "Error: $1" >&2
}

# Check for root permission
if [[ $EUID -ne 0 ]]; then
    errormessage "This script requires root permission."
    exit 1
fi

# Source the function library
source "$(dirname "$0")/bash/reportfunctions.sh"

# Parse command line options
while getopts "hvsystemdisknetwork" option; do
    case $option in
        h)
            display_help
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        system)
            computerreport
            osreport
            cpureport
            ramreport
            videoreport
            ;;
        disk)
            diskreport
            ;;
        network)
            networkreport
            ;;
        *)
            display_help
            exit 1
            ;;
    esac
done

# If no command line options provided, print full system report
if [[ $OPTIND -eq 1 ]]; then
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
    diskreport
    networkreport
fi
