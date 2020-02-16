# See http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fzprof-Module
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi

export ZDOTDIR=${ZDOTDIR:-$HOME}
export EDITOR=vim
export GOPATH="${HOME}/.go"

# `source` it above `compinit`
# See https://github.com/zdharma/zinit#option-2---manual-installation
source ${ZDOTDIR}/.zsh/lib/zdharma/zinit/zinit.zsh

# Set up compinit
# See:
# - https://medium.com/@dannysmith/little-thing-2-speeding-up-zsh-f1860390f92
# - https://gist.github.com/ctechols/ca1035271ad134841284#gistcomment-2308206
# - http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
#   - With the -U flag, alias expansion is suppressed when the function is loaded.
#   - The flags -z and -k mark the function to be autoloaded using the zsh or ksh style, as if the option KSH_AUTOLOAD were unset or were set, respectively. The flags override the setting of the option at the time the function is loaded.
# - http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Use-of-compinit
#   - The dumped file is .zcompdump in the same directory as the startup files (i.e. $ZDOTDIR or $HOME);
#   - The check performed to see if there are new functions can be omitted by giving the option -C. In this case the dump file will only be created if there isn’t one already.
# - http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers
#   - N - sets the NULL_GLOB option for the current pattern
#   - m[Mwhms][-|+]n - like the file access qualifier, except that it uses the file modification time.
autoload -Uz compinit
for dump in ${ZDOTDIR}/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# direnv: https://github.com/direnv/direnv
zinit ice from"gh-r" as"program" mv"direnv* -> direnv" atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' pick"direnv"
zinit light direnv/direnv

# ghq: https://github.com/x-motemen/ghq
zinit ice from"gh-r" as"program" mv"ghq_*/ghq -> ghq" pick"ghq"
zinit light x-motemen/ghq
zinit ice silent as"completion"
zinit snippet https://github.com/x-motemen/ghq/blob/master/misc/zsh/_ghq

# hub: https://github.com/github/hub
zinit ice from"gh-r" as"program" mv"hub-*/bin/hub -> hub" atclone'./hub alias -s > zhook.zsh' atpull'%atclone'
zinit light github/hub
zinit ice silent as"completion" mv'hub.zsh_completion -> _hub' 
zinit snippet https://github.com/github/hub/raw/master/etc/hub.zsh_completion

# https://github.com/mazgi/zsh-functions
zinit ice from"gh-r" as"snippet"
zinit light mazgi/zsh-functions

# starship; https://github.com/starship/starship
zinit ice from"gh-r" as"program" atclone'./starship init zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zinit light starship/starship

zinit ice silent wait:0; zinit light zsh-users/zsh-completions
zinit ice silent wait:0 atload:_zsh_autosuggest_start
zinit light zsh-users/zsh-autosuggestions
zinit ice silent wait:0; zinit light zdharma/fast-syntax-highlighting
zinit ice silent wait:0; zinit light zsh-users/zsh-history-substring-search

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

# Append cargo binaries path to the command search path.
if [[ -d ${HOME}/.cargo/bin ]]; then
  export PATH="${PATH}:${HOME}/.cargo/bin"
fi
# Append go binaries path to the command search path.
if (( ${+GOPATH} )); then
  if [[ -d ${GOPATH}/bin ]]; then
    export PATH="${PATH}:${GOPATH}/bin"
  fi
fi

if [[ -e ${ZDOTDIR}/.zshrc.local ]]; then
  source ${ZDOTDIR}/.zshrc.local
fi

if [[ ! -z $RUN_ZPROF ]]; then
  if command -v zprof > /dev/null; then
    zprof
  fi
fi
