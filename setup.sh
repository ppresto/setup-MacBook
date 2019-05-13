#!/usr/bin/env bash

echo "Setting up ~/.bash_profile...";
touch ~/.bash_profile;

osascript -e 'Set desktop picture "/Library/Desktop Pictures/Color Burst 2.jpg"';
#osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Shapes.jpg"';

echo "Showing all files, because you'll need that.";
defaults write com.apple.finder AppleShowAllFiles YES;
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;

echo "Removing junk icons from the dock.";
defaults write com.apple.dock persistent-apps -array;

echo "Dock tile size set to 36.";
defaults write com.apple.dock tilesize -int 36;

echo "Dock set to auto-hide.";
defaults write com.apple.dock autohide -bool true;

echo "Removing dock show delay.";
defaults write com.apple.dock autohide-delay -float 0;
defaults write com.apple.dock autohide-time-modifier -float 0;

echo "Killing dock and finder so they'll restart."
killall Dock 2>/dev/null;
killall Finder 2>/dev/null;

################################################################################
# Install homebrew and git
################################################################################
function install_package_managers(){
	#install or update homebrew
	which -s brew
	if [[ $? != 0 ]] ; then
	    # Install Homebrew
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
	else
	    brew update
	fi

	#install or update git
	if brew list -1 | grep -q "^git\$"; then
		brew upgrade git
	else
		brew install git
	fi
}

################################################################################
# Create an SSH key for GitHub
################################################################################
function create_github_ssh(){
	#Check if github SSH needs to be setup
	pbcopy < ~/.ssh/id_rsa.pub
	if [ $? -eq 1 ]
	then

		#use an empty paraphrase to silently create an key pair
		echo -e  'y\n'|ssh-keygen -q -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_rsa
		pbcopy < ~/.ssh/id_rsa.pub

		# GitHub.com
		echo ""
		echo "-------------------------------------------------------------------------------"
		echo ""
		echo "Your SSH key is created and copied to the clipboard."
		echo "Go to Github Keys and create a 'New SSH key' with the contents of the clipboard."
		echo ""
		echo "-------------------------------------------------------------------------------"
		echo ""
		read -n 1 -s -p "Press any key to open GitHub SSH Key Settings"
		echo ""
		echo ""
		open "https://github.com/settings/keys"
		echo ""
		echo ""
		read -n 1 -s -p "SSH Key created on GitHub? Press any key to continue"
	fi
}

echo "All done!"


#brew install \
#  caskroom/cask/brew-cask \
#  git \
#  python \
#  wget;
#
#brew tap caskroom/versions;
#echo "Using brew cask to install dropbox, firefox, chrome, java, sublime, vagrant & manager, " \
#  "virtualbox, webstorm, intellij-idea, atom, and iterm2.";
#brew cask install \
#  google-chrome \
#  java \
#  virtualbox \
#  atom \
#  iterm2;
#
