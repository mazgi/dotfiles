#!/bin/bash -eu

function __setup_install_zsh_completions() {
  # Hub
  curl -o $HOME/.zsh/completions/_hub -L 'https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion'
}
