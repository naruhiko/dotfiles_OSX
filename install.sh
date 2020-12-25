#!/bin/bash

set -ue
cd

echo -e "\n
             .__  .__    ____   ____.___   _____    
  ____  __ __|  | |  |   \   \ /   /|   | /     \   
 /    \|  |  \  | |  |    \   Y   / |   |/  \ /  \  
|   |  \  |  /  |_|  |__   \     /  |   /    Y    \ 
|___|  /____/|____/____/    \___/   |___\____|__  / 
     \/                                         \/  
                                                    
                 ver 2020.12                        
               Naruhiko Nagata
               \n"

echo " ------------ Homebrew ------------"
read -p "Install Homebrew ? (y/n)" Answer < /dev/tty
case ${Answer} in
 y|Y)
    if [[ -d /home/linuxbrew ]]
    then
      echo "Already exist"
    else
      echo "Start Install Homebrew..."
      apt install build-essential curl file
      git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
      mkdir /home/linuxbrew/.linuxbrew/bin
      ln -sf /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      echo "Homebrew Installed" 
    fi 
    ;;
  n|N|*)
    echo "Skipped" ;;
esac

echo "---------- Japanese env. ----------"
apt install -y locales
apt install language-pack-ja-base language-pack-ja ibus-mozc
#echo 'export LANG="ja_JP.UTF-8"' >> ~/.bashrc
#echo 'export LANGUAGE="ja_JP:ja"' >> ~/.bashrc

echo "------------ zsh ------------"
#read -p "Change the Shell into zsh ? (y/n)" Answer < /dev/tty
#case ${Answer} in
#  y|Y)
    if [ -d /home/linuxbrew/.linuxbrew/bin/zsh ] || [ -d /usr/bin/zsh ]
    then
      echo "Already exist"
    else
      apt install zsh
      echo '/usr/bin/zsh' >> /etc/shells 
    fi
    chsh -s /usr/bin/zsh
    if [ ! -e ~/.zshrc ]
    then
      touch ~/.zshrc
    FILE="${HOME}/.bash_profile"
        if [[ -e ${FILE} ]]; then
          source ${FILE} >> ~/.zshrc
        elif [[ ! -e ${FILE} ]]; then
          touch ${FILE}
        fi
    fi
    source ~/.zshrc
#    ;;
#  n|N)
#    echo "Skipped" ;;
#esac

echo "---------- nvim & tmux ----------"
echo "processing..."
apt install build-essential curl file fuse
if [[ -d .config ]]
then
  echo "Already exist config file"
else
  mkdir .config
  cd .config
  mkdir nvim
fi
cd
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract

apt install git automake bison build-essential pkg-config libevent-dev libncurses5-dev
if [ ! -e /usr/local/bin/tmux ]
then
  cd /usr/local/src/
  git clone https://github.com/tmux/tmux
  cd ./tmux/
  ./autogen.sh
  ./configure --prefix=/usr/local
  make
  make install
  cd
fi
apt install python3 python3-pip nodejs npm

echo "---------- dein ----------"
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.config/nvim/dein
echo "finished"

echo "---------- zprezto ----------"
echo "processing..."
if [[ -d /root/.zprezto ]]
then
  echo "Skipped cloning zpezto"
else
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
echo "finished"

echo "---------- nvim initializing ----------"
mv ~/squashfs-root /usr/local/bin/nvim
echo 'alias nvim="/usr/local/bin/nvim/AppRun"' >> ~/.zshrc
rm -f installer.sh nvim.appimage
npm install -g n
n latest
pip3 install pynvim


echo "---------- cloning mods. ----------"
cp ~/dotfiles_linux/.config/nvim/dein.toml ~/.config/nvim/dein.toml
cp ~/dotfiles_linux/.config/nvim/init.vim ~/.config/nvim/init.vim
cp ~/dotfiles_linux/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
cp ~/dotfiles_linux/.tmux.conf ~/.tmux.conf
cp ~/dotfiles_linux/.zpreztorc ~/.zpreztorc
cp ~/dotfiles_linux/.zprofile ~/.zprofile
cp ~/dotfiles_linux/.zshenv ~/.zshenv
cp ~/dotfiles_linux/.zshrc ~/.zshrc
ln -sf ~/dotfiles_linux/.config/nvim/dein.toml ~/.config/nvim/dein.toml
ln -sf ~/dotfiles_linux/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles_linux/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -sf ~/dotfiles_linux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles_linux/.zpreztorc ~/.zpreztorc
ln -sf ~/dotfiles_linux/.zprofile ~/.zprofile
ln -sf ~/dotfiles_linux/.zshenv ~/.zshenv
ln -sf ~/dotfiles_linux/.zshrc ~/.zshrc
echo "FINISHED!"
/usr/bin/zsh
