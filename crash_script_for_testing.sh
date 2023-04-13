#!/bin/bash

# Set the number of background processes to create
NUM_PROCESSES=4

# Function to calculate Fibonacci sequence in an infinite loop
high_cpu_usage() {
    while true; do
        num1=0
        num2=1
        num3=0
        while true; do
            num3=$((num1 + num2))
            num1=$num2
            num2=$num3
        done
    done
}

echo "Creating $NUM_PROCESSES processes with high CPU usage..."
for i in $(seq 1 $NUM_PROCESSES); do
    high_cpu_usage &
done

echo "Press Ctrl+C to stop the processes."
wait
