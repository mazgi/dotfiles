#!/bin/bash -eu

readonly USER_BIN_DIR="${HOME}/bin"
readonly LOCAL_TMPDIR="${TMPDIR}/$0"
readonly PACKER_VERSION='1.2.5'

if [[ ! -d ~/.zplug ]] ; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# --------------------------------
# Download tools
mkdir -p ${USER_BIN_DIR}
mkdir -p ${LOCAL_TMPDIR}

# Install Packer
# ToDo: update version
if [[ 'Darwin' == $(uname -s) ]]; then
  curl -L -o "${LOCAL_TMPDIR}/packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_darwin_amd64.zip"
else
  curl -L -o "${LOCAL_TMPDIR}/packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
fi
unzip "${LOCAL_TMPDIR}/packer.zip" -d "${USER_BIN_DIR}"

rm -rf ${LOCAL_TMPDIR}
