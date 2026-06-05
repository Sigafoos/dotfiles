# Personal Zsh configuration — plain zsh + antidote (migrated off zsh4humans).

# ─────────────────────────────────────────────────────────────────────────────
# Powerlevel10k instant prompt. Keep near the top; nothing above it should
# produce console output (otherwise instant prompt will warn).
# ─────────────────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Completion fpath additions — must come BEFORE compinit runs.
# ─────────────────────────────────────────────────────────────────────────────
fpath=(~/.zsh/completion $HOME/prepos/zsh-completions/src $fpath)

# ─────────────────────────────────────────────────────────────────────────────
# Antidote plugin manager. Auto-clones on first run. Uses static bundling:
# the plugin list (~/.zsh_plugins.txt) is compiled to ~/.zsh_plugins.zsh once,
# and only recompiled when the list changes — so normal startups just source a
# plain file. Bundle: powerlevel10k, fzf-tab, autosuggestions, syntax
# highlighting, history-substring-search, zsh-completions.
# ─────────────────────────────────────────────────────────────────────────────
ANTIDOTE_DIR=${ZDOTDIR:-$HOME}/.antidote
if [[ ! -e $ANTIDOTE_DIR/antidote.zsh ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_DIR
fi
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  source $ANTIDOTE_DIR/antidote.zsh
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh

# Initialize the completion system (after plugin fpaths are registered).
autoload -Uz compinit && compinit -i

# Load powerlevel10k prompt configuration.
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─────────────────────────────────────────────────────────────────────────────
# Shell options
# ─────────────────────────────────────────────────────────────────────────────
setopt glob_dots          # no special treatment for leading-dot file names
setopt no_auto_menu        # require an extra TAB press to open the completion menu
setopt auto_cd             # `foo/` with no command cds into it
setopt interactive_comments # allow # comments in interactive shells (pasting)
unsetopt beep              # no terminal bell on errors
export KEYTIMEOUT=1        # reduce lag when changing vi modes / multi-key binds

# History (z4h used to configure this; set it explicitly now).
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # record timestamps
setopt hist_expire_dups_first # trim duplicates first when HISTSIZE is exceeded
setopt hist_ignore_dups       # don't record an entry identical to the previous one
setopt hist_ignore_space      # don't record commands starting with a space
setopt hist_verify            # show, don't immediately run, history expansion
setopt share_history          # share history across concurrent sessions

# ─────────────────────────────────────────────────────────────────────────────
# Completion / plugin styles
# ─────────────────────────────────────────────────────────────────────────────
# fzf-tab: let it own the completion menu.
zstyle ':completion:*' menu no
# Use `<tab>` to keep descending into directories without leaving the fzf menu
# (replaces z4h's `tab:repeat` for fzf-complete / cd-down).
zstyle ':fzf-tab:*' continuous-trigger 'tab'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -A --color=always -- ${~realpath} 2>/dev/null || ls -A -- ${~realpath}'

# docker option stacking (from prior config)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# zsh-autosuggestions: Right-arrow accepts the whole suggestion (z4h had
# forward-char 'accept'; forward-char is an accept widget by default).

# history-substring-search: bind Up/Down to filtered history search.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# fzf key bindings: Ctrl-R (history), Ctrl-T (files), Alt-C (cd). We source
# ONLY key-bindings.zsh, not fzf's completion — fzf-tab owns Tab completion.
for _f in /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
          /usr/local/opt/fzf/shell/key-bindings.zsh \
          /usr/share/fzf/key-bindings.zsh \
          /usr/share/doc/fzf/examples/key-bindings.zsh; do
  [[ -r $_f ]] && { source $_f; break }
done
unset _f

# ─────────────────────────────────────────────────────────────────────────────
# Directory navigation widgets (replaces z4h-cd-up/down/back/forward).
#   Shift+Up    → cd ..
#   Shift+Down  → fzf-pick a descendant directory
#   Shift+Left  → back  in directory history (browser-style)
#   Shift+Right → forward in directory history
# ─────────────────────────────────────────────────────────────────────────────
autoload -Uz add-zsh-hook

typeset -ga _dirhist=("$PWD")   # visited directories
typeset -gi _dirhist_idx=1      # 1-based cursor into _dirhist
typeset -gi _dirhist_nav=0      # set while we move the cursor ourselves

# Record every cd that isn't one of our own back/forward jumps.
_dirhist_record() {
  (( _dirhist_nav )) && return
  [[ "${_dirhist[_dirhist_idx]}" == "$PWD" ]] && return
  _dirhist=("${_dirhist[@]:0:$_dirhist_idx}")   # drop any forward entries
  _dirhist+=("$PWD")
  _dirhist_idx=$#_dirhist
}
add-zsh-hook chpwd _dirhist_record

# Re-run precmd hooks, then redraw. Needed because we cd from inside a widget:
# `zle reset-prompt` only re-renders the prompt powerlevel10k already built in
# its last precmd, so the directory segment would otherwise stay stale until
# the next command. Running precmd_functions makes p10k recompute it.
_dirhist_redraw() {
  local f
  for f in $precmd_functions; do (( $+functions[$f] )) && $f; done
  zle reset-prompt
  zle -R
}

_cd-up() {
  builtin cd .. 2>/dev/null && _dirhist_redraw
}
_cd-back() {
  (( _dirhist_idx > 1 )) || return
  _dirhist_nav=1
  (( _dirhist_idx-- ))
  builtin cd -- "${_dirhist[_dirhist_idx]}" 2>/dev/null
  _dirhist_nav=0
  _dirhist_redraw
}
_cd-forward() {
  (( _dirhist_idx < $#_dirhist )) || return
  _dirhist_nav=1
  (( _dirhist_idx++ ))
  builtin cd -- "${_dirhist[_dirhist_idx]}" 2>/dev/null
  _dirhist_nav=0
  _dirhist_redraw
}
_cd-down() {
  # Pick a subdirectory with fzf. Enter cd's into the highlighted dir; Tab
  # descends into it and re-lists its children (keep Tabbing to go deeper).
  local base=$PWD listing out key sel
  while true; do
    if (( $+commands[fd] )); then
      listing=$(cd -- "$base" 2>/dev/null && fd --type d -d 1 --hidden --exclude .git --strip-cwd-prefix)
    else
      listing=$(cd -- "$base" 2>/dev/null && find . -mindepth 1 -maxdepth 1 -type d -not -name .git 2>/dev/null | sed 's|^\./||')
    fi
    [[ -n $listing ]] || break          # no subdirectories: accept current base
    out=$(print -r -- "$listing" | fzf --height=40% --reverse --expect=tab \
          --prompt="${base/#$HOME/~}/" \
          --preview "ls -A --color=always -- ${(q)base}/{} 2>/dev/null || ls -A -- ${(q)base}/{}") || return
    key=${out%%$'\n'*}                  # 'tab' if Tab was pressed, else empty (Enter)
    sel=${out#*$'\n'}
    [[ -n $sel ]] || return
    base=${base%/}/${sel%/}             # descend into the selection
    [[ $key == tab ]] || break          # Enter accepts; Tab keeps descending
  done
  builtin cd -- "$base" 2>/dev/null && _dirhist_redraw
}
zle -N _cd-up
zle -N _cd-down
zle -N _cd-back
zle -N _cd-forward

# Shift+Arrow escape sequences (xterm/iTerm2/WezTerm CSI 1;2 <letter>).
bindkey '^[[1;2A' _cd-up       # Shift+Up
bindkey '^[[1;2B' _cd-down     # Shift+Down
bindkey '^[[1;2D' _cd-back     # Shift+Left
bindkey '^[[1;2C' _cd-forward  # Shift+Right

# Undo / redo (z4h bound these to Ctrl+/ and Option+/).
bindkey '^_' undo
bindkey '^[/' redo

# ─────────────────────────────────────────────────────────────────────────────
# Autoloaded functions / completions
# ─────────────────────────────────────────────────────────────────────────────
autoload -Uz zmv

# mkdir + cd in one step.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# ─────────────────────────────────────────────────────────────────────────────
# direnv (z4h had this enabled). Hook in if installed.
# ─────────────────────────────────────────────────────────────────────────────
(( $+commands[direnv] )) && emulate zsh -c "$(direnv hook zsh)"

# ─────────────────────────────────────────────────────────────────────────────
# PATH / environment
# ─────────────────────────────────────────────────────────────────────────────
path=(~/bin $path)
export GPG_TTY=$TTY
export EDITOR=vim
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$HOME/node_modules/.bin:/opt/homebrew/Cellar:$HOME/.dotnet/tools:/opt/homebrew/bin

# Source additional local files if they exist.
[[ -r ~/.env.zsh ]] && source ~/.env.zsh

# ─────────────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────────────
alias tree='tree -a -I .git'
alias ls="${aliases[ls]:-ls} -A"
alias ll='ls -l'
alias lf='ls -AF'
alias g='git'
alias d='date --rfc-3339 date -d'
alias t='todo -t'
alias jqcsv='jq -r '"'(map(keys) | add | unique) as "'$cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv'"'"
alias acvpw='bw get password 122a6ffe-0f98-4176-aeb0-ab2700097746'
alias acvuatpw='bw get password 081b957a-3b47-45d3-b8d3-ab4d00e70d11'
alias ci=vi
alias vi=nvim
alias vim=nvim

# ─────────────────────────────────────────────────────────────────────────────
# Legacy / machine-specific
# ─────────────────────────────────────────────────────────────────────────────
# ha legacy
[[ -f $HOME/.bashrc.local ]] && source $HOME/.bashrc.local

# work with yubikey, if it's set up
export GPG_TTY=$(tty)
if [ -f "${HOME}/.gpg-agent-info" ]; then
	. "${HOME}/.gpg-agent-info"
	export GPG_AGENT_INFO
	export SSH_AUTH_SOCK
	export SSH_AGENT_PID
fi

# perl5 local::lib
PATH="/Users/dconley/perl5/bin${PATH:+:${PATH}}:/Applications/WezTerm.app/Contents/MacOS"; export PATH;
PERL5LIB="/Users/dconley/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/dconley/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/dconley/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/dconley/perl5"; export PERL_MM_OPT;

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export HOMEBREW_NO_AUTO_UPDATE=1

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Google Cloud SDK
if [ -f '/Users/dconley/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dconley/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/dconley/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dconley/google-cloud-sdk/completion.zsh.inc'; fi
