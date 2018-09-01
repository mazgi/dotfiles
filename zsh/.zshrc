# vim:set foldmethod=marker:
# see:
# - http://zsh.sourceforge.net/Doc/Release/Options.html
# - https://github.com/zplug/zplug

# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
fi
# }}}

export EDITOR=vim
export FZF_DEFAULT_OPTS='--select-1 --exit-0 --layout=reverse'

# plugins with zplug  {{{
source ~/.zplug/init.zsh

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug "supercrabtree/k"
zplug 'mazgi/zsh-themes', as:theme, use:workstation-simple.zsh-theme

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
if [[ -e ~/.zshrc.local ]] ; then
  . ~/.zshrc.local
fi
# }}}

# history settings {{{
HISTFILE=$HOME/.zsh-history
HISTSIZE=999999
SAVEHIST=999999
setopt share_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_reduce_blanks
# }}}

WORDCHARS='*'

bindkey -e
bindkey "^[u" undo
bindkey "^[r" redo

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

autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
#zstyle :insert-last-word match '([:alpha:]){2,}'
bindkey '^]' insert-last-word

autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle :bracketed-paste-magic paste-init backward-extend-paste

# aliases {{{
if [ 'Darwin' = $(uname -s) ]; then
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

function mkdir-cd() {
  mkdir -p $1 && cd $1
}

function go-repo() {
  to=$(ghq root)/$(ghq list | fzf-tmux)
  test ! -z ${to} && cd ${to}
}

function switch-branch() {
  if [[ $(git status 2> /dev/null) ]]; then
    target=$(git branch -vv | fzf-tmux | tr -d '*' | awk '{print $1}')
    test ! -z ${target} && git checkout ${target}
  fi
}

# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  if type zprof > /dev/null 2>&1; then
    zprof | head -40
  fi
fi
# }}}
