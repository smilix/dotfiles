#!/bin/bash
############################
# This script installs zsh + oh-my-zsh and creates symlinks from the home directory to any desired dotfiles in ~/dotfiles.
# It's based on https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

HOME=~

DOTFILES=$HOME/dotfiles # dotfiles directory
OLD_CONFIGS=$HOME/dotfiles_old_configs # old dotfiles backup directory
CONFIGS=configs # config folder, must be INSIDE $DOTFILES

##########

function makeSymlinks {
  cd $DOTFILES

  # create dotfiles_old in homedir
  echo  "Creating $OLD_CONFIGS for backup of any existing dotfiles in ~ ..."
  mkdir -p $OLD_CONFIGS

  cd $DOTFILES/$CONFIGS
  for f in $(find . -type f); do
    echo ""
    echo "Config: $f"
    FILE_IN_HOME=$HOME/$f

    if [ -e $FILE_IN_HOME ]; then
      if [ ! -L $FILE_IN_HOME ]; then
        echo "Moving existing dotfile from $HOME to $OLD_CONFIGS"
        BACKUP_FOLDER=$OLD_CONFIGS/$(dirname $f)
        mkdir -p $BACKUP_FOLDER
        mv $FILE_IN_HOME $BACKUP_FOLDER/
      else
        echo "Symlink exists, skipping this entry."
        continue
      fi
    fi

    echo "Creating symlink to $f"
    FOLDER=$(dirname $FILE_IN_HOME)
    mkdir -p $FOLDER
    ln -s $DOTFILES/$CONFIGS/$f $FILE_IN_HOME
  done

  # one extra symlink
  if [ ! -e $HOME/.oh-my-zsh ]; then
    ln -s $DOTFILES/oh-my-zsh $HOME/.oh-my-zsh
  fi
}


function install_zsh {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
      # Clone my oh-my-zsh repository from GitHub only if it isn't already present
      if [[ ! -d $DOTFILES/oh-my-zsh/ ]]; then
          if type git >/dev/null 2>&1 ; then
              git clone http://github.com/smilix/oh-my-zsh.git
              cd oh-my-zsh
              git submodule init
              git submodule update
              cd ..
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
      echo "Please install zsh, then re-run this script!"

      if [[ $platform == 'Linux' ]]; then
          echo "Run as root: apt-get install zsh"
      fi
  fi
}

install_zsh
makeSymlinks
