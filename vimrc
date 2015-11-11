" VUNDLE
set nocompatible               " be iMproved
filetype on                   " required!
filetype off                   " required!
set encoding=utf-8
set noswapfile
set visualbell
set lazyredraw
set shiftround
set undofile

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
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

" Bundles ========================================================== {{{
" Vundle to be replaced by NeoBundle
" set rtp+=~/.vim/bundle/vundle/
" call vundle#begin()
" Plugin 'gmarik/vundle'

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif

    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

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
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 guifg=#202020 ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#000000 guifg=#151515 ctermbg=4
" let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
" to replace indent guides?
" follow-up: i like it, but too slow
" NeoBundle 'Yggdroot/indentLine'

" auto-close tags when you type </
NeoBundle 'docunext/closetag.vim'
" neat browseable tree-style undo
NeoBundle 'sjl/gundo.vim'
" Disabled: Wed Nov  5 09:49:35 2014
" Plugin 'hsitz/VimOrganizer'
" auto-organizing ascii tables
NeoBundle 'godlygeek/tabular'
" clode buffer without closing window
" NeoBundle 'cespare/vim-sbd'
" awesome fuzzy file and buffer search
NeoBundle 'kien/ctrlp.vim'
" don't manage woring dir
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v(\.git|\.hg|\.svn|node_modules|static\/components|bower_components)$',
  \ 'file': '\.exe$\|\.so$\|\.dll\|\.pyc\|\.jpg\|\.png\|\.gif\|\.pdf$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_max_height = 20
let g:ctrlp_map = '<leader>f'
" open the buffer again, I don't care
let g:ctrlp_switch_buffer = 0
let g:ctrlp_reuse_window = '.*'

" Plugin 'skammer/vim-css-color'
" Plugin 'hail2u/vim-css3-syntax'
NeoBundle 'groenewege/vim-less'
" Plugin 'nanotech/jellybeans.vim'
NeoBundle 'tudorprodan/html_annoyance.vim'
NeoBundle 'rust-lang/rust.vim'

" color schemes
NeoBundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'tomasr/molokai'

NeoBundle 'kien/rainbow_parentheses.vim'

NeoBundle 'airblade/vim-gitgutter'
" make gitgutter not look stupid
let g:gitgutter_diff_args = '-w'
" highlight clear signColumn
" don't run so damn much
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

NeoBundle 'dhruvasagar/vim-markify'
" Plugin 'jnwhiteh/vim-golang'
NeoBundle 'fatih/vim-go'
let $GOPATH=resolve(expand('~/src/gostuff'))
NeoBundle 'Shougo/unite.vim'

" Plugin 'bling/vim-bufferline'
NeoBundle 'bling/vim-airline'
set laststatus=2
let g:airline_powerline_fonts=1

NeoBundle 'scrooloose/syntastic'
let g:syntastic_javascript_checkers = ['eslint']
" default: let g:syntastic_python_checkers = ['python', 'flake8', 'pylint']
" let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_checkers = ['prospector']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = "✗"
" let g:syntastic_error_symbol = "‼»"
let g:syntastic_warning_symbol = "⚠"
" let g:syntastic_warning_symbol = "⁉»"
nmap <leader>l :Errors<cr>

" vim-scripts repos
" Plugin 'L9'
" Plugin 'FuzzyFinder'
" Plugin 'Better-CSS-Syntax-for-Vim'
" Plugin 'css_color.vim'
" Plugin 'AutoComplPop'
NeoBundle 'VOoM'
NeoBundle 'po.vim--gray'
NeoBundle 'loremipsum'

" Disabled: use Ag instead, Wed Nov  5 10:08:35 2014
" Plugin 'ack.vim'
" Disabled: not used, Wed Nov  5 10:08:47 2014
" Plugin 'reinh/vim-makegreen'
" Disabled: not used, Wed Nov  5 10:08:47 2014
" Plugin 'lambdalisue/nose.vim'

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

" fantastic autocomplete, c checking
" increase neobundle timeout so build can complete
NeoBundle 'Valloric/YouCompleteMe', {
\'build': {
  \'mac': './install.py --clang-completer --omnisharp-completer --gocode-completer',
  \'unix': './install.py --clang-completer --omnisharp-completer --gocode-completer',
  \'windows': 'install.py --clang-completer --omnisharp-completer --gocode-completer',
  \'cygwin': './install.py --clang-completer --omnisharp-completer --gocode-completer'
  \}
\}
" ./install.sh --clang-completer --omnisharp-completer --gocode-completer
" let g:ycm__key_list_previous_completion = ['<Up>']
" let g:ycm__key_list_select_completion = ['<Enter>', '<Down>']
" let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
nnoremap <leader>G :YcmCompleter GoToDefinitionElseDeclaration<cr>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" syntax highlighting
NeoBundle 'tikhomirov/vim-glsl'
NeoBundle 'cstrahan/vim-capnp'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'othree/html5.vim'

" Python
" refactoring using python rope
" NeoBundle 'pfdevilliers/Pretty-Vim-Python'
NeoBundle 'klen/rope-vim'
NeoBundle 'klen/python-mode'
let g:pymode_folding = 0
let g:pymode_indent = 0
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_syntax = 0
let g:pymode_syntax_slow_sync = 0
let g:pymode_warnings = 0
NeoBundle 'hdima/python-syntax'
let python_highlight_all = 1

