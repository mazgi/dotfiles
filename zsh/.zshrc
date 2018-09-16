# vim:set foldmethod=marker:
# see:
# - http://zsh.sourceforge.net/Doc/Release/Options.html
# - https://github.com/zplug/zplug
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  zmodload zsh/zprof
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
# laod profiles {{{
if [[ -e /etc/profile ]] ; then
  . /etc/profile
fi
if [[ -e ~/.zshrc.local ]] ; then
  . ~/.zshrc.local
fi
# }}}
# custom functions {{{
# ----------------------------------------------------------------
# functions for file/directory operations
function mkdir-cd() {
  mkdir -p $1 && cd $1
}

# ----------------------------------------------------------------
# functions for git operations
function go-to-repository() {
  to=$(ghq root)/$(ghq list | fzf-tmux)
  test ! -z ${to} && cd ${to}
}

function switch-branch() {
  if [[ $(git status 2> /dev/null) ]]; then
    target=$(git branch -vv | fzf-tmux | tr -d '*' | awk '{print $1}')
    test ! -z ${target} && git checkout ${target}
  fi
}

function return-to-default-branch-and-delete-merged-topic-branch() {
  if [[ $(git status 2> /dev/null) ]]; then
    # Get default and topic branch.
    local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    local topic_branch=$(git branch | grep -E '^\*\s+' | awk '{print $2}')
    if [[ -z $default_branch ]] || [[ -z $topic_branch ]]; then
      tput setaf 1 && \
        printf "Cannot get default or topic branch!\n"
      return -1
    fi

    # Do nothing if the current branch is the same as the default branch.
    if [[ $default_branch = $topic_branch ]]; then
      printf "Already on default branch '%s'.\n" $default_branch
      return
    fi

    # Switch back to the default branch && delete the merged topic branch.
    printf "Topic branch '%s' will be removed.\n" $topic_branch
    tput bold && \
      tput setaf 3 && \
      printf "Are you sure? [y/N]: " && \
      tput sgr0
    if read -q; then
      echo;
      git checkout $default_branch && \
        git fetch origin --prune && \
        git merge --ff-only origin/$default_branch && \
        git branch -d $topic_branch
    fi
  fi
}

# ----------------------------------------------------------------
# functions for misc
function render-xterm-256colors() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}
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
fpath=(~/.zsh/completions $fpath)
# gcloud
if [[ -d "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
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
# zprof {{{
if [[ ! -z $RUN_ZPROF ]]; then
  if type zprof > /dev/null 2>&1; then
    zprof | head -40
  fi
fi
# }}}
