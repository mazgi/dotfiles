#!/bin/bash -eu

function __setup_symlinks_into_home() {
  local excludes=(
  ".git"
  ".gitattributes"
  ".gitignore"
  ".gitmodules"
  "LICENSE"
  "README.md"
  "setup"
  )

  cd $HOME
  for file in $(\ls -1A $USER_DOTFILES_DIR); do
    local is_exclude=false
    for exclude in ${excludes[@]}; do
      if [[ $file = $exclude ]]; then
        is_exclude=true
        break
      fi
    done

    if [[ $is_exclude != true ]]; then
      if [[ -e $file ]] && [[ ! -L $file ]]; then
        mv -fv $file __RENAMED_BY_SETUP__.${file/./}
      fi
      ln -sfnv $USER_DOTFILES_DIR/$file ${file/.__AVOID_GIT_CONFLICT__/}
    fi
  done
}
