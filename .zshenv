# Minimal zsh environment file (migrated off zsh4humans).
# Interactive shell configuration lives in ~/.zshrc.

# Stamp shell start time (paired with the slow-startup logger at the end of
# ~/.zshrc). This is the earliest point we run, so it captures everything.
zmodload zsh/datetime 2>/dev/null
typeset -gF _shell_start_time=${EPOCHREALTIME:-0}

# Startup checkpoints. Each phase appends to a per-PID file; a shell that
# finishes cleanly deletes it (end of ~/.zshrc). So if a shell hangs or dies
# mid-startup — before reaching the logger at the end — its file is left behind
# and its LAST line shows exactly which phase it died in.
typeset -g _ckpt_file=$HOME/.zsh-startup-phase/$$
_ckpt() {
  [[ -d $HOME/.zsh-startup-phase ]] || mkdir -p $HOME/.zsh-startup-phase 2>/dev/null
  print -r -- "$(strftime '%T.%3.' ${EPOCHREALTIME:-0} 2>/dev/null) $1" >> $_ckpt_file 2>/dev/null
}
_ckpt "zshenv: start (tmux=${TMUX:+y} pwd=$PWD)"

# Keep ~/.zshrc as the single source of truth: don't read the system-wide
# /etc/zprofile and /etc/zshrc. This matches the prior z4h behavior, so PATH
# and history are built entirely from ~/.zshrc rather than by macOS defaults.
setopt no_global_rcs

umask o-w

# Datadog API credentials, loaded from the macOS Keychain so they're available
# to non-interactive shells too (e.g. Claude Code's Bash tool), not just the
# interactive shell. Stash them once with:
#   security add-generic-password -a "$USER" -s DD_API_KEY -w "$DD_API_KEY" -U
#   security add-generic-password -a "$USER" -s DD_APP_KEY -w "$DD_APP_KEY" -U
# The ${VAR:-...} guard only hits the Keychain when the value isn't already in
# the environment. Child processes inherit the exports, so the lookup runs at
# most once per process tree instead of on every subshell (nvim spawns many).
_ckpt "zshenv: keychain DD_API_KEY"
export DD_API_KEY="${DD_API_KEY:-$(security find-generic-password -a "$USER" -s DD_API_KEY -w 2>/dev/null)}"
_ckpt "zshenv: keychain DD_APP_KEY"
export DD_APP_KEY="${DD_APP_KEY:-$(security find-generic-password -a "$USER" -s DD_APP_KEY -w 2>/dev/null)}"
_ckpt "zshenv: done"
