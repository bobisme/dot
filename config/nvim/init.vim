set nocompatible               " be iMproved
filetype on                   " required!
filetype off                   " required!
set encoding=utf-8
set noswapfile
set visualbell
set lazyredraw
set shiftround
set undofile
" use system clipboard
set clipboard=unnamed
" why would you think . is part of a word?
set iskeyword-=.
set conceallevel=1

set undodir=~/.nvim/tmp/undo//
set backupdir=~/.nvim/tmp/backup//
set directory=~/.nvim/tmp/swap//
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

" mac brew only
let g:python_host_prog='/usr/local/bin/python'

" Bundles ========================================================== {{{
" Vundle to be replaced by NeoBundle
" set rtp+=~/.config/nvim/bundle/vundle/
" call vundle#begin()
" Plugin 'gmarik/vundle'

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  " Required:
  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.config/nvim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" background stuff
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" original repos on github
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'Lokaltog/vim-easymotion'
" do 2-char search, like vim-sneak
" nmap s <Plug>(easymotion-s2)
nmap s <Plug>(easymotion-sn)
" enhance search
map  <leader>/ <Plug>(easymotion-sn)
omap <leader>/ <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
let g:EasyMotion_smartcase = 1
" highlight column
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
let g:EasyMotion_startofline = 0

" Disabled 2015-03-18 in favor of emmet
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'scrooloose/nerdtree'
let NERDTreeIgnore = ['\.pyc$']
NeoBundle 'majutsushi/tagbar'
" not updated enough
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
" Plugin 'tpope/vim-commentary'
" disabled for this: 2015-04-05
NeoBundle 'tomtom/tcomment_vim'

" visual indention guides
NeoBundle 'nathanaelkane/vim-indent-guides'
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 guifg=#202020 ctermbg=238
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#000000 guifg=#151515 ctermbg=236
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
" to replace indent guides?
" NeoBundle 'Yggdroot/indentLine'
" let g:indentLine_setColors = 0
" let g:indentLine_color_term = 239

" auto-close tags when you type </
NeoBundle 'docunext/closetag.vim'
" neat browseable tree-style undo
NeoBundle 'sjl/gundo.vim'
" Disabled: Wed Nov  5 09:49:35 2014
" Plugin 'hsitz/VimOrganizer'
" auto-organizing ascii tables
NeoBundle 'godlygeek/tabular'
" close buffer without closing window
NeoBundle 'cespare/vim-sbd'

" fuzzy finder is cool
" let $FZF_DEFAULT_COMMAND='ag -g ""'
let $FZF_DEFAULT_COMMAND='rg --files --follow'
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf'}
NeoBundle 'junegunn/fzf.vim'
let g:fzf_command_prefix = 'Fzf'

NeoBundle 'sheerun/vim-polyglot'
"" pangloss/vim-javascript
let g:javascript_plugin_flow = 1
"" 'mxw/vim-jsx'
let g:jsx_ext_required = 0
NeoBundle 'tudorprodan/html_annoyance.vim'
" polyglotted: NeoBundle 'rust-lang/rust.vim'
" polyglotted: NeoBundle 'cespare/vim-toml'
" kotlin language
" polyglotted: NeoBundle 'udalov/kotlin-vim'
" gradle syntax
" polyglotted: NeoBundle 'tfnico/vim-gradle'
NeoBundle 'haproxy'

" PostgreSQL syntax highlighting
" polyglotted: NeoBundle 'exu/pgsql.vim'
autocmd BufNewFile,Bufread *.sql setf pgsql

" colors {{{
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'qualiabyte/vim-colorstepper'
"}}}

NeoBundle 'kien/rainbow_parentheses.vim'
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

NeoBundle 'airblade/vim-gitgutter'
" make gitgutter not look stupid
let g:gitgutter_diff_args = '-w'
" highlight clear signColumn
" don't run so damn much
let g:gitgutter_realtime = 0

