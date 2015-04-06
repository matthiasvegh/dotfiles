# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"
#ZSH_THEME="powerline"

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
DISABLE_UNTRACKED_FILES_DIRTY="false"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

plugins=(git screen extract zsh-syntax-highlighting colorize safe-paste history-substring-search autojump catimg command-not-found git-extras pip vagrant)
source $ZSH/oh-my-zsh.sh
alias ct=cleartool
export PATH=/proj/cudbdm/tools/internal/bin:/proj/madridcudb/cudb_sec/Design/clearstart_cudb:$PATH
export PATH=/home/emtyvgh/build/bin:/proj/cudbdm/tools/external/bin/SLED10:/proj/cudbdm/tools/internal/bin:/env/seki/bin:$HOME/usr/bin:/usr/atria/bin:$HOME/bin:$PATH
export LINKER=/app/gcc/4.7.2/LMWP3/bin/g++
export GCC_DIR=/app/gcc/4.8.1/LMWP3

function module() {
	eval `/app/modules/0/bin/modulecmd zsh "$@"`
}

alias l='ls -CF'

function mkcd() {
	mkdir "$@"
	cd "$@"
}

# let other programs know that we are using bash
export SHELL=/bin/bash

# Customize to your needs...
export PATH=$PATH
export PATH=/proj/cudbdm/tools/external/tup:$PATH
module load gridengine
bindkey -s "\e[33~" ""
alias tmux='TERM=screen-256color-bce LANG=en_US.UTF-8 tmux'

#dirstack
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1]
fi

chpwd() {
	print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries
setopt pushdignoredups

# This reverts the +/- operators.
setopt pushdminus

PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
eval `dircolors ~/sandbox/dircolors-solarized/dircolors.ansi-universal`
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
REPORTTIME=10

_CURRENTSIZE=`wc -l < $HISTFILE`
SAVEHIST=$(( $_CURRENTSIZE * 2))
_CURRENTSIZE=
HISTSIZE=$SAVEHIST

inform_tmux() {
	if [[ -n "$TMUX" ]]; then
		tmux setenv "$(tmux display -p 'TMUX_PWD_#D')" "$PWD"
		tmux refresh-client -S
	fi
}

export SHELL=`which zsh`

echo ""
fortune
echo ""

[ -e "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

precmd_functions+='inform_tmux'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