" Javascript
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'
let g:jsx_ext_required = 0
NeoBundle 'elzr/vim-json'
NeoBundle 'kennethzfeng/vim-raml'
NeoBundle 'stephpy/vim-yaml'

" writing
NeoBundle 'tpope/vim-markdown'
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.mkd set filetype=markdown
NeoBundle 'mattly/vim-markdown-enhancements'
" NeoBundle 'plasticboy/vim-markdown'
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
NeoBundle 'junegunn/goyo.vim'

function! s:goyo_enter()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  Pencil
  TableModeEnable
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  PencilOff
  TableModeDisable
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd  User GoyoLeave nested call <SID>goyo_leave()

call neobundle#end()
NeoBundleCheck

" call vundle#end()
" Required:
filetype plugin indent on
" }}} Bundles =======================


" FUZZYFINDER MAPPINGS
map <leader>zf :FufFile<cr>
map <leader>zb :FufBuffer<cr>

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
set t_Co=256 " 256 colors
set background=dark
color molokai

if has("gui_running")
    set lines=100
    set columns=173
    " color base16-8o8
    color base16-monokai
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

" manual python syntax
" au! Syntax python source ~/.vim/syntax/python.vim
" au! Syntax python source ~/.vim/bundle/Pretty-Vim-Python/syntax/python.vim
"
" syn match   pythonFunction
"       \ "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained nextgroup=pythonVars
" syn region pythonVars start="(" end=")" contained contains=pythonParameters transparent keepend
" syn match pythonParameters "[^,]*" contained skipwhite
" HiLink pythonParameters       Statement

au Colorscheme * hi Comment cterm=italic gui=italic
au Colorscheme * hi htmlItalic cterm=italic gui=italic
au Colorscheme * hi htmlBold cterm=bold gui=bold
au Colorscheme * hi htmlBoldItalic cterm=bold,italic gui=bold,italic
au Colorscheme * hi htmlH1 cterm=bold gui=bold
au Colorscheme * hi Comment cterm=italic gui=italic
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

" GRB: Put useful info in status line
:set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>/<BS>

let mapleader=","

" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=black

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
autocmd BufRead,BufNewFile *.less setfiletype css
autocmd BufRead,BufNewFile *.md setfiletype markdown
autocmd BufRead,BufNewFile *.raml setlocal syntax=yaml

autocmd FileType html setlocal sw=2 ts=2 sts=2
autocmd FileType htmldjango setlocal sw=2 ts=2 sts=2
autocmd FileType xml setlocal sw=2 ts=2 sts=2
autocmd FileType javascript,json setlocal sw=2 ts=2 sts=2
autocmd FileType css,less setlocal sw=2 ts=2 sts=2
autocmd FileType python setlocal foldmethod=indent foldnestmax=2
autocmd FileType go setlocal noexpandtab
autocmd FileType coffee setlocal sw=2 ts=2 sts=2
autocmd FileType raml setlocal ts=2 sw=2 sts=2 et
" make commentary use // for go files
autocmd FileType go set commentstring=//\ %s
" autocmd FileType c set commentstring=//\ %s
autocmd FileType c set formatprg=astyle\ -A2\ -s4\ -C\ -S\ -w\ -Y\ -p\ -W1\ -k1\ -j\ -c\ -xC79
" make quick fix span bottom
autocmd FileType qf wincmd J
" make fugitive status/commit span top
autocmd FileType gitcommit wincmd K
autocmd FileType htmldjango let b:surround_{char2nr("v")} = "{{\r}}"
autocmd FileType htmldjango let b:surround_{char2nr("{")} = "{{\r}}"
autocmd FileType htmldjango let b:surround_{char2nr("%")} = "{% \r %}"
autocmd FileType htmldjango let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
autocmd FileType htmldjango let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
autocmd FileType htmldjango let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
autocmd FileType htmldjango let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
autocmd FileType htmldjango let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
" autocmd FileType mkd set commentstring=<!--\ %s\ -->
autocmd FileType mkd set commentstring=<!--\ %s\ -->
autocmd FileType less let &efm='%E%t: %m in %f on line %l, column %c:%C%C%C'
autocmd FileType less set makeprg=lessc\ --no-color\ -l\ %

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

" MAPS AND MAPS AND MAPS AND MAPS ============================================
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>gu :GundoToggle<CR>
command Bd bp\|bd \#
command Bdf bp\|bd\! \#
nnoremap <silent> <leader>bd :Bd<CR>
nnoremap <silent> <leader>bD :Bdf<CR>
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
" open file in Marked (mac only)
nnoremap <leader>md :silent !open -a Marked\ 2.app '%:p'<cr>
" tagbar
nnoremap <leader>t :TagbarToggle<cr>
" save
nnoremap <leader>w :w<cr>
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

" easy filetype switching {{{
nnoremap _md :set ft=markdown<cr>
nnoremap _hd :set ft=htmldjango<cr>
nnoremap _pd :set ft=python.django<cr>
" }}}
" {% en
"  %}

" mamba (python version of rspec)
" open the spec for the current file
command Espec e %:p:h/specs/%:r_spec.py

" NOTES ================================================================= {{{
" Find camel case caps:
" \v^@!((\U@<=)\u|(\u((\u|$)@!)))
" }}}
