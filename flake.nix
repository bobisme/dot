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
          ncdu
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
          EPHEMERAL_HOME="$(mktemp -d /tmp/ephemeral-home.XXXXXX)"
          export HOME="$EPHEMERAL_HOME"

          echo "Setting up ephemeral environment in $HOME..."

          # Set up dotfiles from the flake
          mkdir -p "$HOME/.config"

          # Copy configs with proper permissions
          copy_config "git"
          copy_config "fish" "755"
          copy_config "nvim"
          copy_config "ncdu"

          # Fix LazyVim permissions
          [ -f "$HOME/.config/nvim/lazy-lock.json" ] && chmod 644 "$HOME/.config/nvim/lazy-lock.json"

          # Symlink individual files
          link_file "${./config/starship.toml}" "$HOME/.config/starship.toml"
          link_file "${./config/tmux/tmux.conf}" "$HOME/.tmux.conf"

          # Copy nix helper scripts
          mkdir -p "$HOME/.local/bin"
          if [ -d "${./nix}" ]; then
            # Copy executable scripts to bin
            for script in ${./nix}/*; do
              if [ -f "$script" ] && [ "$(basename "$script")" != "fish_command_not_found.fish" ]; then
                cp "$script" "$HOME/.local/bin/" 2>/dev/null || true
                chmod +x "$HOME/.local/bin/$(basename "$script")" 2>/dev/null || true
              fi
            done
          fi

          # Add local bin to PATH
          export PATH="$HOME/.local/bin:$PATH"

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
            mkdir -p "$HOME/.config/fish/functions"
            chmod 755 "$HOME/.config/fish/functions"
            
            # Set up fzf keybindings
            if command -v fzf >/dev/null; then
              fzf --fish > "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
              chmod 644 "$HOME/.config/fish/functions/fzf_key_bindings.fish" 2>/dev/null || true
            fi
            
            # Set up command not found handler
            if [ -f "${./nix/fish_command_not_found.fish}" ]; then
              cp "${
                ./nix/fish_command_not_found.fish
              }" "$HOME/.config/fish/functions/"
              chmod 644 "$HOME/.config/fish/functions/fish_command_not_found.fish"
            fi
          }

          # Set up terminal environment
          export TERM=xterm-256color
          export LC_ALL=C.UTF-8
          export LANG=C.UTF-8

          # Enable Nix experimental features
          export NIX_CONFIG="experimental-features = nix-command flakes"

          # Set shell to fish so nix commands use it
          export SHELL=${pkgs.fish}/bin/fish

          # Set up all components
          setup_tmux
          setup_editor_dirs
          setup_fish

          # Aliases
          alias l='eza'
          alias cat='bat'
          alias e='nvim'

          # Clean up on exit with safety checks
          cleanup_ephemeral() {
            # Only clean up if it's actually our ephemeral directory
            if [ -n "$EPHEMERAL_HOME" ] && [ -d "$EPHEMERAL_HOME" ]; then
              # Extra safety: ensure it's in /tmp and contains "ephemeral-home"
              case "$EPHEMERAL_HOME" in
                /tmp/ephemeral-home.*)
                  echo "Cleaning up ephemeral environment: $EPHEMERAL_HOME"
                  rm -rf "$EPHEMERAL_HOME"
                  ;;
                *)
                  echo "WARNING: Refusing to clean up unexpected directory: $EPHEMERAL_HOME"
                  ;;
              esac
            fi
          }
          trap cleanup_ephemeral EXIT
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

