" Show line numbers
set number

" Show relative line numbers
set relativenumber

" Enable syntax highlighting
syntax on

" Better indentation
set autoindent
set smartindent

" Use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Enable mouse
set mouse=a


" Use Space as the leader key
let mapleader = " "

" Yank to the system clipboard with <Space>y
nnoremap <leader>y "+y
xnoremap <leader>y "+y

" Paste from system clipboard
nnoremap <leader>p "+p
xnoremap <leader>p "+p

" Delete to system clipboard
nnoremap <leader>d "+d
xnoremap <leader>d "+d
