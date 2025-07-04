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
        devShells.minimal = pkgs.mkShell {
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

            # Symlink configs
            for config in git fish nvim tmux starship.toml; do
              if [ -d "${./config}/$config" ]; then
                ln -sf "${./config}/$config" "$HOME/.config/$config"
              elif [ -f "${./config}/$config" ]; then
                ln -sf "${./config}/$config" "$HOME/.config/$config"
              fi
            done

            # Symlink tmux config file
            if [ -f "${./config/tmux/tmux.conf}" ]; then
              ln -sf "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"
            fi

            # Install tmux plugins
            if [ -d "${./config/tmux/plugins}" ]; then
              mkdir -p "$HOME/.tmux"
              cp -r "${./config/tmux/plugins}" "$HOME/.tmux/"
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

        devShells.default = pkgs.mkShell {
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

            # Symlink other configs
            for config in git fish nvim tmux; do
              if [ -d "${./config}/$config" ]; then
                ln -sf "${./config}/$config" "$HOME/.config/$config"
              fi
            done

            # Set up aliases
            alias l='eza'
            alias cat='bat'
            alias e='nvim'

            # Install tmux plugins automatically
            if [ -d "${./config/tmux/plugins/tpm}" ]; then
              mkdir -p "$HOME/.tmux/plugins"
              cp -r "${./config/tmux/plugins}" "$HOME/.tmux/"
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

