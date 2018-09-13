#!/bin/bash -eu

readonly LOCAL_TMPDIR="${TMPDIR}/$0"
readonly DOTFILES_GIT_URL='git@github.com:mazgi/.dotfiles.git'
readonly USER_DOTFILES_DIR="${HOME}/.dotfiles"
readonly USER_BIN_DIR="${HOME}/bin"

readonly PACKER_VERSION='1.2.5'

# --------------------------------
# Clean up function
function cleanup() {
  local ret=$?
  trap EXIT HUP INT QUIT TERM

  # Remove TMPDIR
  rm -rf ${LOCAL_TMPDIR}
  # Reset sudo password timeout
  sudo rm -f /etc/sudoers.d/disable_timestamp_timeout

  exit $ret
}
trap cleanup EXIT HUP INT QUIT TERM

# --------------------------------
# Makes the sudo password not expire
sudo sh -c "echo 'Defaults timestamp_timeout=-1' > /etc/sudoers.d/disable_timestamp_timeout"

# --------------------------------
# Clone this repository
if [[ -d ~/.dotfiles ]] ; then
  (cd ${USER_DOTFILES_DIR} && git pull --ff-only origin master && git submodule update --init --recursive)
else
  git clone --recurse-submodules ${DOTFILES_GIT_URL} ${USER_DOTFILES_DIR}
fi

# --------------------------------
# Setup macOS preferences
if [[ 'Darwin' == $(uname -s) ]]; then
  source ${USER_DOTFILES_DIR}/.setup/setup.macOS.sh
  __setup_macos_preferences
fi

# --------------------------------
# Install Homebrew and packages
if [[ 'Darwin' == $(uname -s) ]]; then
  if [[ ! $(which brew) ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi
(cd ${USER_DOTFILES_DIR} && brew bundle)

# --------------------------------
# Setup zsh
if [[ ! -d ~/.zplug ]] ; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# --------------------------------
# Download other tools
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
