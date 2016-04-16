# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="agnoster"
ZSH_THEME="avit"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(\
    autojump\
    bower\
    brew\
    cake\
    coffee\
    docker\
    encode64\
    gitfast\
    jsontools\
    node\
    nyan\
    pip\
    python\
    redis-cli\
    sudo\
    supervisor\
    tmux\
    urltools\
    # vi-mode\
    # virtualenvwrapper\
)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
DEFAULT_USER="bob"
# PROMPT="$PROMPT
# %{%F{red}%}» %{%F{white}%}"
# PROMPT=$'%{$fg[grey]%}[%{$fg[blue]%}%n%{$fg[grey]%}@%{$fg[red]%}%m%{$fg[grey]%}:%{$fg_bold[green]%}${PWD/#$HOME/~}%{$fg[grey]%}]%{$reset_color%}
# %{$fg_bold[red]%}» %{$reset_color%}'
# PROMPT=$'\e[90m[%{$fg[blue]%}%n\e[90m@%{$fg[red]%}%m\e[90m:%{$fg_bold[green]%}${PWD/#$HOME/~}\e[90m]%{$reset_color%}
# %{$fg_bold[red]%}» %{$reset_color%}'
# PROMPT=$PROMPT$'
PROMPT=$'$(_user_host)${_current_dir} $(git_prompt_info)
%{$fg_bold[red]%}» %{$reset_color%}'
# RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'
RPROMPT=''
# if using vi-mode, I need this
bindkey '^R' history-incremental-search-backward

# VIRTUALENV
export WORKON_HOME=$HOME/envs
export PROJECT_HOME=$HOME/src
source /usr/local/bin/virtualenvwrapper.sh

# GO
export GOPATH=$HOME/src/gostuff
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
# NODE
export NODE_PATH=/usr/local/lib/node_modules
# HOME BIN
export PATH=$HOME/bin:$PATH

# FUNCTIONS
datauri () { echo "background-image: url(data:$1;base64,`base64 -i $2`);" }
doctomd () {
	textutil -convert html $1 -stdout | pandoc -f html -t markdown -o $2
}
dumpgitlog () {
	git log --reverse --since="$1" --pretty=format:"**%h %ad**: %s%d%n%n%b%n---%n" --date=short > ~/Desktop/gitlog-`date +%F`.md
}
gitpretty () {
	git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}
mkpy () { mkdir $1; touch $1/__init__.py }
zebra () {
	cat $1 | awk 'NR%2 == 1 {printf("\033[30m\033[47m%s\033[0m\n", $0); next}; 1'
}

# vi mode
# bindkey -v
# Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.8.3.app"
if [ -d "$GHC_DOT_APP" ]; then
    export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/bob/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

# source highlighting in less
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=" -R "

source /Users/bob/.iterm2_shell_integration.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.aliases

# node version manager
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
eval $(thefuck --alias)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

PATH=$PATH:node_modules/.bin  
