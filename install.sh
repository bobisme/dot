#!/bin/sh
# One-liner installer for development environment
# Usage: curl -sSL https://8o8.me/sh | sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
info() {
  printf "${GREEN}[INFO]${NC} %s\n" "$1"
}

warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1"
  exit 1
}

# Check if running in a supported shell
check_shell() {
  if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || [ -n "$FISH_VERSION" ] || [ -n "$KSH_VERSION" ]; then
    return 0
  else
    warn "Unknown shell detected. Proceeding anyway..."
  fi
}

# Check if Nix is installed
check_nix() {
  if command -v nix >/dev/null 2>&1; then
    info "Nix is already installed"
    return 0
  else
    info "Nix is not installed"
    return 1
  fi
}

# Setup Nix build users for root/container environments
setup_nix_build_users() {
  # Create nixbld group if it doesn't exist
  if ! getent group nixbld >/dev/null 2>&1; then
    info "Creating nixbld group..."
    groupadd -r nixbld || true
  fi

  # Create nixbld users if they don't exist
  for n in $(seq 1 10); do
    if ! id "nixbld$n" >/dev/null 2>&1; then
      info "Creating nixbld$n user..."
      useradd -c "Nix build user $n" \
        -d /var/empty \
        -g nixbld \
        -G nixbld \
        -M \
        -N \
        -r \
        -s "$(command -v nologin || echo /usr/sbin/nologin || echo /bin/false)" \
        "nixbld$n" || true
    fi
  done

  # Create /nix directory with proper permissions if it doesn't exist
  if [ ! -d /nix ]; then
    info "Creating /nix directory..."
    mkdir -m 0755 /nix
    chown root:root /nix
  fi
}

# Install Nix
install_nix() {
  info "Installing Nix..."

  # Detect OS
  OS="$(uname -s)"
  case "$OS" in
  Linux*)
    info "Detected Linux"
    ;;
  Darwin*)
    info "Detected macOS"
    ;;
  *)
    error "Unsupported operating system: $OS"
    ;;
  esac

  # Check if running as root (common in containers)
  if [ "$(id -u)" = "0" ]; then
    warn "Running as root. Creating a non-root user for Nix installation..."

    # Create a non-root user for Nix
    if ! id nix-user >/dev/null 2>&1; then
      info "Creating nix-user..."
      useradd -m -s /bin/bash nix-user || error "Failed to create nix-user"
    fi

    # Setup build users
    setup_nix_build_users

    # Copy this script to the user's home and run as non-root
    info "Switching to non-root user for Nix installation..."
    cp "$1" /tmp/install-as-user.sh
    chmod +x /tmp/install-as-user.sh
    su - nix-user -c "INSTALL_AS_USER=1 /tmp/install-as-user.sh $*"
    exit $?
  fi

  # Download and run the official Nix installer (single-user mode)
  info "Downloading Nix installer..."
  info "Installing in single-user mode..."
  if command -v curl >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh -s -- --no-daemon
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- https://nixos.org/nix/install | sh -s -- --no-daemon
  else
    error "Neither curl nor wget found. Please install one of them."
  fi

  # Source Nix profile
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  else
    error "Could not find Nix profile script. Installation may have failed."
  fi

  info "Nix installation completed"
}

# Enter the development shell
enter_devshell() {
  info "Entering development shell from github:bobisme/dot..."

  # Check for full flag
  if [ "$1" = "--full" ] || [ "$1" = "-f" ]; then
    SHELL_TARGET="#full"
    info "Using full environment..."
  else
    SHELL_TARGET=""
    info "Using minimal environment (use --full for all tools)..."
  fi

  # Check if experimental features are enabled
  if ! nix --version 2>&1 | grep -q "flakes"; then
    warn "Flakes experimental feature might not be enabled"
    info "Attempting to run with experimental features..."
    exec nix --experimental-features 'nix-command flakes' develop "github:bobisme/dot${SHELL_TARGET}"
  else
    exec nix develop "github:bobisme/dot${SHELL_TARGET}"
  fi
}

# Main execution
main() {
  # Skip the initial message if we're re-running as non-root user
  if [ "$INSTALL_AS_USER" != "1" ]; then
    info "Starting development environment setup..."
  fi

  check_shell

  if ! check_nix; then
    install_nix

    # Ensure Nix is in PATH for current session after installation
    if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi

    # Re-check after installation and sourcing
    if ! check_nix; then
      error "Nix installation failed. Please check the output above."
    fi
  fi

  enter_devshell "$@"
}

# Run main function
main "$@"
