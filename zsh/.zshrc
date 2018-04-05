if [ -e /etc/profile ] ; then
  . /etc/profile
fi

if [ -e ~/.zshrc.local ] ; then
  . ~/.zshrc.local
fi

# fpath
if [ -d "/usr/local/share/zsh-completions" ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
if [ -d "/usr/local/share/zsh/site-functions" ]; then
  fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
if [ -d "${HOME}/.zsh/zsh-completions" ]; then
  fpath=("${HOME}/.zsh/zsh-completions" $fpath)
fi

autoload colors
colors

UID_COLOR=${fg[green]}
case ${UID} in
0)
  UID_COLOR=${fg[red]}
  ;;
*)
  ;;
esac

HOST_COLOR=0
I=0
for c in $(hostname | awk '{len=split($0,str,""); for(i=1; i<=len; i++){print str[i]}}')
do
  HOST_COLOR=$((${HOST_COLOR} + $(printf "%d" "'${c}")))
  I=$((${I} + 1))
done;
HOST_COLOR="$(printf "%%F{%03d}@%%f" "$((${HOST_COLOR} / ${I}))")"

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

PROMPT="[%{$UID_COLOR%}%n%{${reset_color}%}${HOST_COLOR}%{$reset_color%}%m] %(!.#.$) "
PROMPT2="%{${fg[blue]}%}%_> %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
RPROMPT="%1(v|%F{green}%1v%f|) %{${fg[blue]}%}[%~]%{${reset_color}%}"

bindkey ' ' magic-space  # also do history expansion on space

#WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
WORDCHARS='*'
#------------------------------------------------
#| wordとみなす文字を羅列。
#| C-wタイプすると、このword単位で削れる。
#| $ vi /etc/conf.d/keymaps[C-w]
#| $ vi /etc/conf.d/
#| ・・・みたいな
#------------------------------------------------

bindkey -e      # emacsっぽい
#bindkey -v     # vi風味

alias -g G='| grep '
alias -g M='| more '
alias tmux='tmux -u'

if [ 'Darwin' = $(uname -s) ]; then
  alias ls='ls -FG'   # Mac
else
  alias ls='ls -Fv --color'  # Linux
fi
alias ll='ls -l'
alias la='ls -a'

alias be='bundle exec'

setopt  auto_pushd
#------------------------------------------------
#| こんなカンジで、cdしたディレクトリをpushd
#| $ cd hoge 
#| $ ls
#| hoga/  huge/  hunya/
#| $ pwd
#| /ANY/hoge
#| $ cd hoga 
#| $ cd ../huge 
#| $ cd ../hunya 
#| $ cd -[TAB]
#| 0 -- /ANY
#| 1 -- /ANY/hoge
#| 2 -- /ANY/hoge/hoga
#| 3 -- /ANY/hoge/huge
#| じつはhunyaかfunyaかは悩みどころ
#------------------------------------------------
setopt  pushd_ignore_dups    # スタックから重複排除

setopt  correct
#------------------------------------------------
#| こんなカンジで「それ、typoじゃね？」とか聞いてくれる
#| $ sl
#| zsh: correct 'sl' to 'ls' [nyae]? 
#| あたりまえだけどsl導入済みの時はSLが走ります。
#------------------------------------------------
autoload compinit    # 色々補完
compinit
# compinit -u    # Cygwinの時は-u付けてパーミッションのテストをスルーしないと都合悪かったはず。

# {0-9a-z} -> 0 1 .. 8 9 a b .. y z
setopt braceccl

HISTFILE=$HOME/.zsh-history             # 履歴をファイルに保存する
HISTSIZE=100000                         # メモリ内の履歴の数
SAVEHIST=100000                         # 保存される履歴の数
setopt share_history                    # 複数のセッションで履歴を共有
setopt hist_ignore_all_dups             # 履歴から重複排除
setopt extended_history                 # 履歴ファイルに時刻を記録
function history-all { history -E 1 }   # 全履歴の一覧を出力する
setopt transient_rprompt                # 最新行以外の右プロンプトを消してくれるらしい
setopt extended_glob                    # ^と~使ってファイルを除外

# rbenv
if [ -d ${HOME}/.rbenv ]; then
  export PATH="${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}"
  eval "$(rbenv init -)"
fi

# tfenv
if [ -d ${HOME}/.rbenv ]; then
  export PATH="${HOME}/.tfenv/bin:${PATH}"
fi

# Android
if [ -d "${HOME}/Applications/android-platform-tools" ]; then
  export PATH="${HOME}/Applications/android-platform-tools:${PATH}"
fi

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "${HOME}/.gvm/bin/gvm-init.sh" ]] && source "${HOME}/.gvm/bin/gvm-init.sh"

# pyenv
if [ -d "${HOME}/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/shims:$PATH"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Python pip
export PIP_RESPECT_VIRTUALENV=true
if [ -d ${HOME}/.local/lib64 ]; then
  export PYTHONPATH="${HOME}/.local/lib64/python2.7/site-packages:${PYTHONPATH}"
fi
if [ -d ${HOME}/.local/bin ]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi

# original commands
[ -d ${HOME}/bin ] && export PATH="${HOME}/bin:${PATH}"
[ -d ${HOME}/Applications/bin ] && export PATH="${HOME}/Applications/bin:${PATH}"

# JVM on Mac OSX
if [ -e "/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home" ]; then
  export JAVA_HOME=$(/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8")
  PATH=${JAVA_HOME}/bin:${PATH}
fi

# Scala, sbt, PlayFramework
[ -d ${HOME}/Applications/activator/current ] && export PATH="${HOME}/Applications/activator/current:${PATH}"
if [ -d "${HOME}/.svm/current" ]; then
  export SCALA_HOME="${HOME}/.svm/current/rt"
  export PATH="${SCALA_HOME}/.svm/current/rt/bin:${PATH}"
fi

if [ -d ${HOME}/.scalaenv ]; then
  export PATH="${HOME}/.scalaenv/bin:${HOME}/.scalaenv/shims:${PATH}"
  eval "$(scalaenv init -)"
fi
if [ -d ${HOME}/.sbtenv ]; then
  export PATH="${HOME}/.sbtenv/bin:${HOME}/.sbtenv/shims:${PATH}"
  eval "$(sbtenv init -)"
  export SBT_OPTS="-Xmx1G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=1G -Xss1M"
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

# Heroku
if [ -d /usr/local/heroku/bin/ ]; then
  export PATH="/usr/local/heroku/bin:$PATH"
fi

# Google App Engine
if [ -d ${HOME}/Applications/go_appengine ]; then
  export PATH=$PATH:${HOME}/Applications/go_appengine
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f ${HOME}/Applications/google-cloud-sdk/path.zsh.inc ]; then
  source "${HOME}/Applications/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f ${HOME}/Applications/google-cloud-sdk/completion.zsh.inc ]; then
  source "${HOME}/Applications/google-cloud-sdk/completion.zsh.inc"
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/hidenori.matsuki/Creations/github.com/mazgi/hello-vault/bin/vault vault
