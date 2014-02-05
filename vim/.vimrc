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
Bundle 'quickrun.vim'

" Syntax highlight
Bundle 'Markdown'

Bundle 'AutoComplPop'

"   scala
Bundle 'scala.vim'

"   JavaScript
Bundle 'pangloss/vim-javascript'
Bundle 'jelera/vim-javascript-syntax'

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

colorscheme hybrid

augroup VIMRC
  autocmd!
  " 
  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
  autocmd InsertEnter * highlight CursorLine ctermbg=0
  autocmd InsertLeave * highlight CursorLine ctermbg=235
  " File types
  "autocmd BufRead,BufNewFile *.scala set filetype=scala

  autocmd FileType fstab setlocal noexpandtab shiftwidth=4 softtabstop=4
  autocmd FileType limits setlocal expandtab shiftwidth=4 softtabstop=4
  autocmd FileType pam setlocal noexpandtab shiftwidth=4 softtabstop=4
  " 
  autocmd QuickFixCmdPost vimgrep cwindow
augroup END

