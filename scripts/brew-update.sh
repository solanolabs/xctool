#!/bin/bash
# Ensure necessary packages are installed (runs on osx worker)
brew tap caskroom/cask
brew tap caskroom/versions
brew update
brew install brew-cask
brew cask install java7
brew install ant