NeoBundle 'dhruvasagar/vim-markify'
NeoBundle 'fatih/vim-go'
" turn on syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" install binaries to ~/bin
let g:go_bin_path = expand("~/bin")
" if !isdirectory("workspace")
"     call mkdir("/my/directory", "p")
" endif
" let $GOPATH=resolve(expand('~/go'))
" let $GOROOT=resolve(expand('/usr/local/opt/go/libexec'))
let g:go_fmt_command = "goimports"
NeoBundle 'rhysd/vim-go-impl'
NeoBundle 'Shougo/unite.vim'

" Plugin 'bling/vim-bufferline'
NeoBundle 'bling/vim-airline'
set laststatus=2
let g:airline_powerline_fonts=1

NeoBundleLazy 'facebook/vim-flow', {
    \ 'autoload': {
    \     'filetypes': ['javascript', 'jsx']
    \ }}
let g:flow#enable = 0
NeoBundle 'ternjs/tern_for_vim'
NeoBundle 'mephux/vim-jsfmt'

NeoBundle 'benekastah/neomake'
autocmd! BufWritePost * Neomake
let g:neomake_python_pylama_maker = {
    \ 'args': [
        \ '--format', 'pep8',
        \ '-i', 'D203,D212',
        \ '-l', 'pep8,mccabe,pyflakes,pep257,pylint'],
    \ 'errorformat': '%f:%l:%c: %m',
    \ }
let g:neomake_javascript_enabled_makers = ['eslint', 'flow']
let g:neomake_jsx_enabled_makers = ['eslint', 'flow']
let g:neomake_rust_rustc_maker = {
    \ 'args': ['rustc', '-Zno-trans'],
    \ 'exe': 'cargo',
    \ 'append_file': 0,
    \ 'errorformat':
        \ '%-G%f:%s:,' .
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m,' .
        \ '%f:%l:%c: %m,'.
        \ '%f:%l: %trror: %m,'.
        \ '%f:%l: %tarning: %m,'.
        \ '%f:%l: %m',
    \ }

" vim-scripts repos
" Plugin 'L9'
" Plugin 'FuzzyFinder'
" Plugin 'Better-CSS-Syntax-for-Vim'
" Plugin 'css_color.vim'
" Plugin 'AutoComplPop'
NeoBundle 'VOoM'
NeoBundle 'po.vim--gray'
NeoBundle 'loremipsum'

NeoBundle 'dhruvasagar/vim-table-mode'
let g:table_mode_corner = '|'

" Disabled: Wed Nov  5 10:04:15 2014
" Plugin 'fmoralesc/vim-pad'
" nnoremap <leader>p :OpenPad<cr>
" nnoremap <leader>lp :ListPads<cr>

" make * a little better
NeoBundle 'nelstrom/vim-visual-star-search'
" put vim in a virtualenv
NeoBundle 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory = '~/envs'

" CSV highlighting
NeoBundle 'chrisbra/csv.vim'

" Disabled: Wed Nov  5 10:05:18 2014
" functionality provided my smart motion
" Plugin 'justinmk/vim-sneak'

" Disabled: Wed Nov  5 10:05:27 2014
" Plugin 'maksimr/vim-translator'
" g:goog_user_conf = {'langpair': 'de|en', 'v_key': 'T'}

" awesome, better-than grep search
NeoBundle 'rking/ag.vim'
" use ripgrep
let g:ag_prg="rg --vimgrep --no-heading"

