# Minimal zsh environment file (migrated off zsh4humans).
# Interactive shell configuration lives in ~/.zshrc.

# Keep ~/.zshrc as the single source of truth: don't read the system-wide
# /etc/zprofile and /etc/zshrc. This matches the prior z4h behavior, so PATH
# and history are built entirely from ~/.zshrc rather than by macOS defaults.
setopt no_global_rcs

umask o-w
