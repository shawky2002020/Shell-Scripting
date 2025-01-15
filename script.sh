#!/usr/bin/bash

# Default values
THRESHOLD=80
OUTPUT_FILE="disk_alert.txt"

# Parse optional arguments
while getopts "t:f:" opt; do
    case "$opt" in
        t) THRESHOLD=$OPTARG ;;
        f) OUTPUT_FILE=$OPTARG ;;
        *) echo "Usage: $0 [-t threshold] [-f output_file]"; exit 1 ;;
    esac
done

# ANSI escape codes for red text
RED='\033[0;31m'
NC='\033[0m'

# Get the current date and time for the report
DATE=$(date "+%Y-%m-%d %H:%M:%S")
echo "System Monitoring Alert - $DATE" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "System Monitoring Report - $DATE" >> "$OUTPUT_FILE"
echo "======================================" >> "$OUTPUT_FILE"

# Disk Usage Section
echo "Disk Usage:" >> "$OUTPUT_FILE"
df -h | awk 'NR>1 && $1 !~ /tmpfs|none|loop|lib/ {print $1, $2, $3, $4, $5, $6}' | while read -r FS SIZE USED AVAIL USE MOUNT; do
    USAGE=$(echo "$USE" | tr -d '%')
    if [[ "$USAGE" =~ ^[0-9]+$ ]]; then
        printf "%-15s %-5s %-5s %-5s %-4s %s\n" "$FS" "$SIZE" "$USED" "$AVAIL" "$USE" "$MOUNT" >> "$OUTPUT_FILE"
        if [ "$USAGE" -gt "$THRESHOLD" ]; then
            echo -e "${RED}Warning: $FS is above $THRESHOLD% usage!${NC}" | tee -a "$OUTPUT_FILE"
        fi
    fi
done

# CPU Usage Section
if command -v mpstat &>/dev/null; then
    CPU_USAGE=$(mpstat 5 1 | grep "Average" | awk '{print 100 - $12}')
    echo "CPU Usage: $CPU_USAGE%" >> "$OUTPUT_FILE"
else
    read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
    sleep 1
    read cpu user2 nice2 system2 idle2 iowait2 irq2 softirq2 steal2 guest2 < /proc/stat
    idle_diff=$((idle2 - idle))
    total_diff=$(( (user2 - user) + (nice2 - nice) + (system2 - system) + idle_diff + (iowait2 - iowait) + (irq2 - irq) + (softirq2 - softirq) + (steal2 - steal) ))
    CPU_USAGE=$((100 * (total_diff - idle_diff) / total_diff))
    echo "CPU Usage: $CPU_USAGE%" >> "$OUTPUT_FILE"
fi

# Memory Usage Section
echo "Memory Usage:" >> "$OUTPUT_FILE"
free -h | awk '/^Mem:/ {printf "Total Memory: %s, Used Memory: %s, Free Memory: %s\n", $2, $3, $4}' >> "$OUTPUT_FILE"

# Top 5 Memory-Consuming Processes
echo "Top Memory-Consuming Processes:" >> "$OUTPUT_FILE"
for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    mem_usage=$(awk '/VmRSS/ {print $2}' /proc/$pid/status 2>/dev/null)
    if [ ! -z "$mem_usage" ]; then
        process_name=$(cat /proc/$pid/comm)
        printf "%-10s %-20s %-6s\n" "$pid" "$process_name" "$mem_usage" >> "$OUTPUT_FILE"
    fi
done
head -n 6 "$OUTPUT_FILE"

# Check for warnings and send email
if grep -q "Warning:" "$OUTPUT_FILE"; then
    SUBJECT="System Monitoring Alert - Threshold Breached"
    RECIPIENT="shawkyelsayed2002@gmail.com"
    mail -s "$SUBJECT" "$RECIPIENT" < "$OUTPUT_FILE"
fi

# Display the final report
cat "$OUTPUT_FILE"

