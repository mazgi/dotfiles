"=======================
" Begin Vundle section
"-----------------------
set nocompatible  " be Improved
filetype off      " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:

"   original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'gregsexton/gitv'

"   vim-scripts repos
"Bundle 'L9'

"   non github repos
"Bundle 'git://git.example.com/command.git'

filetype plugin indent on   " required!
"-----------------------
" End Vundle section
"=======================

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
