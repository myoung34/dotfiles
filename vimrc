" Enable auto-indenting
set autoindent
"
" Turn tabs into spaces
set expandtab
"
" Manage multiple buffers
set hidden
"
" Longer command history
set history=1000
"
" Disable compatibility mode
set nocompatible
"
" Enable line numbering
set nu
"
" Show cursor at all times
set ruler
"
" Set indenting to 2 spaces
set shiftwidth=2
"
" Enable display of matching open/close
set showmatch
"
" Set the terminal title when editing
set title
"
" Set tab stop to 2
set ts=2
"
" Set visual bell
set vb
"
" Enable tab completion options
set wildmenu
set wildmode=list:longest

nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

set hlsearch
nnoremap <C-/> :noh<cr>

"map <F3> :Unite file<CR>

" NERDTree stuff
" autoload NERDTree
"autocmd vimenter * NERDTree
"" auto-set focus to file on startup
"autocmd VimEnter * wincmd p
"" close nerdtree if it is the only buffer left (all files closed)
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"" Map nerdtree tab open/close
"map <F3> :NERDTreeTabsToggle<CR>
"" nerdtree tab global open on startup
"let g:nerdtree_tabs_open_on_console_startup=1
"" open files from NERDTree in new tab
"let NERDTreeMapOpenInTab='<ENTER>'

"
" Syntax highlighting
syntax on
"
" Enable open/close matching
runtime macros/matchit.vim
"set guifont=Consolas:h14:cANSI
set backspace=indent,eol,start

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'mac' : 'make',
\    },
\ }
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'rodjek/vim-puppet'
NeoBundle 'tpope/vim-rails'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'hashivim/vim-packer'
NeoBundle 'hashivim/vim-vagrant'
NeoBundle 'hashivim/vim-consul'
NeoBundle 'hashivim/vim-vaultproject'
NeoBundle 'saltstack/salt-vim'

filetype plugin indent on     " Required!
"
" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck
call neobundle#end()

set ttimeoutlen=50
let g:airline_powerline_fonts = 1

let &t_Co=256
set laststatus=2
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
