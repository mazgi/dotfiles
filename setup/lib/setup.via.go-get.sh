#!/bin/bash -eu

export GOPATH="${HOME}/.go"
mkdir -p $GOPATH/bin
mkdir -p $GOPATH/src

function __setup_via_go_get() {
  local pkgs=(
  "github.com/github/hub"
  "github.com/direnv/direnv"
  "github.com/motemen/ghq"
  )

  for pkg in ${pkgs[@]}; do
    go get -u ${pkg}
  done
}
