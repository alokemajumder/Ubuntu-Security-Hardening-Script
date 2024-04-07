#!/bin/bash

# Ubuntu Security Hardening Script
# Author: Alok Majumder
# GitHub: https://github.com/alokemajumder
# License: MIT License

# DISCLAIMER:
# This script is provided "AS IS" without warranty of any kind, express or implied. The author expressly disclaims any and all warranties, 
# express or implied, including any warranties as to the usability, suitability or effectiveness of any methods or measures this script 
# attempts to apply. By using this script, you agree that the author shall not be held liable for any damages resulting from the use of this script.

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Beginning Ubuntu security hardening process..."

# Update and upgrade existing packages
echo "Updating and upgrading installed packages..."
apt update && apt upgrade -y

# Install necessary packages
echo "Installing necessary tools and packages..."
apt install -y aide auditd debsums apparmor apparmor-utils clamav clamav-daemon unattended-upgrades ufw openscap-scanner

# Initialize AIDE
echo "Initializing AIDE, the file integrity checker..."
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Configure Auditd
echo "Configuring auditd..."
cp /etc/audit/auditd.conf /etc/audit/auditd.conf.backup
echo "
log_file = /var/log/audit/audit.log
log_group = root
log_format = ENRICHED
priority_boost = 4
flush = INCREMENTAL_ASYNC
freq = 20
num_logs = 5
disp_qos = lossy
dispatcher = /sbin/audispd
name_format = HOSTNAME
max_log_file = 8
max_log_file_action = ROTATE
space_left = 75
space_left_action = SYSLOG
action_mail_acct = root
admin_space_left = 50
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND
" > /etc/audit/auditd.conf
service auditd restart

# Configure AppArmor
echo "Configuring AppArmor..."
aa-enforce /etc/apparmor.d/*

# Configure ClamAV
echo "Scheduling ClamAV scans..."
echo "Please enter how often you want ClamAV scans to run (daily, weekly, monthly):"
read scan_frequency
echo "0 1 * * * root clamscan --infected --remove --recursive /" > /etc/cron.$scan_frequency/clamav_scan

# Configure Unattended-Upgrades
echo "Configuring automatic security updates..."
dpkg-reconfigure --priority=low unattended-upgrades

# Setup Firewall with UFW
echo "Setting up UFW firewall..."
ufw enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh

# Setup OpenSCAP
echo "Configuring OpenSCAP..."
echo "Please enter how often you want OpenSCAP scans to run (daily, weekly, monthly):"
read oscap_frequency
echo "30 2 * * * root oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard --report /var/log/oscap_report.html /usr/share/xml/scap/ssg/content/ssg-ubuntu1804-ds.xml" > /etc/cron.$oscap_frequency/oscap_scan

# Finalizing and generating report
echo "Generating final report..."
echo "
System Hardening Completed Successfully
- All packages updated
- AIDE, Auditd, AppArmor, ClamAV, and OpenSCAP configured
- Unattended upgrades and firewall configured
- Security scans scheduled
" > /var/log/hardening_report.txt

echo "Hardening report can be found at /var/log/hardening_report.txt"

# Notify user
echo "Ubuntu hardening process completed. Please check the report at /var/log/hardening_report.txt for details."
