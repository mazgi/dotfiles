#!/bin/bash -eu
# Setup macOS preferences

function __setup_macos() {
  # --------------------------------
  # iTunes.app
  defaults write com.apple.iTunesHelper ignore-devices 1

  # --------------------------------
  # Terminal.app
  /usr/libexec/PlistBuddy -c 'Set "Startup Window Settings" "Pro"' ~/Library/Preferences/com.apple.Terminal.plist
  /usr/libexec/PlistBuddy -c 'Set "Default Window Settings" "Pro"' ~/Library/Preferences/com.apple.Terminal.plist
  #/usr/libexec/PlistBuddy -c 'Add "Window Settings:Pro:Bell" bool false' ~/Library/Preferences/com.apple.Terminal.plist
  #/usr/libexec/PlistBuddy -c 'Set "Window Settings:Pro:Bell" false' ~/Library/Preferences/com.apple.Terminal.plist
  #/usr/libexec/PlistBuddy -c 'Add "Window Settings:Pro:VisualBellOnlyWhenMuted" bool false' ~/Library/Preferences/com.apple.Terminal.plist
  #/usr/libexec/PlistBuddy -c 'Set "Window Settings:Pro:VisualBellOnlyWhenMuted" false' ~/Library/Preferences/com.apple.Terminal.plist
  /usr/libexec/PlistBuddy -c 'Set "Window Settings:Pro:shellExitAction" 1' ~/Library/Preferences/com.apple.Terminal.plist

  # --------------------------------
  # Finder & File
  # Avoid creating `.DS_Store` file on network strages.
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # --------------------------------
  # Energy Saver
  # on Battery
  sudo pmset -b sleep 60
  sudo pmset -b displaysleep 60
  sudo pmset -b disksleep 60
  # on Power Adapter
  sudo pmset -c sleep 0
  sudo pmset -c displaysleep 0
  sudo pmset -b disksleep 0

  # --------------------------------
  # Language & Region
  # Set first day of week to Monday
  defaults write NSGlobalDomain AppleFirstWeekday -dict 'gregorian' 2
  defaults write NSGlobalDomain AppleLanguages -array 'en-JP' 'jp-JP'
  defaults write NSGlobalDomain AppleLocale -string 'en_JP'
  #defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'
  #defaults write NSGlobalDomain AppleTemperatureUnit -string 'Celsius'

  # keyboard
  #   - 1452-597: Apple Wireless Keyboard
  #   - 1452-631: Apple Internal Keyboard / Trackpad
  #   - 1452-615: Magic Keyboard
  for keyboard in '1452-597' '1452-631' '1452-615'
  do
    /usr/libexec/PlistBuddy -c "Delete com.apple.keyboard.modifiermapping.${keyboard}-0" ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist
    /usr/libexec/PlistBuddy -c "Add com.apple.keyboard.modifiermapping.${keyboard}-0 array" ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist
    /usr/libexec/PlistBuddy -c "Add com.apple.keyboard.modifiermapping.${keyboard}-0:0:HIDKeyboardModifierMappingSrc integer 30064771129" ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist
    /usr/libexec/PlistBuddy -c "Add com.apple.keyboard.modifiermapping.${keyboard}-0:0:HIDKeyboardModifierMappingDst integer 30064771300" ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist
  done

  # Trackpad
  # Enable clicking
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  /usr/libexec/PlistBuddy -c 'Set "com.apple.mouse.tapBehavior" 1' ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist

  # Mission Control
  defaults write com.apple.dock mru-spaces -bool false

  # Hotcorners
  # Possible values:
  #  0: no-op
  #  2: Mission Control (all windows)
  #  3: Show application windows
  #  4: Desktop
  #  5: Start screen saver
  #  6: Disable screen saver
  #  7: Dashboard
  # 10: Put display to sleep
  # 11: Launchpad
  # 12: Notification Center
  # Top-Left
  defaults write com.apple.dock wvous-tl-corner -int 6
  # Top-Right
  defaults write com.apple.dock wvous-tr-corner -int 6
  # Bottom-Left
  defaults write com.apple.dock wvous-bl-corner -int 5
  # Bottom-Right
  defaults write com.apple.dock wvous-br-corner -int 5

  # Menu Bar
  defaults write com.apple.menuextra.clock 'DateFormat' 'EEE MMM d  H:mm'
  defaults write com.apple.menuextra.battery 'ShowPercent' 'NO'

  # Dock
  # Disable automatically hide
  defaults write com.apple.dock autohide -bool false
  # Remove all icons
  defaults write com.apple.dock persistent-apps -array
  # Icon size: 16 - 128
  defaults write com.apple.dock tilesize -int 16
  # Enable magnification
  defaults write com.apple.dock magnification -bool true
  # Apply changes
  killall Dock
}
