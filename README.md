<br>

<p align="center">  
  <strong>Fedora System Updater</strong>
</p>
  
<p align="center">
  A shell script to automate system updates on Fedora Linux, including multiple package managers and detection of manually installed programs that might need updates.
</p>

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

</div>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#dependencies">Dependencies</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#license">License</a>
</p>

## Features

The Fedora System Updater offers a comprehensive solution to keep your system up to date:

- Updates packages from multiple package managers:
  - DNF (Fedora's main package manager)
  - Flatpak
  - Snap
  - Python pip (user packages)
  - Node.js npm (global packages)
  - Rust cargo
- Detects manually installed programs that might need updates
- Performs system cleanup after updates
- Clear, colored output for better readability:
  - **Blue**: Regular status messages
  - **Yellow**: Warnings and manual update notifications

## Dependencies

### Required

- `bash`
- `dnf`

### Optional

The script will check for these and skip if not found:
- `flatpak`
- `snap`
- `pip`
- `npm`
- `cargo`

## Installation

1. Clone the repository:
   
   **Via SSH**
   ```bash
   git clone git@github.com:yourusername/update-all-script.git
   ```
   
   **Via HTTPS**
   ```bash
   git clone https://github.com/yourusername/update-all-script.git
   ```

2. Install the script:
   ```bash
   cd update-all-script
   sudo cp src/update-all.sh /usr/local/bin/update-all
   sudo chmod +x /usr/local/bin/update-all
   ```

3. Configure PATH
   
   The system PATH needs to include `/usr/local/bin` for the script to be executable from any directory. There are two configuration options:

   #### 1: Temporary configuration

   For the current terminal session:
   ```bash
   export PATH=$PATH:/usr/local/bin
   ```

   #### 2: Permanent configuration

   Add to your shell configuration file:
   
   ```bash
   # Bash users:
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc  
   source ~/.bashrc
   
   # Zsh users:   
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.zshrc
   source ~/.zshrc
   ```

4. Verify installation:
   
   ```bash
   which update-all
   ```
   
   The output should show: `/usr/local/bin/update-all`

## Usage

Run the script as superuser:

```bash
sudo update-all
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
