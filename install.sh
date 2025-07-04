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

  # Check if experimental features are enabled
  if ! nix --version 2>&1 | grep -q "flakes"; then
    warn "Flakes experimental feature might not be enabled"
    info "Attempting to run with experimental features..."
    exec nix --experimental-features 'nix-command flakes' develop github:bobisme/dot
  else
    exec nix develop github:bobisme/dot
  fi
}

# Main execution
main() {
  info "Starting development environment setup..."

  check_shell

  if ! check_nix; then
    install_nix

    # Re-check after installation
    if ! check_nix; then
      error "Nix installation failed. Please check the output above."
    fi
  fi

  # Ensure Nix is in PATH for current session
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi

  enter_devshell
}

# Run main function
main "$@"