" " fantastic autocomplete, c checking
" " increase neobundle timeout so build can complete
" NeoBundle 'Valloric/YouCompleteMe'
" " NeoBundle 'Valloric/YouCompleteMe', {
" " \'build': {
" "   \'mac': './install.py --all',
" "   \'unix': './install.py --all',
" "   \'windows': 'install.py --all',
" "   \'cygwin': './install.py --all'
" "   \}
" " \}
" " ./install.sh --clang-completer --omnisharp-completer --gocode-completer
" " let g:ycm__key_list_previous_completion = ['<Up>']
" " let g:ycm__key_list_select_completion = ['<Enter>', '<Down>']
" " let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_python_binary_path='/usr/local/bin/python'
" let g:ycm_complete_in_comments = 1
" let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_collect_identifiers_from_tag_files = 1
" nnoremap <leader>G :YcmCompleter GoToDefinitionElseDeclaration<cr>
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" replace youcompleteme?
set completeopt=longest,menuone,preview
NeoBundle 'ervandew/supertab'
NeoBundle 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_complete_delay = 50
NeoBundle 'zchee/deoplete-jedi'
NeoBundle 'steelsojka/deoplete-flow', { 'for': ['javascript', 'javascript.jsx'] }
NeoBundle 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
NeoBundle 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.jsx'] = ['buffer', 'file', 'ultisnips', 'flow', 'ternjs']
let g:tern#command = ['tern']
" use arrows to go gthrough auto-complete menu and insert the text
inoremap <expr> <down> ((pumvisible())?("\<C-n>"):("<down>"))
inoremap <expr> <up> ((pumvisible())?("\<C-p>"):("<up>"))
let g:tern#arguments = ['--persistent']
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'flowcomplete#Complete',
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
NeoBundle 'zchee/deoplete-go', {'build': {'unix': 'make'}}
NeoBundle 'zchee/deoplete-clang'

" syntax highlighting
NeoBundle 'tikhomirov/vim-glsl'
NeoBundle 'cstrahan/vim-capnp'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'digitaltoad/vim-pug'
NeoBundle 'ntpeters/vim-better-whitespace'

" Python
" refactoring using python rope
" NeoBundle 'pfdevilliers/Pretty-Vim-Python'
NeoBundle 'python-rope/ropevim'
let ropevim_vim_completions=1
let ropevim_extend_complete=1
NeoBundle 'klen/python-mode'
let g:pymode_folding = 0
let g:pymode_indent = 0
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_rope = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_syntax = 0
let g:pymode_syntax_slow_sync = 0
let g:pymode_warnings = 0
NeoBundle 'hdima/python-syntax'
let python_highlight_all = 1

" Javascript
NeoBundle 'othree/javascript-libraries-syntax.vim'

" writing
NeoBundle 'tpope/vim-markdown'
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.mkd set filetype=markdown
NeoBundle 'mattly/vim-markdown-enhancements'
" let g:vim_markdown_initial_foldlevel=1
" I like the default highlighting better
NeoBundle 'reedes/vim-pencil'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType markdown,mkd TableModeEnable
  autocmd FileType text         call pencil#init({'wrap': 'hard'})
augroup END
NeoBundle 'junegunn/limelight.vim'
let g:limelight_conceal_ctermfg = 'gray'
NeoBundle 'junegunn/goyo.vim'

function! s:goyo_enter()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " Pencil
  " TableModeEnable
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " PencilOff
  " TableModeDisable
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd  User GoyoLeave nested call <SID>goyo_leave()

NeoBundle 'editorconfig/editorconfig-vim'
" preview colors in css and stuff
NeoBundle 'gorodinskiy/vim-coloresque'

" android tools
" NeoBundle 'hsanson/vim-android'

call neobundle#end()
NeoBundleCheck

" Required:
filetype plugin indent on
" }}} Bundles =======================


" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=10000

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

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  " do not keep a backup file, use versions instead
  set nobackup
else
  set backup		" keep a backup file
endif
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" GRB: sane editing configuration"
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

" wrap lines at 78 characters
set textwidth=78

" GRB: highlighting search"
set hls

" colors {{{
" set t_Co=256 " 256 colors
set background=dark
syntax enable
" let base16colorspace=256
" color base16-monokai
" color molokai
color base16-monokai
colorscheme grb256
au Colorscheme * hi Comment cterm=italic gui=italic
au Colorscheme * hi htmlItalic cterm=italic ctermfg=white gui=italic
au Colorscheme * hi htmlBold cterm=bold ctermfg=white gui=bold
au Colorscheme * hi htmlBoldItalic cterm=bold,italic ctermfg=white gui=bold,italic
au Colorscheme * hi htmlH1 cterm=bold gui=bold
au Colorscheme * hi Comment cterm=italic gui=italic
" lighter comments
au Colorscheme * hi Comment ctermfg=247
au Colorscheme * hi DiffText ctermfg=none ctermbg=20
au Colorscheme * hi DiffChange ctermfg=none ctermbg=17
au Colorscheme * hi DiffAdd ctermfg=none ctermbg=22
au Colorscheme * hi DiffDelete ctermfg=red ctermbg=none
au Colorscheme * hi Folded ctermbg=16
" highlight 81st column
" set colorcolumn=80
" hi ColorColumn ctermbg=gray
au Colorscheme * hi ColorColumn ctermbg=16
" call matchadd('ColorColumn', '\%81v', 100)
" au Colorscheme * hi Conceal ctermfg=red ctermbg=None
" flat divider column
au Colorscheme * hi VertSplit ctermfg=darkgray ctermbg=darkgray
au Colorscheme * hi CursorLine ctermbg=None

