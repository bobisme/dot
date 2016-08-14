# Path to Oh My Fish install.
set -gx OMF_PATH /Users/bob/.local/share/omf

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG /Users/bob/.config/omf

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

# fundle
fundle plugin 'edc/bass'
fundle init

# home bin
set -x PATH ~/bin $PATH

# pip should only run if there is a virtualenv currently activated
set -x PIP_REQUIRE_VIRTUALENV true
# virtualfish
set -x VIRTUALFISH_HOME ~/envs
set -x PROJECT_HOME ~/src
eval (python -m virtualfish projects)

# gopath
set -x GOPATH ~/go
set -x PATH $GOPATH/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x RUST_SRC_PATH ~/repos/rust/src

# nvm on mac from homebrew
function nvm
    bass source /usr/local/opt/nvm/nvm.sh ';' nvm $argv
end

# base16 shell colors
# eval sh $HOME/.config/base16-shell/base16-monokai.dark.sh

# autojump
[ -f /usr/local/share/autojump/autojump.fish ]; and . /usr/local/share/autojump/autojump.fish

#android
set -x ANDROID_HOME /Users/bob/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
