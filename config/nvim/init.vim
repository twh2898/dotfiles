"
" ~/.config/nvim/init.vim
"

call plug#begin("~/.vim/plugged")
    " Plugin Section

    " Themes
    Plug 'dracula/vim'
    Plug 'rakr/vim-one'
    Plug 'nightsense/carbonized'

    " NERDTree
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'

    " C++
    Plug 'neoclide/coc.nvim'
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    "Plug 'vhdirk/vim-cmake'
    "Plug 'cdelledonne/vim-cmake'
    "Plug 'raspine/vim-target'

    " Toml
    Plug 'cespare/vim-toml'

    " Lua
    Plug 'twh2898/vim-lua'

    " GLSL
    Plug 'tikhomirov/vim-glsl'

    " Scarpet
    Plug 'twh2898/vim-scarpet'
call plug#end()

source ~/.config/nvim/base.vim
source ~/.config/nvim/colors.vim
source ~/.config/nvim/keys.vim
source ~/.config/nvim/openterm.vim
source ~/.config/nvim/nerdtree.vim
source ~/.config/nvim/cpp.vim
source ~/.config/nvim/snip.vim
source ~/.config/nvim/lua.vim
source ~/.config/nvim/format.vim
source ~/.config/nvim/rust.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/python.vim

set hidden

set nobackup
set nowritebackup

set updatetime=300

set shortmess+=c

let g:coc_global_extensions = ['coc-python', 'coc-rls', 'coc-snippets', 'coc-lua', 'coc-cmake', 'coc-git', 'coc-json', 'coc-python', 'coc-sh', 'coc-xml', 'coc-html', 'coc-css', 'coc-yaml']