" highlight current line
set cursorline

if has("gui_running")
    set lines=100
    set columns=173
    " Use the same symbols as TextMate for tabstops and EOLs
    " set listchars=tab:▸\ ,eol:¬
    set list
    " set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
    set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:‗,trail:·
    "Invisible character colors
    " highlight NonText guifg=#4a4a59
    " highlight SpecialKey guifg=#4a4a59
    set list
    set go-=T
    if has("gui_gtk2")
        " set guifont=Inconsolata\ 12
        set guifont=Fantasque\ Sans\ Mono\ Regular\ 15,Monaco\ for\ Powerline\ 10
    elseif has("gui_macvim")
        " let macvim_hig_shift_movement = 1
        " set guifont=Monaco\ for\ Powerline:h14,Monaco:h14
        set guifont=Fantasque\ Sans\ Mono\ Regular:h15,Monaco:h14
    endif
endif
"}}}

" manual python syntax
" au! Syntax python source ~/.vim/syntax/python.vim
" au! Syntax python source ~/.vim/bundle/Pretty-Vim-Python/syntax/python.vim
"
" syn match   pythonFunction
"       \ "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonVars
" syn region pythonVars start="(" end=")" contained contains=pythonParameters transparent keepend
" syn match pythonParameters "[^,]*" contained skipwhite
" HiLink pythonParameters       Statement
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 guifg=#202020 ctermbg=3
" }}}

"let g:jellybeans_background_color = '0A0A0A'
":color jellybeans

" GRB: add pydoc command
:command! -nargs=+ Pydoc :call ShowPydoc("<args>")
function! ShowPydoc(module, ...)
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
    :execute ":!pydoc " . a:module . " > " . fPath
    :execute ":sp ".fPath
endfunction

" GRB: use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" " GRB: Put useful info in status line
" :set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
" :hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>/<BS>

let mapleader=","

set cmdheight=2

" Don't show scroll bars in the GUI
set guioptions-=L
set guioptions-=r

augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,raml setlocal ai sw=2 sts=2 et
  autocmd FileType python setlocal sw=4 sts=4 et
augroup END

set switchbuf=useopen

" Map ,e to open files in the same directory as the current file
map <leader>e :e <C-R>=expand("%:h")<cr>/

set number
set numberwidth=5

" Flake8 =====================================================================
" Disabled: Thu Nov  6 08:33:33 2014
" autocmd FileType python nnoremap <buffer> <leader>8 :call Flake8()<CR>
" run on save
" Disabled: Thu Nov  6 08:33:43 2014
" autocmd BufWritePost *.py call Flake8()
" ignore errors
" let g:flake8_ignore="E501,W293"

" SparkUp ====================================================================
augroup sparkup_types
  " Remove ALL autocommands of the current group.
  autocmd!
  " Add sparkup to new filetypes
  autocmd FileType mustache,php runtime! ftplugin/html/sparkup.vim
augroup END

" CoffeeLint =================================================================
" Disabled: Thu Nov  6 15:33:44 2014
" covered by syntastic
" let coffee_lint_options = '-f ~/coffeelint.json'
" au BufWritePost *.coffee silent CoffeeLint!

" Go Fmt =====================================================================
" au BufWritePre *.go silent Fmt

" Bicycle Repair Man
" http://bicyclerepair.sourceforge.net/
" vim: http://bicyclerepair.sourceforge.net/bzr/bicyclerepair/ide-integration/bike.vim

