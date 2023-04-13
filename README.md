This Bash script, resource_monitor.sh, is designed to monitor and log system resource usage, 
including CPU, memory, and disk, while also displaying the top 10 processes sorted by CPU and memory usage in real-time. 
If any of the resource usages exceed user-defined thresholds, it sends email alerts to the specified address. 
This script is useful for tracking and alerting on high resource consumption in servers, allowing for proactive monitoring and troubleshooting.

Key features of the script:

Customizable monitoring intervals: The user can set the time interval (in seconds) between each monitoring cycle.
Adjustable thresholds: The user can define the maximum allowed percentage for CPU usage, memory usage, and disk usage.
Email alerts: If any of the resource usages exceed the defined thresholds, an email alert is sent to the specified address.
Real-time display: The script provides a real-time display of system resource usage and the top 10 processes sorted by CPU and memory usage.
Logging: The resource usage data is logged in a file called resource_monitor.log.
