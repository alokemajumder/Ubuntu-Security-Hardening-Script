## Ubuntu Security Hardening Script

This script provides a comprehensive approach to hardening Ubuntu systems, aligning with DISA-STIG compliance for Ubuntu 20.04 LTS. It includes a range of security enhancements and configurations designed to strengthen the security posture of Ubuntu servers.

## Features

- **System Updates**: Applies the latest security patches to the system.
- **Firewall Configuration**: Sets up and configures UFW (Uncomplicated Firewall) to deny all incoming connections by default, while allowing all outgoing connections.
- **Fail2Ban Setup**: Configures Fail2Ban to protect against brute-force attacks, particularly against SSH.
- **Auditd Configuration**: Sets up Auditd with rules recommended by DISA-STIG to monitor changes to critical system files.
- **Account Security**: Ensures only the root user has UID 0 and disables root SSH login.
- **Password Policies**: Enforces policies to disable empty passwords and ensure all accounts have strong authentication.
- **Network Hardening**: Applies measures to harden the TCP/IP stack.
- **Vulnerability Scanning**: Integrates ClamAV for malware scanning and Debsecan for vulnerability scanning.
- **Cron Job Security**: Secures cron jobs by restricting permissions.
- **Core Dump Restrictions**: Limits the system's ability to create core dumps.

## Prerequisites

Before running the script, ensure you have root access to your Ubuntu  server.

## Installation

1. **Download the Script**:
   You can download the script directly using wget or curl, or you can clone this repository.

   ```bash
   wget https://example.com/stig_harden_ubuntu.sh
   # OR
   curl -O https://example.com/stig_harden_ubuntu.sh` 

2.  **Make the Script Executable**: Change the script's permissions to make it executable.
    
  
    
    `chmod +x stig_harden_ubuntu.sh` 
    
3.  **Run the Script**: Execute the script as the root user to apply the security configurations.
    
   
    
    `sudo ./stig_harden_ubuntu.sh` 
    

## Usage

Run the script on a fresh installation of minimum Ubuntu 20.04 LTS to ensure that there are no conflicts with existing configurations. It can also be run on existing systems to apply security enhancements but review the changes and backup important data before running the script in production environments.

## Contributions

Contributions are always welcome! If you have suggestions for improving the script or have identified issues, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License 

## Disclaimer

This script is provided "as is", without warranty of any kind, express or implied. Always test in a staging environment before deploying into production.
