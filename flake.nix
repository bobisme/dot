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
          # Helper function to copy config directory with proper permissions
          copy_config() {
            local config_name="$1"
            local extra_perms="$2"
            local source="${./config}/$config_name"
            local dest="$HOME/.config/$config_name"

            if [ -d "$source" ]; then
              mkdir -p "$dest"
              cp -r $source/* "$dest/" 2>/dev/null || true
              cp -r $source/.* "$dest/" 2>/dev/null || true
              # Apply extra permissions if specified
              if [ -n "$extra_perms" ]; then
                chmod -R "$extra_perms" "$dest" 2>/dev/null || true
              fi
            fi
          }

          # Helper function to symlink a file
          link_file() {
            local source="$1"
            local dest="$2"
            if [ -f "$source" ]; then
              ln -sf "$source" "$dest"
            fi
          }

          # Create ephemeral home directory
          export REAL_HOME="$HOME"
          export HOME="$(mktemp -d /tmp/ephemeral-home.XXXXXX)"

          echo "Setting up ephemeral environment in $HOME..."

          # Set up dotfiles from the flake
          mkdir -p "$HOME/.config"

          # Copy configs with proper permissions
          copy_config "git"
          copy_config "fish" "755"
          copy_config "nvim"

          # Fix LazyVim permissions
          [ -f "$HOME/.config/nvim/lazy-lock.json" ] && chmod 644 "$HOME/.config/nvim/lazy-lock.json"

          # Symlink individual files
          link_file "${./config/starship.toml}" "$HOME/.config/starship.toml"
          link_file "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"

          # Helper function to set up tmux
          setup_tmux() {
            mkdir -p "$HOME/.tmux/plugins" "$HOME/.config/tmux/plugins"
            if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
              ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
              # Auto-install tmux plugins
              [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ] && \
                "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
            fi
          }

          # Helper function to set up editor directories
          setup_editor_dirs() {
            mkdir -p "$HOME/.local/share/nvim" \
                     "$HOME/.local/state/nvim" \
                     "$HOME/.cache/nvim"
          }

          # Helper function to set up fish
          setup_fish() {
            if command -v fzf >/dev/null; then
              mkdir -p "$HOME/.config/fish/functions"
              chmod 755 "$HOME/.config/fish/functions"
              fzf --fish > "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
              chmod 644 "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
            fi
          }

          # Set up terminal environment
          export TERM=xterm-256color
          export LC_ALL=C.UTF-8
          export LANG=C.UTF-8

          # Set up all components
          setup_tmux
          setup_editor_dirs
          setup_fish

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

