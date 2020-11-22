# See http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fzprof-Module
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi

# `source` it above `compinit`
# See https://github.com/zdharma/zinit#option-2---manual-installation
source ${ZDOTDIR}/.zinit/bin/zinit.zsh

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

# https://github.com/mazgi/zsh-functions
zinit ice from"gh-r" as"snippet"
zinit light mazgi/zsh-functions

# starship; https://github.com/starship/starship
eval "$(starship init zsh)"

zinit ice silent wait:0; zinit light zsh-users/zsh-completions
zinit ice silent wait:0 atload:_zsh_autosuggest_start
zinit light zsh-users/zsh-autosuggestions
zinit ice silent wait:0; zinit light zsh-users/zsh-syntax-highlighting
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
# 0 -- ~/a/b/c
# 1 -- ~/a/b
# 2 -- ~/a
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

if [[ -e ${ZDOTDIR}/.zshrc.local ]]; then
  source ${ZDOTDIR}/.zshrc.local
fi

if [[ ! -z $RUN_ZPROF ]]; then
  if command -v zprof > /dev/null; then
    zprof
  fi
fi
