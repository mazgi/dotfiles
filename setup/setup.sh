#!/bin/bash -eu

readonly USER_NAME="$(whoami)"
readonly DOTFILES_GIT_URL='https://github.com/mazgi/.dotfiles.git'
readonly USER_DOTFILES_DIR="${HOME}/.dotfiles"

# --------------------------------
# Clean up function
function cleanup() {
  local ret=$?
  trap EXIT HUP INT QUIT TERM

  printf "Clean up ...\n"
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
# Create my working directory
mkdir -p ~/Creations/

# --------------------------------
# Create symlinks into ~/
(
source ${USER_DOTFILES_DIR}/setup/lib/setup.symlinks.into.home.sh
__setup_symlinks_into_home
)

# --------------------------------
# Setup macOS preferences
if [[ 'Darwin' == $(uname -s) ]]; then
  # Install the command line developer tools
  if ! $(xcode-select --print-path | grep --quiet 'CommandLineTools' ); then
    xcode-select --install
  fi

  # Install Homebrew and packages
  if [[ ! $(which brew) ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew bundle --global
  sudo xcodebuild -license accept
  (
  source ${USER_DOTFILES_DIR}/setup/lib/setup.macOS.sh
  __setup_macos
  )
fi

# --------------------------------
# Install packages via `go get`
(
source ${USER_DOTFILES_DIR}/setup/lib/setup.via.go-get.sh
__setup_via_go_get
)

# --------------------------------
# Setup zsh
(
source ${USER_DOTFILES_DIR}/setup/lib/setup.install.zsh-completions.sh
__setup_install_zsh_completions
)

# --------------------------------
# Install zplug
if [[ ! -d ~/.zplug ]] ; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# --------------------------------
# Set login shell
sudo chsh -s /bin/zsh $USER_NAME
