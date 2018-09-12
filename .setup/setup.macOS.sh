#!/bin/bash -eu
# Setup macOS preferences

function __setup_macos_preferences() {
  # --------------------------------
  # Terminal.app
  defaults write com.apple.terminal 'Default Window Settings' -string 'Pro'

  # Trackpad
  # Enable clicking
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # Mission Control
  defaults write com.apple.dock mru-spaces -bool false

  # Hotcorners
  # Top-Left
  defaults write com.apple.dock wvous-tl-corner -int 6
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Top-Right
  defaults write com.apple.dock wvous-tr-corner -int 6
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Bottom-Left
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0
  # Bottom-Right
  defaults write com.apple.dock wvous-br-corner -int 5
  defaults write com.apple.dock wvous-br-modifier -int 0

  # Dock
  # Disable automatically hide
  defaults write com.apple.dock autohide -bool false
  # Remove all icons
  defaults write com.apple.dock persistent-apps -array
  # Icon size: 16 - 128
  defaults write com.apple.dock tilesize -int 16
  # Enable magnification
  defaults write com.apple.dock magnification -bool true
  killall Dock
}
