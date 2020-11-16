## Prerequisites

Install Vim and Tmux:
You also need to install the latest tmux (or any version above `2.9`).

```sh
sudo apt install vim-gtk3
sudo update-alternatives --config vim

git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install # or sudo checkinstall
```
## Installation

To get set up with dotfiles:

```sh
git clone git@github.com:marvinjason/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## Uninstallation
To remove the configs set up by dotfiles:
```sh
cd ~/.dotfiles
./uninstall
```

**Note**: This will remove configurations set up by dotfiles including installed binaries.
