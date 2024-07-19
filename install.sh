#!/usr/bin/env bash
#echo "installing zsh4humans..."
#
#if command -v curl >/dev/null 2>&1; then
#	sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
#else
#	sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
#fi

for file in .zshrc .gitconfig .tmux.conf .vimrc; do
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
else
	echo "can't handle OSTYPE $OSTYPE"
fi

echo "installing vundle..."
rm -r ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

exec zsh
echo "you may want to reboot to change your login shell"
