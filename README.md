# universal-docker-installer

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-green.svg)
![Platform](https://img.shields.io/badge/platform-linux-lightgrey.svg)

A universal, automated Docker installation script that detects your Linux distribution and installs the latest Docker Engine with proper configuration and logging.

## 🚀 Features

- **Multi-platform support**: Works across major Linux distributions
- **Automated detection**: Automatically identifies your OS and version
- **Comprehensive logging**: Detailed installation logs with timestamps
- **Error handling**: Robust error checking and validation
- **Post-installation setup**: Configures Docker service and user permissions
- **Installation verification**: Tests Docker installation with hello-world container
- **Production-ready**: Follows Docker's official installation guidelines

## 📋 Supported Operating Systems

| Distribution | Versions | Package Manager |
|--------------|----------|-----------------|
| **Ubuntu** | 18.04, 20.04, 22.04, 24.04+ | APT |
| **Debian** | 10, 11, 12+ | APT |
| **Raspbian** | Buster, Bullseye+ | APT |
| **CentOS** | 7, 8, 9+ | YUM |
| **RHEL** | 7, 8, 9+ | YUM |
| **Fedora** | 35, 36, 37+ | DNF |
| **Rocky Linux** | 8, 9+ | YUM |
| **AlmaLinux** | 8, 9+ | YUM |
| **Amazon Linux** | 2, 2023+ | YUM |
| **SUSE/openSUSE** | 15+ | Zypper |
| **Arch Linux** | Rolling | Pacman |

## 🔧 Prerequisites

- Linux-based operating system (see supported distributions above)
- Root privileges (sudo access)
- Active internet connection
- curl (installed automatically if missing)

## 📥 Installation

### Quick Install (Recommended)

```bash
# Download and run the script
curl -fsSL https://raw.githubusercontent.com/itsredbull/universal-docker-installer/main/install_docker.sh -o install_docker.sh
chmod +x install_docker.sh
sudo ./install_docker.sh
```

### Manual Install

1. **Download the script**:
   ```bash
   wget https://raw.githubusercontent.com/itsredbull/universal-docker-installer/main/install_docker.sh
   ```

2. **Make it executable**:
   ```bash
   chmod +x install_docker.sh
   ```

3. **Run with sudo**:
   ```bash
   sudo ./install_docker.sh
   ```

## 📝 Usage

```bash
# Basic usage
sudo ./install_docker.sh

# The script will:
# 1. Detect your Linux distribution
# 2. Install required prerequisites
# 3. Add Docker's official repository
# 4. Install the latest Docker Engine
# 5. Start and enable Docker service
# 6. Add current user to docker group
# 7. Test installation with hello-world container
# 8. Generate detailed logs
```

## 📊 Logging

All installation activities are logged to `/dockerinstalllog.text` with timestamps:

```bash
# View installation log
cat /dockerinstalllog.text

# Monitor installation in real-time
tail -f /dockerinstalllog.text
```

## ✅ Post-Installation

After successful installation:

1. **Log out and back in** to apply docker group membership
2. **Verify installation**:
   ```bash
   docker --version
   docker info
   ```
3. **Test with a container**:
   ```bash
   docker run hello-world
   ```

## 🔍 What Gets Installed

- **Docker Engine** (latest stable version)
- **Docker CLI** (command-line interface)
- **containerd** (container runtime)
- **Docker Buildx** (extended build capabilities)
- **Docker Compose** (multi-container applications)

## 🛠️ Troubleshooting

### Common Issues

**Permission denied when running docker commands:**
```bash
# Log out and back in, or run:
newgrp docker
```

**Script must be run as root:**
```bash
# Always run with sudo
sudo ./install_docker.sh
```

**Unsupported OS error:**
```bash
# Check if your distribution is supported
cat /etc/os-release
```

### Getting Help

- Check the installation log: `/dockerinstalllog.text`
- Review [Docker's official documentation](https://docs.docker.com/)
- Open an [issue](https://github.com/itsredbull/universal-docker-installer/issues) on GitHub

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Ideas for Contributions

- Add support for additional Linux distributions
- Implement `--help` and `--version` flags
- Add `--dry-run` option for testing
- Create automated tests
- Improve error handling

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If this script helped you, please consider:
- Giving it a ⭐ star on GitHub
- Sharing it with others
- Contributing improvements

## 📞 Contact

- **Issues**: [GitHub Issues](https://github.com/itsredbull/universal-docker-installer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/itsredbull/universal-docker-installer/discussions)

---

**Made with ❤️ for the DevOps community**