" Vim-pad ====================================================================
let g:pad_dir = '~/dropbox/docs/vimpad'

" Write Mode =================================================================
function! WriteMode()
    set columns:86
    set spell
endfunction

" writing functions ==========================================================
command! -nargs=1 NewTechBlog :e ~/Dropbox/docs/techblog/`date +\%F`-<args>.md
command! -nargs=1 NewEmail :e ~/email/`date +\%F`-<args>.md

function! NewMarkdown()
    call inputsave()
    let name = input("File Name Part: ")
    let tstamp = strftime("%y%m%d%H%M")
    call inputrestore()
    let filename = "~/tmp/" . tstamp . "_" . name . ".md"
    execute 'edit' filename
    set columns:86
endfunction
command! NewMd call NewMarkdown()
cabbrev tstamp <c-r>=strftime("%y%m%d%H%M")<cr>

" GENERAL ====================================================================
command! W :w
command! Q :q
command! Wq :wq
set background=dark
set foldmethod=marker

" FILETYPE AUTOCOMMANDS ======================================================
au BufRead,BufNewFile *.less setfiletype css
au BufRead,BufNewFile *.md setfiletype markdown
au BufRead,BufNewFile *.raml setlocal syntax=yaml
au BufEnter *.css,*.sass,*.scss,*.html,*.javascript setlocal iskeyword-=.

au FileType coffee setlocal sw=2 ts=2 sts=2
au FileType css,less setlocal sw=2 ts=2 sts=2
au FileType go setlocal noexpandtab iskeyword-=.
au FileType html setlocal sw=2 ts=2 sts=2
au FileType htmldjango setlocal sw=2 ts=2 sts=2
au FileType jade,pug setlocal ts=2 sw=2 sts=2 et
au FileType javascript,json setlocal sw=2 ts=2 sts=2 iskeyword-=.
au FileType python setlocal foldmethod=indent foldnestmax=2
au FileType raml setlocal ts=2 sw=2 sts=2 et
au FileType sass,scss setlocal ts=2 sw=2 sts=2
au FileType sh setlocal ts=2 sw=2 sts=2
au FileType xml setlocal sw=2 ts=2 sts=2

" make commentary use // for go files
au FileType go set commentstring=//\ %s
" au FileType c set commentstring=//\ %s
au FileType c set formatprg=astyle\ -A2\ -s4\ -C\ -S\ -w\ -Y\ -p\ -W1\ -k1\ -j\ -c\ -xC79
" make quick fix span bottom
au FileType qf wincmd J
" make fugitive status/commit span top
au FileType gitcommit wincmd K
au FileType htmldjango let b:surround_{char2nr("v")} = "{{\r}}"
au FileType htmldjango let b:surround_{char2nr("{")} = "{{\r}}"
au FileType htmldjango let b:surround_{char2nr("%")} = "{% \r %}"
au FileType htmldjango let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
au FileType htmldjango let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
au FileType htmldjango let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
au FileType htmldjango let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
au FileType htmldjango let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
" au FileType mkd set commentstring=<!--\ %s\ -->
au FileType mkd set commentstring=<!--\ %s\ -->
au FileType less let &efm='%E%t: %m in %f on line %l, column %c:%C%C%C'
au FileType less set makeprg=lessc\ --no-color\ -l\ %

" control+enter to indent new line
imap <C-Return> <CR><CR><C-o>k<Tab>

" no double indents in python
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

highlight clear signColumn

" Better fold text {{{
set foldlevelstart=0

function! LoshFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
    " return 'ᓬ' . line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=LoshFoldText()
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RemoveFancyCharacters COMMAND
" Remove smart quotes, etc. -- GRB
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveFancyCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    let typo["–"] = '--'
    let typo["—"] = '---'
    let typo["…"] = '...'
    :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

