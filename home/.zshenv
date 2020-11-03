# Lang
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
# Runtimes
export EDITOR=vim
export GOPATH="${HOME}/.go"
if [[ -d ${HOME}/.cargo/bin ]]; then
  export PATH="${PATH}:${HOME}/.cargo/bin"
fi
if (( ${+GOPATH} )); then
  if [[ -d ${GOPATH}/bin ]]; then
    export PATH="${PATH}:${GOPATH}/bin"
  fi
fi
