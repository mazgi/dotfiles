#!/bin/bash -eu

if [[ ! -d ~/.zplug ]] ; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
