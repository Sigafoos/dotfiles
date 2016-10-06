# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source things I don't want to put on github
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

# User specific aliases and functions
alias ll='ls -l'
alias lf='ls -AF'
alias ga='git add'
alias gc='git commit'
alias gst='git status'
alias gp='git push'
alias gl="git log -n 800 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %an' --abbrev-commit --date=relative"
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set editing-mode vi'
export EDITOR=vim
alias ci=vi
