# bobthefish theme
set -g theme_date_format "+%Y-%m-%d %H:%M:%S"
set -g theme_date_timezone America/New_York

function prepend_path
    set -l check_path yes
    for arg in $argv
        if [ $arg = "--check-path=no" ]
            set -l check_path no
        else
            set -l path $arg
        end
    end

    if begin
            [ $check_path = no ]; or test -d $path
        end
        set -x PATH $path $PATH
    else
        return 1
    end
end

function append_path -a path
    if test -d $path
        set -x PATH $PATH $argv[1]
    end
end

# neovim is my copilot
set -x EDITOR nvim

# home bin
prepend_path $HOME/.local/bin
prepend_path $HOME/bin

# pip should only run if there is a virtualenv currently activated
set -x PIP_REQUIRE_VIRTUALENV true

# go
set -x GOPATH ~/go
set -x PATH $GOPATH/bin $PATH
# rust
if test -d $HOME/.cargo/bin
    set -x PATH ~/.cargo/bin $PATH
end
if test -d $HOME/repos/rust/src
    set -x RUST_SRC_PATH ~/repos/rust/src
end

# run node scripts from node project bin
set -x PATH node_modules/.bin $PATH

# autojump
if test -e /usr/local/share/autojump/autojump.fish
    source /usr/local/share/autojump/autojump.fish
end

# android
if test -d /Users/bob/Library/Android/sdk
    set -x ANDROID_HOME /Users/bob/Library/Android/sdk
    set -x PATH $PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
end

# iterm
if test -e "{$HOME}/.iterm2_shell_integration.fish"
    source "{$HOME}/.iterm2_shell_integration.fish"
end

# Google Cloud SDK
append_path /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

set -x PATH ~/bin $PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# set -x PATH $PATH $HOME/.rvm/bin
#
# test -s "$HOME/.rvm/scripts/rvm"
#   and bass source "$HOME/.rvm/scripts/rvm"

# Set up rbenv
if type -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
end

# Set up pyenv
set -x PATH $HOME/.pyenv/bin $PATH
if type -q pyenv
    status --is-interactive; and pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source
end

# https://starship.rs cross-shell prompt
starship init fish | source

set -x GPG_TTY (tty)

# Created by `pipx` on 2023-04-27 23:22:15
set PATH $PATH /home/bob/.local/bin

if test (which direnv)
    eval (direnv hook fish)
end

if type -q zoxide
    zoxide init fish | source
end

# fzf
if type -q fzf
    if type -q pbcopy
        set -x FZF_CTRL_R_OPTS (echo \
            "--preview 'echo {}' --preview-window up:3:hidden:wrap" \
            "--bind 'ctrl-/:toggle-preview'" \
            "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'" \
            "--color header:italic" \
            "--header 'Press CTRL-Y to copy command into clipboard'" \
        | string collect)
    else
        set -x FZF_CTRL_R_OPTS (echo \
            "--preview 'echo {}' --preview-window up:3:hidden:wrap" \
            "--bind 'ctrl-/:toggle-preview'" \
        )
    end

    if type -q exa
        set FZF_ALT_C_OPTS "--preview 'exa --tree --color=always {}'"
    else if type -q tree
        set FZF_ALT_C_OPTS "--preview 'tree -C {}'"
    end

    if type -q bat
        set -x FZF_CTRL_T_OPTS (echo \
            "--preview 'bat -n --color=always {}'" \
            # "--bind 'ctrl-/:change-preview-window(down|hidden|)'" \
        )
    end

    if type -q fd
        set -x FZF_DEFAULT_COMMAND 'fd --type f'
    end
end

# pnpm
set -gx PNPM_HOME "/Users/bob/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end