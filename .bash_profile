[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
__git_complete g __git_main

if [ -f $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi
