# vim:set foldmethod=syntax foldlevel=9:
# see:
# - http://zsh.sourceforge.net/Doc/Release/Options.html

# ----------------------------------------------------------------
# functions for file/directory operations
function mkdir-cd() {
  mkdir -p $1 && cd $1
}

# ----------------------------------------------------------------
# functions for git and git web services operations
function go-to-repository() {
  local -A opts
  local usage_msgs
  local with_new_tmux_session=false

  # build message for usage
  usage_msgs=(
  "usage: $0"
  "        [-h | --help]"
  "        [-T | --with-tmux]"
  "        [-C | --with-code]"
  )

  # parse arguments
  zparseopts -D -M -A opts -E -- h -help=h T -with-tmux=T C -with-code=C
  if [[ -n ${opts[(i)-h]} ]]; then
    printf "%s\n" "${usage_msgs[@]}"
    return;
  fi
  if [[ -n ${opts[(i)-T]} ]]; then
    with_new_tmux_session=true
  fi
  if [[ -n ${opts[(i)-C]} ]]; then
    if (( $+commands[code] )); then
      with_new_vscode_window=true
    else
      tput setaf 3 && \
        printf "\"code\" command not found." && \
        tput sgr0
    fi
  fi

  # to repository
  to=$(ghq root)/$(ghq list | fzf-tmux)
  if [[ -n "$to" ]]; then
    cd "$to"

    # (optionnal)create new tmux session
    if [[ $with_new_tmux_session = true ]] && [[ -z $TMUX ]]; then
      name="$(basename $(cd ../..; pwd))" # e.g. "github.com"
      name+="/$(basename $(cd ..; pwd))"  # e.g. "github.com/mazgi"
      name+="/$(basename $PWD)"           # e.g. "github.com/mazgi/.dotfiles"
      tmux new -s "${name//\./+}"         # e.g. "github+com/mazgi/+dotfiles"
    fi

    # (optionnal)open via vscode
    if [[ $with_new_vscode_window = true ]] ; then
      code .
    fi
  fi
}

function create-repository() {
  # ToDo:
  if (( ! $+commands[hub] )); then
    echo 'command `hub` not exist!'
    return -9
  fi

  local -A opts
  local usage_msgs
  local err_msg
  local show_help_and_return_err=false
  local hub_cmd
  local git_service_base_url="github.com"
  local is_private=true
  local description
  local namespace_with_name

  # build message for usage
  usage_msgs=(
  "usage: $0"
  "        [-h | --help]"
  "        [-S <github.com|other> | --service <github.com|other>]"
  "        [--public]"
  "        [-D <description> | --description <description>]"
  "        <namespace/repository>"
  ""
  "hints:"
  "       - You can delete a repository via \`hub delete\` command."
  ""
  "references:"
  "       - https://hub.github.com/hub-create.1.html"
  "       - https://hub.github.com/hub-delete.1.html"
  )

  # parse arguments
  zparseopts -D -M -A opts -E -- h -help=h S: -service:=S -public D: -description:=D
  if [[ -n ${opts[(i)-h]} ]]; then
    printf "%s\n" "${usage_msgs[@]}"
    return;
  fi
  if [[ -n ${opts[(i)-S]} ]]; then
    git_service_base_url=${opts[-S]}
  fi
  if [[ -n ${opts[(i)--public]} ]]; then
    is_private=false
  fi
  if [[ -n ${opts[(i)-D]} ]]; then
    description=${opts[-D]}
  fi
  if [[ $# -eq 1 ]]; then
    namespace_with_name=$1
    shift
  else
    err_msg="Invalid arguments length!"
    show_help_and_return_err=true
  fi

  # build hub command line
  hub_cmd+="hub create "
  test $is_private = true && hub_cmd+="-p "
  test -n "$description" && hub_cmd+="-d \"${description}\" "
  hub_cmd+=$namespace_with_name

  # create the repository with built command
  repository_path="$(ghq root)/$git_service_base_url/$namespace_with_name"
  if [[ ! -e "$repository_path" ]]; then
    mkdir -p "$repository_path"
    printf "Execute command \`%s\` on '%s' ...\n" "$hub_cmd" "$repository_path"
    (
    cd "$repository_path"
    git init
    eval "$hub_cmd"
    )
  else
    err_msg=$(printf "The repository path '%s' already exists on \`ghq root\`!" $namespace_with_name)
    show_help_and_return_err=true
  fi

  if [[ $show_help_and_return_err = true ]]; then
    >&2 (
    tput setaf 1 && \
      printf "Error: %s\n" "$err_msg" && \
      tput sgr0 && \
      echo;
    )
    printf "%s\n" "${usage_msgs[@]}"
    return -1
  fi
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

# Todo: support linux
function build-nativefier() {
  name="$1"
  url="$2"
  docker pull mazgi/nativefier
  docker run -v $PWD:/pwd -w /pwd mazgi/nativefier nativefier --platform osx --counter --bounce --internal-urls '.*' --name "$name" "$url"
  open .
}
