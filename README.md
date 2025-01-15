# System Resource Monitor Script

## Overview
The **System Resource Monitor** is a Bash script designed to monitor key system resources and generate detailed reports. It checks disk, CPU, memory usage, and running processes, providing insights into system health. It can also send email alerts when thresholds are exceeded and is designed to run as a cron job.

## Features
- **Disk Usage Monitoring**:
  - Reports the percentage of disk space used for each mounted partition.
  - Issues warnings if usage exceeds a user-defined threshold.
- **CPU Usage Monitoring**:
  - Displays the current CPU usage as a percentage.
- **Memory Usage Monitoring**:
  - Shows total, used, and free memory statistics.
- **Process Monitoring**:
  - Lists the top 5 memory-consuming processes.
- **Report Generation**:
  - Saves all collected data into a log file.
- **Enhancements**:
  - Optional arguments for flexibility:
    - `-t`: Specify disk usage warning threshold (default: 80%).
    - `-f`: Define a custom log file name (default: `system_monitor.log`).
  - Color-coded warnings for better readability.
  - Configurable as an hourly cron job with email notifications for threshold breaches.

---

## Requirements
- **Dependencies**:
  - `mailutils` or `sendmail` for email notifications.
- **Supported Systems**:
  - Linux-based distributions with `bash`.

---
