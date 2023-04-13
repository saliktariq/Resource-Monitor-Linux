#!/bin/bash

resource_monitor() {
    while true; do
        clear
        echo -e "\e[1;32m SYSTEM RESOURCE MONITOR \e[0m"
        echo -e "\n"
        printf "%-20s %-20s %-20s\n" "CPU(%)" "Memory(%)" "Disk(%)"
# Get the percentage of CPU usage by running the 'top' command in batch mode for one iteration, filtering the 'Cpu(s)' line, 
# and extracting the second field (user CPU time) using 'awk'.
        cpu_percent=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')
# Get the percentage of memory usage by running the 'free' command, filtering the 'Mem' line, 
# and calculating the percentage using 'awk' by dividing used memory ($3) by total memory ($2) and multiplying by 100.
        mem_percent=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
# Get the percentage of disk usage by running the 'df' command with the '-h' flag (human-readable format), 
# filtering the root filesystem ('/') line, and extracting the fifth field (percentage used) using 'awk'.
        disk_percent=$(df -h | awk '$NF=="/"{printf "%s", $5}')
        printf "%-20s %-20s %-20s\n" "$cpu_percent" "$mem_percent" "$disk_percent"

# Remove the decimal part from the 'cpu_percent' variable and store the result in 'CPU_USAGE'.
CPU_USAGE="${cpu_percent%.*}"

# Remove the decimal part from the 'mem_percent' variable and store the result in 'FREE_MEM'.
FREE_MEM="${mem_percent%.*}"

# Remove the percentage symbol from the 'disk_percent' variable and store the result in 'DISK_USAGE'.
DISK_USAGE="${disk_percent%?}"

# Get the current date and time in the format 'YYYY-MM-DD HH:MM:SS' and store it in the 'CURRENT_TIME' variable.
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")


        echo "$CURRENT_TIME - CPU: ${CPU_USAGE}%, Memory: ${FREE_MEM}%, Disk: ${DISK_USAGE}%" >> "$LOG_FILE"
        if [ $CPU_USAGE -gt $MAX_CPU ] || [ $FREE_MEM -gt $MAX_MEM ] || [ $DISK_USAGE -gt $MAX_DISK ]; then
            echo "Resource usage is high. Sending email alert..."
            if [ -n "$EMAIL_ADDRESS" ]; then
                echo "Resource usage is high. Please check the server." | mail -s "Resource Monitor Alert" "$EMAIL_ADDRESS"
            fi
        fi

        echo -e "\n Top 10 Processes (sorted by CPU and Memory usage):"

# Display the top 10 processes sorted by CPU and memory usage using the 'ps' command with custom output 
# format (pid, user, comm, pcpu, pmem) and sorting options (-pcpu for descending CPU usage and -pmem 
# for descending memory usage), then limiting the output to the first 11 lines (including the header) using 'head'
        ps -eo pid,user,comm,pcpu,pmem --sort=-pcpu,-pmem | head -n 11

        sleep "$INTERVAL"
    done
}

echo "Enter the interval (in seconds) between each monitoring:"
read -r INTERVAL

echo "Enter the maximum CPU usage threshold (in %):"
read -r MAX_CPU
echo "Enter the maximum memory usage threshold (in %):"
read -r MAX_MEM
echo "Enter the maximum disk usage threshold (in %):"
read -r MAX_DISK

echo "Enter the email address to send alerts to (leave blank to skip email alerts):"
read -r EMAIL_ADDRESS

LOG_FILE="resource_monitor.log"

echo "Starting resource monitor with interval $INTERVAL seconds..."

resource_monitor

