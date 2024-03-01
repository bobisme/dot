set -x PATH $HOME/bin $PATH
if type -q nvim
    set -x EDITOR nvim
else if type -q vim
    set -x EDITOR vim
else if type -q vi
    set -x EDITOR vi
end

alias e=$EDITOR

if not set --query XDG_CONFIG_HOME
    set -x XDG_CONFIG_HOME $HOME/.config
end

if type -q cargo
    set -x PATH $HOME/.cargo/bin $PATH
end

if type -q eza
    set -x EZA_ICON_SPACING 2
    set -x EZA_ICONS_AUTO true
    abbr -a l eza
end

if type -q zoxide
    zoxide init fish | source
    abbr -a j z
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
        set -x BAT_STYLE plain
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
    # set -x GTK_THEME "Mojave-Dark-solid:dark"
    set -x GTK_THEME "Adwaita:dark"
    set -x QT_QPA_PLATFORMTHEME qt5ct
    alias chatgpt 'OPENAI_API_KEY=(pass show openapi/nvim) pipx run --spec git+https://github.com/marcolardera/chatgpt-cli chatgpt-cli --multiline'
end
