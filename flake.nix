{
  description = "Bob's standard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core tools only
            git
            neovim
            tmux
            fish

            # Essential dev tools
            ripgrep
            fd
            bat
            eza
            fzf

            # Minimal extras
            curl
            jq
            starship
            openssh # for ssh-agent
          ];

          shellHook = ''
            # Create ephemeral home directory
            export REAL_HOME="$HOME"
            export HOME="$(mktemp -d /tmp/ephemeral-home.XXXXXX)"

            echo "Setting up minimal ephemeral environment in $HOME..."

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
            fi

            # Nvim config (copy so LazyVim can install plugins)
            if [ -d "${./config/nvim}" ]; then
              mkdir -p "$HOME/.config/nvim"
              cp -r ${./config/nvim}/* "$HOME/.config/nvim/" 2>/dev/null || true
              cp -r ${./config/nvim}/.* "$HOME/.config/nvim/" 2>/dev/null || true
            fi

            # Starship
            if [ -f "${./config/starship.toml}" ]; then
              ln -sf "${./config/starship.toml}" "$HOME/.config/starship.toml"
            fi

            # Symlink tmux config file
            if [ -f "${./config/tmux/tmux.conf}" ]; then
              ln -sf "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"
            fi

            # Install tmux plugin manager (TPM)
            mkdir -p "$HOME/.tmux/plugins"
            mkdir -p "$HOME/.config/tmux/plugins"  # TPM might look here too
            if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
              ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
            fi

            # Set up nvim directories
            mkdir -p "$HOME/.local/share/nvim"
            mkdir -p "$HOME/.local/state/nvim"
            mkdir -p "$HOME/.cache/nvim"

            # Set up fzf for fish
            mkdir -p "$HOME/.config/fish/functions"
            if command -v fzf-share >/dev/null; then
              cp -f "$(fzf-share)/key-bindings.fish" "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
            fi

            # Aliases
            alias l='eza'
            alias cat='bat'
            alias e='nvim'

            # Clean up on exit
            trap "rm -rf $HOME" EXIT

            echo "Minimal ephemeral environment ready!"
            exec fish
          '';
        };

        devShells.full = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core tools
            git
            neovim
            tmux
            fish
            nushell

            # Development tools
            ripgrep
            fd
            bat
            eza
            fzf
            delta

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
            curl
            jq
            openssh # for ssh-agent

            # Your other common tools
            gh
            lazygit
            direnv
            starship
          ];

          shellHook = ''
            # Create ephemeral home directory
            export REAL_HOME="$HOME"
            export HOME="$(mktemp -d /tmp/ephemeral-home.XXXXXX)"

            echo "Setting up ephemeral environment in $HOME..."

            # Set up dotfiles from the flake
            mkdir -p "$HOME/.config"

            # Symlink neovim config
            if [ -d "${./config/nvim}" ]; then
              ln -sf "${./config/nvim}" "$HOME/.config/nvim"
            fi

            # Symlink tmux config
            if [ -f "${./config/tmux/tmux.conf}" ]; then
              ln -sf "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"
            fi

            # Copy other configs (so they're writable)
            for config in git fish; do
              if [ -d "${./config}/$config" ]; then
                mkdir -p "$HOME/.config/$config"
                cp -r ${./config}/$config/* "$HOME/.config/$config/" 2>/dev/null || true
                cp -r ${./config}/$config/.* "$HOME/.config/$config/" 2>/dev/null || true
              fi
            done

            # Set up aliases
            alias l='eza'
            alias cat='bat'
            alias e='nvim'

            # Install tmux plugin manager (TPM)
            mkdir -p "$HOME/.tmux/plugins"
            mkdir -p "$HOME/.config/tmux/plugins"  # TPM might look here too
            if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
              ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
            fi

            # Set up LazyVim to auto-install on first launch
            mkdir -p "$HOME/.local/share/nvim"
            mkdir -p "$HOME/.local/state/nvim"
            mkdir -p "$HOME/.cache/nvim"

            # Set up fzf for fish
            mkdir -p "$HOME/.config/fish/functions"
            if command -v fzf-share >/dev/null; then
              cp -f "$(fzf-share)/key-bindings.fish" "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
            fi

            # Clean up on exit
            trap "rm -rf $HOME" EXIT

            echo "Welcome to your ephemeral dev environment!"
            echo "Your temporary home is: $HOME"

            # Launch fish shell directly
            exec fish
          '';
        };
      });
}

