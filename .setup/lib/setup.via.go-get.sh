#!/bin/bash -eu

function __setup_via_go_get() {
  local pkgs=(
  "github.com/github/hub"
  "github.com/direnv/direnv"
  )

  for pkg in ${pkgs[@]}; do
    go get -u ${pkg}
  done
}
