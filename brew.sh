#!/bin/sh

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file $DOTFILES/Brewfile
