alias tmux='tmux -u'

# bash-completion on homebrew
type brew 2> /dev/null && if [ -f `brew --prefix`/etc/bash_completion ]; then
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

if [ "Linux" = $(uname) ]; then
  net_tools_deprecated_message () {
    echo -n 'net-tools コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
  }

  arp () {
    net_tools_deprecated_message
    echo 'Use `ip n`'
  }
  ifconfig () {
    net_tools_deprecated_message
    echo 'Use `ip a`, `ip link`, `ip -s`'
  }
  iptunnel () {
    net_tools_deprecated_message
    echo 'Use `ip tunnel`'
  }
  iwconfig () {
    echo -n 'iwconfig コマンドはもう非推奨ですよ？おじさんなんじゃないですか？ '
    echo 'Use `iw`'
  }
  nameif () {
    net_tools_deprecated_message
    echo 'Use `ip link`, `ifrename`'
  }
  netstat () {
    net_tools_deprecated_message
    echo 'Use `ss`, `ip route` (for netstat -r), `ip -s link` (for netstat -i), `ip maddr` (for netstat -g)'
  }
  route () {
    net_tools_deprecated_message
    echo 'Use `ip r`'
  }
fi
