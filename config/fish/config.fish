set -x PATH $HOME/bin $PATH

if type -q cargo
    set -x PATH $HOME/.cargo/bin $PATH
end

if type -q eza
    abbr -a l eza
end

if type -q zoxide
    zoxide init fish | source
end

if type -q direnv
    direnv hook fish | source
end

if type -q rtx
    rtx activate fish | source
end

# bun
if test -d "$HOME/.bun"
    set -x BUN_INSTALL "$HOME/.bun"
    set -x PATH $BUN_INSTALL/bin $PATH
end

if status is-interactive
    eval (ssh-agent -c) >/dev/null
    # Commands to run in interactive sessions can go here
    source (/usr/bin/starship init fish --print-full-init | psub)
    # bat settings
    if type -q bat
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -x MANROFFOPT -c
        set -x BAT_THEME base16
        abbr -a bhelp "bat --plain --language=help"
    end

    if type -q fzf
        set -x FZF_CTRL_T_OPTS "--preview 'cat {}'"
        if type -q bat
            set -x FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=plain {}'"
        end
        if type -q fd
            set -x FZF_CTRL_T_COMMAND "fd --type f --strip-cwd-prefix"
        end
        # --preview-window up,1,border-horizontal \
        # --bind 'ctrl-/:change-preview-window(50%|hidden|)' \
        # --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
        set -x FZF_CTRL_T_OPTS $FZF_CTRL_T_OPTS "--preview-window right,60%,border-vertical"
        fzf_key_bindings
    end
end
