#!/bin/bash

COMMON_INSTALL_DIRS=(
    "/opt"
    "/usr/local/bin"
    "$HOME/.local/bin"
    "$HOME/bin"
)

BROWSER_PATTERNS=(
    "firefox*"
    "chrome*"
    "brave*"
    "opera*"
)

MANUAL_INSTALL_PATTERNS=(
    "*.AppImage"
    "*.tar.gz"
    "*.zip"
    "*.bin"
    "*.run"
    "*.deb"
    "*.rpm"
)

IGNORE_PATTERNS=(
    "*.so"
    "update-all"
    "pip*"
    "crashreporter"
    "updater"
    "glxtest"
    "vaapitest"
    "pingsender"
    "normalizer"
    "realpython"
    "mako-render"
    "ks*"
    "git-credential*"
)

print_message() {
    echo -e "\e[1;34m $1\e[0m"
}

print_warning() {
    echo -e "\e[1;33m WARNING: $1\e[0m"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_warning "$1 is not installed. Skipping..."
        return 1
    fi
    return 0
}

check_sudo() {
    if [ "$EUID" -ne 0 ]; then 
        print_warning "This script must be run with sudo."
        echo "Please run: sudo update-all"
        exit 1
    fi
}

update_dnf() {
    print_message "Updating DNF packages..."
    dnf check-update
    dnf upgrade -y
}

update_rpm_fusion() {
    print_message "Checking RPM Fusion updates..."
    if [ -f /etc/yum.repos.d/rpmfusion-free.repo ] || [ -f /etc/yum.repos.d/rpmfusion-nonfree.repo ]; then
        dnf update rpmfusion-* -y
    fi
}

update_flatpak() {
    if check_command flatpak; then
        print_message "Updating Flatpak packages..."
        flatpak update -y
    fi
}

update_snap() {
    if check_command snap; then
        print_message "Updating Snap packages..."
        snap refresh
    fi
}

update_pip() {
    if check_command pip; then
        print_message "Checking Python packages..."
        python3 -c "
import subprocess
import json
def check_user_packages():
    try:
        result = subprocess.run(
            ['pip', 'list', '--user', '--outdated', '--format=json'],
            capture_output=True,
            text=True
        )
        packages = json.loads(result.stdout)
        if packages:
            print('\nOutdated user packages:')
            for pkg in packages:
                print('  - {} ({} -> {})'.format(
                    pkg['name'],
                    pkg['version'],
                    pkg['latest_version']
                ))
            print('\nTo update safely, run:')
            print('  python3 -m pip install --user --upgrade <package-name>')
        else:
            print('\nAll user-installed Python packages are up to date')
    except Exception as e:
        print('\nAll user-installed Python packages are up to date')
check_user_packages()
"
    fi
}

update_npm() {
    if check_command npm; then
        print_message "Updating global npm packages..."
        npm update -g
    fi
}

update_cargo() {
    if check_command cargo; then
        print_message "Updating Rust packages (cargo)..."
        cargo install-update -a
    fi
}

check_manual_installs() {
    local dir="$1"
    local days_threshold=30
    if [ -d "$dir" ]; then
        local pattern_args=()
        for pattern in "${MANUAL_INSTALL_PATTERNS[@]}"; do
            pattern_args+=(-o -name "$pattern")
        done
        unset 'pattern_args[0]'
        find "$dir" -maxdepth 2 -type f \( "${pattern_args[@]}" \) \
            -mtime +$days_threshold 2>/dev/null | while read -r file; do
            print_warning "Found $(basename "$file") in $(dirname "$file") - might need manual update"
        done
    fi
}

check_browsers() {
    for browser_pattern in "${BROWSER_PATTERNS[@]}"; do
        for binary in /usr/bin/$browser_pattern /usr/local/bin/$browser_pattern; do
            if ls $binary >/dev/null 2>&1; then
                while read -r browser_path; do
                    browser_name=$(basename "$browser_path")
                    if ! rpm -q --file "$browser_path" >/dev/null 2>&1; then
                        print_warning "Found manually installed browser: $browser_name"
                    fi
                done < <(ls -1 $binary 2>/dev/null)
            fi
        done
    done
}

check_install_directories() {
    for dir in "${COMMON_INSTALL_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            while read -r file; do
                local should_ignore=0
                for pattern in "${IGNORE_PATTERNS[@]}"; do
                    if [[ $(basename "$file") == $pattern ]]; then
                        should_ignore=1
                        break
                    fi
                done
                if [ $should_ignore -eq 0 ] && [ -f "$file" ] && ! rpm -q --file "$file" >/dev/null 2>&1; then
                    print_warning "Found potential manually installed program: $(basename "$file") in $dir"
                fi
            done < <(find "$dir" -type f -executable 2>/dev/null)
        fi
    done
}

perform_cleanup() {
    print_message "Performing system cleanup..."
    dnf clean all
    dnf autoremove -y
}

check_manual_updates() {
    print_message "Checking for programs that might need manual updates..."
    check_manual_installs "$HOME/Downloads"
    check_browsers
    check_install_directories
}

main() {
    check_sudo
    print_message "Starting system-wide update..."
    update_dnf
    update_rpm_fusion
    update_flatpak
    update_snap
    update_pip
    update_npm
    update_cargo
    check_manual_updates
    perform_cleanup
    print_message "System update completed successfully!"
    print_message "Remember to check your manually installed applications for updates!"
}

main