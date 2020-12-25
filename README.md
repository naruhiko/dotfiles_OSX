# dotfiles_linux
zsh(zprezto) + nvim + tmux
config files & installer for vanilla Ubuntu environment.

### components
- dotfiles
- installer
  - Homebrew(linuxbrew)
  - zsh
  - tmux
  - nvim
    - dein(dein.toml)
    - defx
    - onedark theme
    - denite
    - coc.nvim
    - airline
    - auto-pairs
  - zprezto


### How to install
#### Vanilla Ubuntu user
For vanilla environment, use installer to install files and apps.

Sometimes installer ask you what you would install.  

*Your older settings will be overwrited.*

```sh
cd
apt update && apt install git
git clone https://github.com/naruhiko/dotfiles_linux.git
bash dotfiles_linux/install.sh
```

#### Others
Use dotfiles as you like. 

You may copy the settings to your home directory, slink to your own settings.

(your older setting will be overwrited, you should backup your originals)