" MAPS AND MAPS AND MAPS AND MAPS "{{{
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>gu :GundoToggle<CR>
nnoremap <silent> <leader>bd :Sbd<CR>
nnoremap <silent> <leader>bD :Sbdm<CR>
" map quickfix
nnoremap <silent> <leader>cc :cc<cr>
nnoremap <silent> <leader>cn :cn<cr>
nnoremap <silent> <leader>cl :ccl<cr>
" map fugitive
nnoremap <silent> <leader>ga :silent Git add %<cr>
nnoremap <silent> <leader>gd :tabedit %\|Gvdiff<cr>
nnoremap <silent> <leader>gD :tabclose<cr>
nnoremap <silent> <leader>gh :Gvdiff HEAD<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gx :wincmd h<cr>:q<cr>
" git gutter
nnoremap <silent> <leader>gg :GitGutter<cr>
" open file in Marked (mac only)
nnoremap <leader>md :silent !open -a Marked\ 2.app '%:p'<cr>
" tagbar
nnoremap <leader>t :TagbarToggle<cr>
" save
nnoremap <leader>w :w<cr>
nnoremap <c-s> :w<cr>
" b#
nnoremap <leader>bb :b#<cr>
" markdown headlines
nnoremap <leader>= :normal yypVr=<cr>gk
nnoremap <leader>- :normal yypVr-<cr>gk
" make
nnoremap <silent> <leader>mm :make<cr>
nnoremap <silent> <leader>mg :MakeGreen %<cr>
nnoremap <silent> <leader>mn :silent !osascript -e 'tell application "iTerm" to tell the first session of the second terminal to write text "./manage.py test --with-rapido %"'<cr>
nnoremap <leader>v :vertical bo new<cr>
" FFFFFFFUUUUUU
vmap <s-up> k
vmap <s-down> j

" move
nnoremap <c-j> 10j
nnoremap <c-k> 10k

nnoremap * *<c-o>
nnoremap D d$
nnoremap H ^
nnoremap L g_

" quickfix last search
nnoremap <silent> <leader><leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" ack last search
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/. "\\\\<", "\\\\b", ""), "\\\\v", "", "") . "'"<cr>

" source current line
vnoremap <leader>S y:execute @@<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>

" select contents of line
nnoremap vv ^vg_

" calculator
inoremap <c-b> <c-o>yiW<end>=<c-r>=<c-r>0<cr>
" previous buffer
nnoremap <c-s-a> :b#<cr>
"}}}

" indent newlines in blocks/braces/parens
inoremap {<cr> {<cr>}<esc>O
inoremap (<cr> (<cr>)<esc>O
inoremap [<cr> [<cr>]<esc>O

" easy filetype switching {{{
nnoremap _md :set ft=markdown<cr>
nnoremap _hd :set ft=htmldjango<cr>
nnoremap _pd :set ft=python.django<cr>
" }}}

" mamba (python version of rspec)
" open the spec for the current file
command Espec e %:p:h/specs/%:r_spec.py

" go to odoo dir and color the window
command! GotoOdoo cd ~/src/odoo | colorscheme base16-paraiso
command! WorkonOdoo GotoOdoo
command! Odoo GotoOdoo

" FZF
nmap <leader>ff :FzfFiles<cr>
nmap <leader>fb :FzfBuffers<cr>
nmap <leader>fa :FzfAg<cr>

" PySuper {{{
" take a copy of the function definition and turn it into a python 2.x
" super call
function! PySuper()
    " copy the function definition here
    " normal i$$$$
    " normal ?def\
    " normal v/:\
    " normal V"dy/\$\$\$\$\
    " normal :s/\$\$\$\$/\=@d/\
    "
    normal ^:s/def /super($$$, self)./
    normal v/:
    normal :s/://
    normal gv:s/\(\w\+\)=\([^,)]\+\)/\1=\1/ge
    normal gvQ
    normal gv:s/\((\|^\s*\)self\(,\s*\)\?/\1/e
    normal ?class
    normal W"zyiw/\$\$\$
    normal :s/\$\$\$/\=@z/
endfunction
command! PySuper :call PySuper()
"}}}

" custom grep {{{
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m   " file:line:column:message
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
endif
" }}}


" NOTES ================================================================= {{{
" Find camel case caps:
" \v^@!((\U@<=)\u|(\u((\u|$)@!)))
" }}}

" vim:foldmethod=marker:foldlevel=0
