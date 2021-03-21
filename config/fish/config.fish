# bobthefish theme
set -g theme_date_format "+%Y-%m-%d %H:%M:%S"
set -g theme_date_timezone America/New_York

function prepend_path
  set -l check_path "yes"
  for arg in $argv
    if [ $arg = "--check-path=no" ]
      set -l check_path "no"
    else
      set -l path $arg
    end
  end

  if begin [ $check_path = "no" ]; or test -d $path; end
    set -x PATH $path $PATH
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
prepend_path ~/bin

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
append_path $HOME/.pyenv/bin
if type -q pyenv
  status --is-interactive; and pyenv init - | source
  status --is-interactive; and pyenv virtualenv-init - | source
end

# https://starship.rs cross-shell prompt
starship init fish | source

set -x GPG_TTY (tty)
