#!/usr/bin/env bash
#
# Bootstrap script for setting up a new macOS machine
#
# bash <(curl -L <gist>)
#
# Based on https://gist.github.com/codeinthehole/26b37efa67041e1307db
#

echo "Starting bootstrapping"

# Install maxOS all available updates
echo "Updating OSX.  If this requires a restart, run the script again."
sudo softwareupdate -iva

# Install Xcode command line tools
echo "Installing Xcode Command Line Tools."
xcode-select --install

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install ripgrep
brew tap burntsushi/ripgrep https://github.com/BurntSushi/ripgrep.git
brew install ripgrep-bin

# Install GNU core utilities (those that come with OS X are outdated)
brew tap homebrew/dupes
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install new Bash and Zsh
brew install bash zsh

# Confirm zsh location
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

PACKAGES=(
    autoconf
    automake
    bat
    ctags
    curl
    exa
    fd
    git
    git-extras
    go
    hub
    jq
    jump
    keychain
    node
    python
    python3
    ripgrep
    ssh-copy-id
    terminal-notifier
    tmux
    vim
    wget
    xsv
    yarn
    fnm
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Installing cask..."
brew tap caskroom/cask

CASKS=(
    docker
    firefox
    flycut
    google-chrome
    hammerspoon
    iterm2
    macvim
    meld
    robo-3t
    slack
    spectacle
    sublime-text
    typora
    visual-studio-code
    vlc
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap homebrew/cask-fonts
FONTS=(
  font-anonymous-pro
  font-dejavu-sans-mono-for-powerline
  font-droid-sans-mono-for-powerline
  font-droidsansmono-nerd-font
  font-droidsansmono-nerd-font-mono
  font-fira-code
  font-inconsolata
  font-inconsolata-for-powerline
  font-liberation-mono-for-powerline
  font-liberationmono-nerd-font
  font-liberationmono-nerd-font-mono
  font-meslo-lg
  font-meslo-lg font-input
  font-nixie-one
  font-office-code-pro
  font-pt-mono
  font-raleway
  font-roboto
  font-source-code-pro
  font-source-code-pro-for-powerline
  font-source-sans-pro
  font-ubuntu
  font-ubuntu-mono-derivative-powerline
)
brew cask install ${FONTS[@]}

echo "Configuring macOS..."

# Set fast key repeat rate
#defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# item and terminal

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
