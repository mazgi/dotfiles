syntax on

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

augroup vimrc
autocmd! FileType html setlocal tabstop=2 shiftwidth=2
augroup END
