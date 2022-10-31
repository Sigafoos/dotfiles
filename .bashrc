# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source things I don't want to put on github
if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

if [ -f ~/.shell_prompt.sh ]; then
	source ~/.shell_prompt.sh
fi

# work with yubikey, if it's set up
export GPG_TTY=$(tty)
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

# User specific aliases and functions
alias ll='ls -l'
alias lf='ls -AF'
alias gl="git log -n 800 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %an' --abbrev-commit --date=relative"
alias g='git'
alias d='date --rfc-3339 date -d'
alias t='todo -t'
alias jqcsv='jq -r '"'(map(keys) | add | unique) as "'$cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv'"'"

bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set editing-mode vi'
export EDITOR=vim
alias ci=vi

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$HOME/node_modules/.bin
export DOCKER_SCAN_SUGGEST=false

eval "$(direnv hook bash)"
eval "$(bw completion --shell zsh); compdef _bw bw;"
alias bwu='export BW_SESSION="$(bw unlock --raw)"'
