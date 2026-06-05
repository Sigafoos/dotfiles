#!/usr/bin/env bash
echo "installing antidote (zsh plugin manager)..."
if [ ! -e "$HOME/.antidote/antidote.zsh" ]; then
	git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi
# Plugins themselves are cloned by antidote on first shell launch, driven by
# ~/.zsh_plugins.txt and compiled to ~/.zsh_plugins.zsh.

for file in .zshenv .zshrc .zsh_plugins.txt .p10k.zsh .gitconfig .tmux.conf .vimrc; do
	echo "symlinking $file..."
	rm $HOME/$file > /dev/null 2>&1
	ln -s $HOME/dotfiles/$file $HOME/$file
done

echo "symlinking init.vim..."
mkdir -p $HOME/.config/nvim
rm $HOME/.config/init.vim > /dev/null 2>&1
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim

if [ $OSTYPE == "lbrbinux-gnu" ]; then
	echo "installing packages..."
	sudo apt install -y tmux
	sudo apt install -y ack-grep
	sudo apt install -y fd-find
	sudo apt install -y neovim
elif [[ $OSTYPE == darwin* ]]; then
	if [[ ! -x $(command -v brew) ]]; then
		echo "installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo "found Homebrew"
	fi
	brew install tmux ack-grep fd-find neovim
else
	echo "can't handle OSTYPE $OSTYPE"
fi

echo "installing vundle..."
rm -r ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

exec zsh
echo "you may want to reboot to change your login shell"
