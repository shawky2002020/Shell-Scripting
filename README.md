# 🖥️ System Resource Monitor Script

## 📄 Overview
The **System Resource Monitor** is a comprehensive Bash script designed to:
- Monitor key system resources.
- Generate detailed reports for system health.
- Send email alerts when thresholds are breached.

It is highly configurable, color-coded for clarity, and can be run as a cron job for regular monitoring.

---

## ✨ Features
- **🗂️ Disk Usage Monitoring**:
  - Reports the percentage of disk space used for each mounted partition.
  - Issues warnings if usage exceeds a configurable threshold.

- **🖥️ CPU Usage Monitoring**:
  - Displays the current CPU usage as a percentage.

- **📊 Memory Usage Monitoring**:
  - Shows total, used, and free memory statistics.

- **📋 Process Monitoring**:
  - Lists the top 5 memory-consuming processes.

- **📁 Report Generation**:
  - Saves all collected data into a customizable log file.

- **⚙️ Enhancements**:
  - Optional arguments:
    - `-t`: Specify disk usage warning threshold (default: 80%).
    - `-f`: Define a custom log file name (default: `system_monitor.log`).
  - Color-coded output for improved readability.
  - Configurable as an hourly cron job with email alerts.

---

## 🛠️ Requirements
- **Dependencies**:
  - Install `mailutils` or `sendmail` for email notifications:
    ```bash
    sudo apt install mailutils -y
    ```
- **Supported Systems**:
  - Linux-based distributions with Bash.

---

## 📸 Screenshots

### Sample Output
![output](https://github.com/user-attachments/assets/776daa9a-9d05-4015-8135-f841de397a0f)

### Script Code
![script](https://github.com/user-attachments/assets/c1cdc99d-23f5-424e-89ec-2078481eba12)

---
