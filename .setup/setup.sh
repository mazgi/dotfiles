#!/bin/bash -eu

readonly LOCAL_TMPDIR="${TMPDIR}/$0"
readonly DOTFILES_GIT_URL='git@github.com:mazgi/.dotfiles.git'
readonly USER_DOTFILES_DIR="${HOME}/.dotfiles"
#readonly USER_BIN_DIR="${HOME}/bin"

readonly PACKER_VERSION='1.2.5'

## --------------------------------
## ToDo: Check: exist ssh private key
#if [[ ! -d ~/.ssh ]] || [[ -z $(ls -A ~/.ssh/) ]]; then
#  # ToDo: prompt
#  ssh-keygen
#fi

# --------------------------------
# ToDo: check icloud sign in

# --------------------------------
# Clean up function
function cleanup() {
  local ret=$?
  trap EXIT HUP INT QUIT TERM

  printf "Clean up ...\n"

  # Remove TMPDIR
  rm -rf ${LOCAL_TMPDIR}

  printf "Set up complete! please restart your computer.\n"
  # Reset sudo password timeout ( && reboot )
  sudo rm -f /etc/sudoers.d/disable_timestamp_timeout
  # ToDo: show prompt
  #sudo 'rm -f /etc/sudoers.d/disable_timestamp_timeout; shutdown -r now'

  exit $ret
}
trap cleanup EXIT HUP INT QUIT TERM

# --------------------------------
# Makes the sudo password not expire
sudo sh -c "echo 'Defaults timestamp_timeout=-1' > /etc/sudoers.d/disable_timestamp_timeout"

# --------------------------------
# Clone this repository
if [[ -d ${USER_DOTFILES_DIR} ]] ; then
  (cd ${USER_DOTFILES_DIR} && git pull --ff-only origin master && git submodule update --init --recursive)
else
  git clone --recurse-submodules ${DOTFILES_GIT_URL} ${USER_DOTFILES_DIR}
fi

# --------------------------------
# Setup macOS preferences
if [[ 'Darwin' == $(uname -s) ]]; then
  # Install Homebrew and packages
  if [[ 'Darwin' == $(uname -s) ]]; then
    if [[ ! $(which brew) ]]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
  fi
  brew bundle --global
  source ${USER_DOTFILES_DIR}/.setup/lib/setup.macOS.sh
  __setup_macos
fi

# --------------------------------
# Install packages via `go get`
source ${USER_DOTFILES_DIR}/.setup/lib/setup.via.go-get.sh
__setup_via_go_get

# --------------------------------
# Setup zsh
if [[ ! -d ~/.zplug ]] ; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# --------------------------------
# Download other tools
#mkdir -p ${USER_BIN_DIR}
mkdir -p ${LOCAL_TMPDIR}

## Install Packer
## ToDo: update version
#if [[ 'Darwin' == $(uname -s) ]]; then
#  curl -L -o "${LOCAL_TMPDIR}/packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_darwin_amd64.zip"
#else
#  curl -L -o "${LOCAL_TMPDIR}/packer.zip" "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
#fi
#unzip "${LOCAL_TMPDIR}/packer.zip" -d "${USER_BIN_DIR}"
