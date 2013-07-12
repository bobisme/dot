# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
DEFAULT_USER="bob"
# PROMPT="$PROMPT
# %{%F{red}%}» %{%F{white}%}"
PROMPT='%{$fg[grey]%}[ %{$fg[blue]%}%n%{$fg[grey]%}@%{$fg[red]%}%m%{$fg[grey]%}: %{$fg_bold[green]%}${PWD/#$HOME/~}%{$fg[grey]%} ]%{$reset_color%}
%{$fg_bold[red]%}» %{$reset_color%}'

# VIRTUALENV
export WORKON_HOME=$HOME/envs
export PROJECT_HOME=$HOME/src
source /usr/local/bin/virtualenvwrapper.sh

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/bin

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
