# bash-completion on homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  export PATH="${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}"
  eval "$(rbenv init -)"
fi

if [ -d ${HOME}/.scalaenv ]; then
  export PATH="${HOME}/.scalaenv/bin:${HOME}/.scalaenv/shims:${PATH}"
  eval "$(scalaenv init -)"
fi
if [ -d ${HOME}/.sbtenv ]; then
  export PATH="${HOME}/.sbtenv/bin:${HOME}/.sbtenv/shims:${PATH}"
  eval "$(sbtenv init -)"
  export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M"
fi
if [ -d ${HOME}/.playenv ]; then
  export PATH="${HOME}/.playenv/bin:${HOME}/.playenv/shims:${PATH}"
  eval "$(playenv init -)"
fi

