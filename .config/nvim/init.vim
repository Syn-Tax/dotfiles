call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'skywind3000/quickmenu.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-markdown'
"Plug 'masukomi/vim-markdown-folding', { 'for': 'markdown' }
Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}

call plug#end()

colorscheme onedark

let g:markdown_folding = 1

" enable cursorline (L) and cmdline help (H)
let g:quickmenu_options = "LH"

" clear all the items
call g:quickmenu#reset()

" section 1, text starting with "#" represents a section (see the screen capture below)
call g:quickmenu#append('# Configs', '')

call g:quickmenu#append('qtile', ':edit /home/oscar/.config/qtile/config.py')
call g:quickmenu#append('autostart', ':edit /home/oscar/.config/qtile/autostart.sh')
call g:quickmenu#append('fish', ':edit /home/oscar/.config/fish/config.fish')
call g:quickmenu#append('vimrc', ':edit /home/oscar/.config/nvim/init.vim')

let mapleader = " "

nnoremap <silent><leader><cr> :call quickmenu#toggle(0)<cr>

nnoremap h j
nnoremap t k
nnoremap d h
nnoremap n l

nnoremap k d
nnoremap kk dd

vnoremap h j
vnoremap t k
vnoremap d h
vnoremap n l

vnoremap k d
vnoremap kk dd

map <leader>d <C-w>h
map <leader>h <C-w>k
map <leader>t <C-w>j
map <leader>n <C-w>l

map <leader>w <C-w>w

map <leader>op :NERDTreeToggle<cr>
map <leader>. :Ranger<cr>

let g:ranger_map_key = 0
map <leader>. :Ranger<cr>

set nu rnu
set smarttab
set cindent
set tabstop=4
set shiftwidth=4
set wildmenu

