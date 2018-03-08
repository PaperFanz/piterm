call plug#begin('~/.config/nvim/plugs')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" allow powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_theme = 'minimalist'
