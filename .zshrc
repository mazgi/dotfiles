# vim:set foldmethod=marker foldlevel=9:
# see:
# - http://zsh.sourceforge.net/Doc/Release/Options.html
# - https://github.com/zplug/zplug
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi
# }}}
# laod profiles {{{
if [[ -e /etc/profile ]] ; then
  . /etc/profile
fi
if [[ -e ~/.zshrc.local ]] ; then
  . ~/.zshrc.local
fi
# }}}
# load custom functions
source ~/.zsh/lib/zshrc.functions.zsh
# history settings {{{
HISTFILE=$HOME/.zsh-history
HISTSIZE=999999
SAVEHIST=999999
setopt share_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_reduce_blanks
# }}}
# bindkeys {{{
bindkey -e
bindkey "^[u" undo
bindkey "^[r" redo
# }}}
# setops for directory/file operations {{{
WORDCHARS='*'

# correct: sl -> ls [nyae]?
setopt correct
# {0-2a-c} => 0 1 2 a b c
setopt braceccl
# foo --bar=[TAB]
setopt magic_equal_subst
# x#, x##, *sh~*.sh, ^*.ext
setopt extended_glob
# $ cd -[TAB]
# 0 -- ~/.dotfiles/a/b/c
# 1 -- ~/.dotfiles/a/b
# 2 -- ~/.dotfiles/a
setopt auto_pushd
setopt pushd_ignore_dups
# }}}
# smart-insert-last-word {{{
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
#zstyle :insert-last-word match '([:alpha:]){2,}'
bindkey '^]' insert-last-word
# }}}
# url-quote-magic {{{
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle :bracketed-paste-magic paste-init backward-extend-paste
# }}}
# aliases {{{
if [[ 'Darwin' = $(uname -s) ]]; then
  alias ls='ls -FG'
else
  alias ls='ls -Fv --color'
fi
alias ll='ls -l'
alias la='ls -a'
alias -g G='| grep '
alias -g M='| more '
alias -g V='| vim -R -'
# }}}
# set envs {{{
export EDITOR=vim
export FZF_DEFAULT_OPTS='--select-1 --exit-0 --layout=reverse'
export GOPATH="${HOME}/.go"
export PATH="${GOPATH}/bin:${PATH}"
# Android SDK
if [[ -d "${HOME}/Library/Android/sdk/" ]]; then
  export PATH="${HOME}/Library/Android/sdk/platform-tools:${PATH}"
fi
fpath=(~/.zsh/completions $fpath)
# gcloud
if [[ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi
# Common Lisp
if [[ -d "${HOME}/.roswell/bin" ]]; then
  export PATH=$PATH:~/.roswell/bin
fi
# hub
if (( $+commands[hub] )); then
  eval "$(hub alias -s)"
fi
# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi
# }}}
# plugins with zplug  {{{
source ~/.zplug/init.zsh

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug "supercrabtree/k"
zplug 'mazgi/zsh-themes', as:theme, use:workstation-heavy.zsh-theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
# }}}
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  if type zprof > /dev/null 2>&1; then
    zprof | head -40
  fi
fi
# }}}
