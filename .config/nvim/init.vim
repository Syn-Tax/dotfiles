call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'

call plug#end()

colorscheme onedark

let mapleader = " "

nnoremap d h
nnoremap h k
nnoremap t j
nnoremap n l

map <leader>op :NERDTreeToggle<cr>

set nu rnu
set smarttab
set cindent
set tabstop=4
set shiftwidth=4
