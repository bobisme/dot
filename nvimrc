" Basic options------------------------------------------------------------ {{{
set encoding=utf-8
set noswapfile
set visualbell
set lazyredraw
set undofile
set undoreload
set hidden
set backspace=indent,eol,start
set number
set history=10000
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:‗,trail:·
set splitbelow
set splitright
set autoread
set title
set linebreak
set colorcolumn=+1

set shiftround
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
" }}}

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

if has('vim_starting')
  set runtimepath+=~/.nvim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.nvim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'phreax/vim-coffee-script'
" close tags and brackets
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsEditSplit="horizontal"
" snippets for ultisnips
NeoBundle 'honza/vim-snippets'
" use . repeat for more
NeoBundle 'tpope/vim-repeat'
" surround
NeoBundle 'tpope/vim-surround'
" easy substitution, cool replace trick, recasing
NeoBundle 'tpope/vim-abolish'
" handy keybindings I use a lot
NeoBundle 'tpope/vim-unimpaired'
" easy commenting/uncommenting
" disabled for this: 2015-04-05
NeoBundle 'tomtom/tcomment_vim'

" visual indention guides
NeoBundle 'Yggdroot/indentLine'

" markdown awesomeness
NeoBundle 'plasticboy/vim-markdown'
let g:vim_markdown_initial_foldlevel=1
" I like the default highlighting better
autocmd FileType mkd set syntax=markdown
" auto-close tags when you type </
NeoBundle 'docunext/closetag.vim'
" neat browseable tree-style undo
NeoBundle 'sjl/gundo.vim'
" auto-organizing ascii tables
NeoBundle 'godlygeek/tabular'
" clode buffer without closing window
NeoBundle 'cespare/vim-sbd'
" awesome fuzzy file and buffer search
NeoBundle 'kien/ctrlp.vim'
" g:ctrlp_custom_ignore {'file': '\.exe$\|\.so$\|\.dll\|\.pyc\|\.jpg\|\.png\|\.gif\|\.pdf$', 'dir': '\.git$\|\.hg$\|\.svn$', 'link': 'some_bad_symbolic_links'}
let g:ctrlp_custom_ignore = {'dir': 'node_modules'}

NeoBundle 'groenewege/vim-less'
NeoBundle 'tudorprodan/html_annoyance.vim'

" color schemes
" NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'tomasr/molokai'

NeoBundle 'kien/rainbow_parentheses.vim'

let python_highlight_indents = 0
NeoBundle 'airblade/vim-gitgutter'
" make gitgutter not look stupid
highlight clear signColumn
" don't run so damn much
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

NeoBundle 'dhruvasagar/vim-markify'
NeoBundle 'fatih/vim-go'
NeoBundle 'Shougo/unite.vim'

" NeoBundle 'bling/vim-bufferline'
NeoBundle 'bling/vim-airline'
set laststatus=2
let g:airline_powerline_fonts=1

NeoBundle 'scrooloose/syntastic'
let g:syntastic_javascript_checkers = ['eslint']
" default: let g:syntastic_python_checkers = ['python', 'flake8', 'pylint']
" let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_error_symbol = "✗"
let g:syntastic_error_symbol = "‼"
" let g:syntastic_warning_symbol = "⚠"
let g:syntastic_warning_symbol = "⁉"
nmap <leader>l :Errors<cr>

NeoBundle 'po.vim--gray'
NeoBundle 'loremipsum'

" refactoring using python rope
NeoBundle 'klen/rope-vim'
NeoBundle 'dhruvasagar/vim-table-mode'
let g:table_mode_corner = '|'

" make * a little better
NeoBundle 'nelstrom/vim-visual-star-search'
" put vim in a virtualenv
NeoBundle 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory = '~/envs'

" CSV highlighting
NeoBundle 'chrisbra/csv.vim'

" awesome, better-than grep search
NeoBundle 'rking/ag.vim'

" background stuff
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" fantastic autocomplete, c checking
NeoBundle 'Valloric/YouCompleteMe', {
\'build' : {
\ 'mac' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
\ 'unix' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
\ 'windows' : './install.sh --clang-completer --system-libclang --omnisharp-completer',
\ 'cygwin' : './install.sh --clang-completer --system-libclang --omnisharp-completer'
\  }
\}
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
nnoremap <leader>G :YcmCompleter GoToDefinitionElseDeclaration<cr>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" shader syntax
NeoBundle 'tikhomirov/vim-glsl'
NeoBundle 'pfdevilliers/Pretty-Vim-Python'
" Capn Proto syntax
NeoBundle 'cstrahan/vim-capnp'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'othree/html5.vim'

" NeoBundle 'klen/python-mode'
" let g:pymode_warnings = 0
" let g:pymode_lint = 0
" let g:pymode_lint_write = 0
" let g:pymode_rope_completion = 0
" let g:pymode_rope_complete_on_dot = 0
" let g:pymode_syntax = 1
" let g:pymode_syntax_slow_sync = 0

" Javascript
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'
let g:jsx_ext_required = 0

call neobundle#end()
" Required:
filetype plugin indent on
NeoBundleCheck

" Make tab completion for files/buffers act like bash
set wildmenu

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set nobackup
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

autocmd FileType text setlocal textwidth=78
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif
