#!/bin/bash -eu

export GOPATH="${HOME}/.go"
mkdir -p $GOPATH/bin
(
cd $GOPATH;
ln -s ~/Creations src
)

function __setup_via_go_get() {
  local pkgs=(
  "github.com/github/hub"
  "github.com/direnv/direnv"
  )

  for pkg in ${pkgs[@]}; do
    go get -u ${pkg}
  done
}
