" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


" Color scheme
Plug 'morhetz/gruvbox'

" Vim status-bar
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'

" Git gutter
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'

" Easy align
Plug 'junegunn/vim-easy-align'

" YouCompleteMe
Plug 'ycm-core/YouCompleteMe'

" Nerdtree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Initialize plugin system
call plug#end()


colorscheme gruvbox
set background=dark
syntax on
set number
set numberwidth=5
set noexpandtab
let mapleader = ","
set laststatus=2
set backspace=indent,eol,start

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" nerdtree
map <leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.swp$', '__pycache__']

" lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
