#!/bin/bash
############################
# This script installs zsh + oh-my-zsh and creates symlinks from the home directory to any desired dotfiles in ~/dotfiles.
# It's based on https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh 
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="screenrc vimrc zshrc oh-my-zsh gitconfig"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    # file/folder exists and is NOT a symlink
    if [ -e ~/.$file -a ! -L ~/.$file ]; then
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv ~/.$file ~/dotfiles_old/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

function install_zsh {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        if type git >/dev/null 2>&1 ; then 
            git clone http://github.com/smilix/oh-my-zsh.git
        else  
            echo "This script needs git to install oh-my-zsh."
        fi
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
		if type chsh >/dev/null 2>&1 ; then 
			chsh -s $(which zsh)
		else 
			echo "chsh doesn't exist. You have to set as your default sehll by hand"
		fi
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    else 
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh
