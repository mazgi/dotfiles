if 1
  "=======================
  " Begin Vundle section
  "-----------------------
  set nocompatible  " be Improved
  filetype off      " required!

  if $GOROOT != ''
    set rtp+=$GOROOT/misc/vim
  endif

  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()

  " let Vundle manage Vundle
  " required!
  Bundle 'gmarik/vundle'

  " My Bundles here:
  Bundle 'stephpy/vim-yaml'

  "   original repos on github
  Bundle 'tpope/vim-fugitive'
  Bundle 'gregsexton/gitv'
  Bundle 'quickrun.vim'

  Bundle 'AutoComplPop'

  " Syntax check
  Bundle 'tpope/vim-pathogen'
  Bundle 'scrooloose/syntastic'
  call pathogen#infect()

  " Syntax highlight
  Bundle 'Markdown'

  " Terraform
  Bundle 'hashivim/vim-terraform'
  let g:terraform_fmt_on_save = 1

  " Middlewares
  Bundle 'chr4/nginx.vim'

  " Web
  Bundle 'slim-template/vim-slim'

  " JavaScript
  Bundle 'pangloss/vim-javascript'
  Bundle 'jelera/vim-javascript-syntax'

  " Scala
  Bundle 'scala.vim'

  " Color schemes
  Bundle 'w0ng/vim-hybrid'

  "   vim-scripts repos
  "Bundle 'L9'

  "   non github repos
  "Bundle 'git://git.example.com/command.git'

  filetype plugin indent on   " required!
  "-----------------------
  " End Vundle section
  "=======================

  syntax on

  " modeline
  set modeline
  set modelines=3

  " indent
  set autoindent
  set cindent
  set smartindent

  set nocompatible
  set expandtab
  set list
  set number
  set showmatch

  set tabstop=2
  set shiftwidth=2
  set backspace=indent,eol,start

  " Encoding
  set encoding=utf-8
  set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

  set background=dark
  colorscheme hybrid

  augroup VIMRC
    autocmd!
    " 
    autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    autocmd InsertEnter * highlight CursorLine ctermbg=0
    autocmd InsertLeave * highlight CursorLine ctermbg=235
    autocmd BufRead,BufNewFile *.zsh-theme set filetype=zsh
    " File types
    "autocmd BufRead,BufNewFile *.scala set filetype=scala

    "autocmd FileType fstab setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType limits setlocal expandtab shiftwidth=4 softtabstop=4
    autocmd FileType pam setlocal noexpandtab shiftwidth=4 softtabstop=4
    " 
    autocmd QuickFixCmdPost vimgrep cwindow
  augroup END
endif " end of 'if 1'

