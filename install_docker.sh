#!/bin/bash

# Script to automatically install the latest Docker based on the detected OS
# Usage: ./install_docker.sh
# Logs will be saved to /dockerinstalllog.text

# Define log file
LOG_FILE="/dockerinstalllog.text"

# Function to display and log messages
log() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1"
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

# Function to check if running as root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        log "Error: This script must be run as root or with sudo privileges"
        exit 1
    fi
}

# Function to install Docker on Debian/Ubuntu
install_docker_debian() {
    log "Installing Docker on Debian/Ubuntu..."
    
    # Update package index
    log "Updating package index..."
    apt-get update >> "$LOG_FILE" 2>&1
    
    # Install prerequisites
    log "Installing prerequisites..."
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release >> "$LOG_FILE" 2>&1
    
    # Add Docker's official GPG key
    log "Adding Docker's official GPG key..."
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$ID/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >> "$LOG_FILE" 2>&1
    
    # Set up the repository
    log "Setting up Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update with Docker repo
    apt-get update >> "$LOG_FILE" 2>&1
    
    # Install Docker Engine
    log "Installing latest Docker Engine..."
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1
    
    # Start and enable Docker service
    log "Starting and enabling Docker service..."
    systemctl enable --now docker >> "$LOG_FILE" 2>&1
    
    log "Docker has been successfully installed on $ID!"
}

# Function to install Docker on Red Hat/CentOS/Fedora
install_docker_redhat() {
    log "Installing Docker on $ID..."
    
    # Install prerequisites
    log "Installing prerequisites..."
    if [ "$ID" == "fedora" ]; then
        dnf -y install dnf-plugins-core >> "$LOG_FILE" 2>&1
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo >> "$LOG_FILE" 2>&1
        log "Installing latest Docker Engine..."
        dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1
    else
        yum install -y yum-utils >> "$LOG_FILE" 2>&1
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >> "$LOG_FILE" 2>&1
        log "Installing latest Docker Engine..."
        yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1
    fi
    
    # Start and enable Docker service
    log "Starting and enabling Docker service..."
    systemctl enable --now docker >> "$LOG_FILE" 2>&1
    
    log "Docker has been successfully installed on $ID!"
}

# Function to install Docker on Amazon Linux
install_docker_amazon() {
    log "Installing Docker on Amazon Linux..."
    
    # Update package index
    log "Updating package index..."
    yum update -y >> "$LOG_FILE" 2>&1
    
    # Install Docker
    log "Installing latest Docker Engine..."
    amazon-linux-extras install docker -y >> "$LOG_FILE" 2>&1
    
    # Start and enable Docker service
    log "Starting and enabling Docker service..."
    systemctl enable --now docker >> "$LOG_FILE" 2>&1
    
    log "Docker has been successfully installed on Amazon Linux!"
}

# Function to install Docker on SUSE/openSUSE
install_docker_suse() {
    log "Installing Docker on $ID..."
    
    # Install dependencies
    log "Installing prerequisites..."
    zypper install -y curl >> "$LOG_FILE" 2>&1
    
    # Install Docker packages
    log "Adding Docker repository..."
    zypper addrepo https://download.docker.com/linux/sles/docker-ce.repo >> "$LOG_FILE" 2>&1
    zypper refresh >> "$LOG_FILE" 2>&1
    
    log "Installing latest Docker Engine..."
    zypper install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >> "$LOG_FILE" 2>&1
    
    # Start and enable Docker service
    log "Starting and enabling Docker service..."
    systemctl enable --now docker >> "$LOG_FILE" 2>&1
    
    log "Docker has been successfully installed on $ID!"
}

# Function to install Docker on Arch Linux
install_docker_arch() {
    log "Installing Docker on Arch Linux..."
    
    # Update package index
    log "Updating package index..."
    pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1
    
    # Install Docker
    log "Installing latest Docker Engine..."
    pacman -S --noconfirm docker >> "$LOG_FILE" 2>&1
    
    # Start and enable Docker service
    log "Starting and enabling Docker service..."
    systemctl enable --now docker >> "$LOG_FILE" 2>&1
    
    log "Docker has been successfully installed on Arch Linux!"
}

# Main function
main() {
    # Initialize log file
    echo "Docker Installation Log - Started at $(date)" > "$LOG_FILE"
    echo "=======================================" >> "$LOG_FILE"
    
    log "Starting Docker installation..."
    check_root
    
    # Detect OS
    if [ -f "/etc/os-release" ]; then
        . /etc/os-release
        log "Detected OS: $NAME (ID: $ID, Version: $VERSION_ID)"
        
        case "$ID" in
            debian|ubuntu|raspbian)
                install_docker_debian
                ;;
            centos|rhel|fedora|rocky|almalinux)
                install_docker_redhat
                ;;
            amzn)
                install_docker_amazon
                ;;
            sles|opensuse*)
                install_docker_suse
                ;;
            arch)
                install_docker_arch
                ;;
            *)
                log "Unsupported OS: $NAME"
                exit 1
                ;;
        esac
    else
        log "Cannot detect OS, /etc/os-release file not found"
        exit 1
    fi
    
    # Verify installation
    if command -v docker &>/dev/null; then
        DOCKER_VERSION=$(docker --version)
        log "Verification: Docker has been successfully installed"
        log "Docker version: $DOCKER_VERSION"
        
        # Save Docker daemon info to log
        log "Docker daemon information:"
        docker info >> "$LOG_FILE" 2>&1
        
        log "Adding current user to the docker group..."
        if [ -n "$SUDO_USER" ]; then
            usermod -aG docker "$SUDO_USER" >> "$LOG_FILE" 2>&1
            log "User $SUDO_USER added to the docker group. You may need to log out and back in for this to take effect."
        fi
        
        log "Testing Docker installation with hello-world image..."
        docker run hello-world >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            log "Docker hello-world test successful!"
        else
            log "Docker hello-world test failed. Please check the log for details."
        fi
    else
        log "Docker installation failed"
        exit 1
    fi
    
    log "Installation complete! Full logs available at $LOG_FILE"
    echo "=======================================" >> "$LOG_FILE"
    echo "Docker Installation Completed at $(date)" >> "$LOG_FILE"
}

# Execute main function
main
