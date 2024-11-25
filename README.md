# Remote Network Anonymity and Scan Automation

## Project Structure
1. **Installations and Anonymity Check**
   - Automatically install required tools (Sshpass, Nipe, Nmap, Whois).
   - Avoid redundant installations by verifying if the tools are already installed.
   - Check if the current network is anonymous. If not, alert the user and exit.
   - If anonymous, display the spoofed country name.
   - Prompt the user to specify a scan target, and store it for further use.

2. **Automatic Remote Server Operations**
   - Connect to a remote server via SSH using provided credentials.
   - Retrieve and display server details (country, IP, uptime).
   - Perform a `whois` query and scan open ports on the specified target.

3. **Result Management**
   - Save the `whois` and `nmap` results into structured files locally.
   - Maintain a detailed log of actions and outputs for auditing purposes.

4. **Creative Implementation**
   - Designed with a modular approach using Bash functions.
   - Fully automated with minimal user interaction after initial input.

---

## Features
- **Network Anonymity Verification**: Leverages Nipe to anonymize traffic and confirm the spoofed IP location.
- **Remote Scanning**: Automates connection to remote servers for detailed `whois` and port scanning.
- **Auditing and Logging**: Maintains logs with timestamps for traceability.
- **User-Friendly**: Requires minimal user input and provides clear feedback during execution.

---

## Prerequisites
- **OS**: Kali Linux or compatible Linux distribution.
- **Tools**: 
  - Bash shell
  - Git
  - Internet connection

---

## Setup and Usage
### 1. Clone the repository
```bash
git clone https://github.com/username/NetworkScanner.git
cd NetworkScanner
