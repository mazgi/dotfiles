#!/bin/bash -eu

function __setup_via_cargo() {
  local pkgs=(
  "bat"
  "starship"
  )

  for pkg in ${pkgs[@]}; do
    cargo install ${pkg}
  done
}
