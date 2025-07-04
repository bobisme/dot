{
  description = "Bob's standard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Minimal tools for both environments
        minimalTools = with pkgs; [
          bat
          curl
          delta
          eza
          fd
          fish
          fzf
          git
          jq
          lazygit
          neovim
          openssh
          ripgrep
          starship
          tmux
        ];

        # Additional tools for full environment
        fullTools = with pkgs; [
          nushell

          # Language support
          nodejs
          python3
          go
          rustc
          cargo

          # System tools
          btop
          ncdu
          wget

          # Other tools
          gh
          direnv
        ];

        # Common shell hook
        commonShellHook = ''
          # Create ephemeral home directory
          export REAL_HOME="$HOME"
          export HOME="$(mktemp -d /tmp/ephemeral-home.XXXXXX)"

          echo "Setting up ephemeral environment in $HOME..."

          # Set up dotfiles from the flake
          mkdir -p "$HOME/.config"

          # Set up configs (copy instead of symlink for writable directories)
          # Git config
          if [ -d "${./config/git}" ]; then
            mkdir -p "$HOME/.config/git"
            cp -r ${./config/git}/* "$HOME/.config/git/" 2>/dev/null || true
            cp -r ${./config/git}/.* "$HOME/.config/git/" 2>/dev/null || true
          fi

          # Fish config
          if [ -d "${./config/fish}" ]; then
            mkdir -p "$HOME/.config/fish"
            cp -r ${./config/fish}/* "$HOME/.config/fish/" 2>/dev/null || true
            cp -r ${./config/fish}/.* "$HOME/.config/fish/" 2>/dev/null || true
            # Ensure fish config is writable
            chmod -R 755 "$HOME/.config/fish" 2>/dev/null || true
          fi

          # Nvim config (copy so LazyVim can install plugins)
          if [ -d "${./config/nvim}" ]; then
            mkdir -p "$HOME/.config/nvim"
            cp -r ${./config/nvim}/* "$HOME/.config/nvim/" 2>/dev/null || true
            cp -r ${./config/nvim}/.* "$HOME/.config/nvim/" 2>/dev/null || true
            # Ensure lazy-lock.json is writable if it exists
            if [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
              chmod 644 "$HOME/.config/nvim/lazy-lock.json"
            fi
          fi

          # Starship
          if [ -f "${./config/starship.toml}" ]; then
            ln -sf "${./config/starship.toml}" "$HOME/.config/starship.toml"
          fi

          # Symlink tmux config file
          if [ -f "${./config/tmux/tmux.conf}" ]; then
            ln -sf "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"
          fi

          # Install tmux plugin manager (TPM) and plugins
          mkdir -p "$HOME/.tmux/plugins"
          mkdir -p "$HOME/.config/tmux/plugins"  # TPM might look here too
          if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
            ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
            # Auto-install tmux plugins
            if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
              "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
            fi
          fi
          
          # Set up terminal capabilities for tmux (for proper font support)
          export TERM=xterm-256color
          # Use C.UTF-8 which is more universally available
          export LC_ALL=C.UTF-8
          export LANG=C.UTF-8

          # Set up nvim directories
          mkdir -p "$HOME/.local/share/nvim"
          mkdir -p "$HOME/.local/state/nvim"
          mkdir -p "$HOME/.cache/nvim"

          # Set up fzf for fish
          if command -v fzf >/dev/null; then
            # Ensure the functions directory exists and is writable
            mkdir -p "$HOME/.config/fish/functions"
            chmod 755 "$HOME/.config/fish/functions"
            # Generate fzf keybindings
            fzf --fish > "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
            chmod 644 "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
          fi

          # Aliases
          alias l='eza'
          alias cat='bat'
          alias e='nvim'

          # Clean up on exit
          trap "rm -rf $HOME" EXIT
        '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = minimalTools;

          shellHook = commonShellHook + ''
            echo "Minimal ephemeral environment ready!"
            exec fish
          '';
        };

        devShells.full = pkgs.mkShell {
          buildInputs = minimalTools ++ fullTools;

          shellHook = commonShellHook + ''
            echo "Welcome to your full ephemeral dev environment!"
            exec fish
          '';
        };
      });
}

