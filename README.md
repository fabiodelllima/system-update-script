# Fedora System Updater

A shell script to automate system updates on Fedora Linux, including multiple package managers and detection of manually installed programs that might need updates.

## Features

- Updates packages from multiple package managers:
  - DNF (Fedora's main package manager)
  - Flatpak
  - Snap
  - Python's pip (user packages)
  - Node.js npm (global packages)
  - Rust's cargo
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

1. Clone this repository:

   **Via SSH**
   ```bash
   git clone git@github.com:yourusername/update-all-script.git
   ```
   **Via HTTPS**
   ```bash
   git clone https://github.com/yourusername/update-all-script.git
   ```

2. Move the script to your local bin:
   ```bash
   sudo cp src/update-all.sh /usr/local/bin/update-all
   ```
3. Make the script executable:
   ```bash
   sudo chmod +x /usr/local/bin/update-all
   ```

## Usage

Simply run:
```bash
sudo update-all
```

The script will:
- Check and update DNF packages.
- Update packages from other package managers if installed.
- Check for manually installed programs that might need updates.
- Clean up unnecessary files.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.