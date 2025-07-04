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

            # Clean up on exit
            trap "rm -rf $HOME" EXIT

            echo "Welcome to your ephemeral dev environment!"
            echo "Your temporary home is: $HOME"
            echo "Run 'fish' to switch to fish shell"
          '';
        };
      });
}

