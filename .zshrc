# See:
# - http://zsh.sourceforge.net/Doc/Release/Options.html
# - https://github.com/zplug/zplug
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi

export ZDOTDIR=${ZDOTDIR:-$HOME}

# starship prompt
# See: https://github.com/starship/starship
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi

if [[ -e ${ZDOTDIR}/.zshrc.local ]]; then
  . ${ZDOTDIR}/.zshrc.local
fi

autoload -U compinit
compinit

# fpath=(${ZDOTDIR}/.zsh/lib/zsh-users/zsh-completions/src $fpath)
# source ${ZDOTDIR}/.zsh/lib/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh 
# source ${ZDOTDIR}/.zsh/lib/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ${ZDOTDIR}/.zsh/lib/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
# source ${ZDOTDIR}/.zsh/lib/functions.zsh

HISTFILE=${ZDOTDIR}/.cache/zsh/zsh-history
HISTSIZE=999999
SAVEHIST=999999
setopt share_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_reduce_blanks

bindkey -e

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

# mkdir -p foo/bar/baz
# cd [ESC-.]
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

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

export EDITOR=vim

# Cargo
if [[ -d "${HOME}/.cargo/bin" ]]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi
# hub
if (( $+commands[hub] )); then
  eval "$(hub alias -s)"
fi
# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

if [[ ! -z $RUN_ZPROF ]]; then
  if command -v zprof > /dev/null; then
    # zprof | head -40
    zprof
  fi
fi
