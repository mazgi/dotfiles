# vim:set foldmethod=marker foldlevel=9:
# see:
# - http://zsh.sourceforge.net/Doc/Release/Options.html
# - https://github.com/zplug/zplug
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi
# }}}
# plugins with zplug  {{{
export ZPLUG_HOME="${HOME}/.dotfiles/.zsh/lib/zplug"
source "${ZPLUG_HOME}/init.zsh"

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
if (( ! $+commands[starship] )); then
  zplug 'mazgi/zsh-themes', as:theme, use:workstation-heavy.zsh-theme
fi

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
# }}}
# laod profiles {{{
if [[ -e /etc/profile ]] ; then
  . /etc/profile
fi
if [[ -e ~/.profile ]] ; then
  . ~/.profile
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
# Setup fzf {{{
# https://github.com/junegunn/fzf
if [[ -d "${HOME}/.fzf/.git/" ]]; then
  if [[ ! "$PATH" == *${HOME}/.fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
  fi
  # Auto-completion
  [[ $- == *i* ]] && source "${HOME}/.fzf/shell/completion.zsh" 2> /dev/null
  # Key bindings
  source "${HOME}/.fzf/shell/key-bindings.zsh"
fi
export FZF_DEFAULT_OPTS='--select-1 --exit-0 --layout=reverse'
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
# Cargo
if [[ -d "${HOME}/.cargo/bin" ]]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi
# Common Lisp
if [[ -d "${HOME}/.roswell/bin" ]]; then
  export PATH=$PATH:~/.roswell/bin
fi
# Python
if [[ -d "${HOME}/Library/Python/3.7/bin" ]]; then
  export PATH=${HOME}/Library/Python/3.7/bin:$PATH
fi
# hub
if (( $+commands[hub] )); then
  eval "$(hub alias -s)"
fi
# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi
# kubectl
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
fi
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
# starship prompt
# https://github.com/starship/starship
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
# }}}
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  if type zprof > /dev/null 2>&1; then
    zprof | head -40
  fi
fi
# }}}
