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

" Vundles ========================================================== {{{
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Plugin 'tpope/vim-fugitive'

Plugin 'Lokaltog/vim-easymotion'
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

Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
" not updated enough
Plugin 'phreax/vim-coffee-script'
" close tags and brackets
Plugin 'Raimondi/delimitMate'
Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsEditSplit="horizontal"
" snippets for ultisnips
Plugin 'honza/vim-snippets'
" use . repeat for more
Plugin 'tpope/vim-repeat'
" surround
Plugin 'tpope/vim-surround'
" easy substitution, cool replace trick, recasing
Plugin 'tpope/vim-abolish'
" handy keybindings I use a lot
Plugin 'tpope/vim-unimpaired'
" easy commenting/uncommenting
Plugin 'tpope/vim-commentary'

" visual indention guides
Plugin 'nathanaelkane/vim-indent-guides'
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 guifg=#202020 ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#000000 guifg=#151515 ctermbg=4
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" markdown awesomeness
Plugin 'plasticboy/vim-markdown'
let g:vim_markdown_initial_foldlevel=1
" I like the default highlighting better
autocmd FileType mkd set syntax=markdown
" auto-close tags when you type </
Plugin 'docunext/closetag.vim'
" neat browseable tree-style undo
Plugin 'sjl/gundo.vim'
" Disabled: Wed Nov  5 09:49:35 2014
" Plugin 'hsitz/VimOrganizer'
" auto-organizing ascii tables
Plugin 'godlygeek/tabular'
" clode buffer without closing window
Plugin 'cespare/vim-sbd'
" awesome fuzzy file and buffer search
Plugin 'kien/ctrlp.vim'
" auto check python files in flake8
" Disabled: Thu Nov  6 08:31:18 2014
" since syntastic should do the same
" Plugin 'nvie/vim-flake8'

" Plugin 'skammer/vim-css-color'
" Plugin 'hail2u/vim-css3-syntax'
Plugin 'groenewege/vim-less'
" Plugin 'nanotech/jellybeans.vim'
Plugin 'tudorprodan/html_annoyance.vim'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'chriskempson/base16-vim'
" Plugin 'me-vlad/python-syntax.vim'
let python_highlight_indents = 0
Plugin 'airblade/vim-gitgutter'
" make gitgutter not look stupid
highlight clear signColumn
" don't run so damn much
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

Plugin 'dhruvasagar/vim-markify'
Plugin 'jnwhiteh/vim-golang'
Plugin 'Shougo/unite.vim'

" Plugin 'bling/vim-bufferline'
Plugin 'bling/vim-airline'
set laststatus=2
let g:airline_powerline_fonts=1

Plugin 'scrooloose/syntastic'
" default: let g:syntastic_python_checkers = ['python', 'flake8', 'pylint']
" let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_always_populate_loc_list = 1
nmap <leader>l :Errors<cr>

" vim-scripts repos
" Plugin 'L9'
" Plugin 'FuzzyFinder'
" Plugin 'Better-CSS-Syntax-for-Vim'
" Plugin 'css_color.vim'
" Plugin 'python.vim'
" Plugin 'AutoComplPop'
Plugin 'VOoM'
Plugin 'po.vim--gray'
Plugin 'Python-Syntax-Folding'
Plugin 'loremipsum'

" Disabled: use Ag instead, Wed Nov  5 10:08:35 2014
" Plugin 'ack.vim'
" Disabled: not used, Wed Nov  5 10:08:47 2014
" Plugin 'reinh/vim-makegreen'
" Disabled: not used, Wed Nov  5 10:08:47 2014
" Plugin 'lambdalisue/nose.vim'

" refactoring using python rope
Plugin 'klen/rope-vim'
Plugin 'dhruvasagar/vim-table-mode'
let g:table_mode_corner = '|'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'pangloss/vim-javascript'

" Disabled: Wed Nov  5 10:04:15 2014
" Plugin 'fmoralesc/vim-pad'
" nnoremap <leader>p :OpenPad<cr>
" nnoremap <leader>lp :ListPads<cr>

" make * a little better
Plugin 'nelstrom/vim-visual-star-search'
" put vim in a virtualenv
Plugin 'jmcantrell/vim-virtualenv'
let g:virtualenv_directory = '~/envs'

" CSV highlighting
Plugin 'chrisbra/csv.vim'

" Disabled: Wed Nov  5 10:05:18 2014
" functionality provided my smart motion
" Plugin 'justinmk/vim-sneak'

" Disabled: Wed Nov  5 10:05:27 2014
" Plugin 'maksimr/vim-translator'
" g:goog_user_conf = {'langpair': 'de|en', 'v_key': 'T'}

" awesome, better-than grep search
Plugin 'rking/ag.vim'

" fantastic autocomplete, c checking
Plugin 'Valloric/YouCompleteMe'
" let g:ycm__key_list_previous_completion = ['<Up>']
" let g:ycm__key_list_select_completion = ['<Enter>', '<Down>']
" let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tag_files = 1
nnoremap <leader>G :YcmCompleter GoToDefinitionElseDeclaration<cr>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

call vundle#end()             " required
" }}}
filetype plugin indent on     " required

" FUZZYFINDER MAPPINGS
map <leader>zf :FufFile<cr>
map <leader>zb :FufBuffer<cr>

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=1000

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

" set colors
set t_Co=256 " 256 colors
set background=dark
color grb256

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
        set guifont=Monaco\ for\ Powerline\ 10
    elseif has("gui_macvim")
        " let macvim_hig_shift_movement = 1
        set guifont=Monaco\ for\ Powerline:h14,Monaco:h14
    endif
endif

"let g:jellybeans_background_color = '0A0A0A'
":color jellybeans

" GRB: add pydoc command
:command! -nargs=+ Pydoc :call ShowPydoc("<args>")
function! ShowPydoc(module, ...)
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
    :execute ":!pydoc " . a:module . " > " . fPath
    :execute ":sp ".fPath
endfunction

" GRB: Use custom python.vim syntax file
au! Syntax python source ~/.vim/syntax/python.vim
let python_highlight_all = 1
let python_slow_sync = 1

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
  autocmd FileType ruby,haml,eruby,yaml set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et
augroup END

set switchbuf=useopen

" Map ,e to open files in the same directory as the current file
map <leader>e :e <C-R>=expand("%:h")<cr>/

set number
set numberwidth=5


" CSS highlighting for LESS ==================================================
au BufRead,BufNewFile *.less setfiletype css

" CTRL+P =====================================================================
" don't manage woring dir
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.exe$\|\.so$\|\.dll\|\.pyc\|\.jpg\|\.png\|\.gif\|\.pdf$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_max_height = 20
let g:ctrlp_map = '<leader>f'
" open the buffer again, I don't care
let g:ctrlp_switch_buffer = 0
let g:ctrlp_reuse_window = '.*'

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
au BufWritePre *.go silent Fmt

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
command! -nargs=1 NewTechBlog :e ~/Dropbox/docs/techblog/`date +\%F`-<args>.mkd

" GENERAL ====================================================================
command! W :w
command! Q :q
command! Wq :wq
set background=dark
set foldmethod=marker

" FILETYPE AUTOCOMMANDS ====================================================== 
autocmd FileType html setlocal sw=2 ts=2 sts=2
autocmd FileType htmldjango setlocal sw=2 ts=2 sts=2
autocmd FileType xml setlocal sw=2 ts=2 sts=2
autocmd FileType javascript setlocal sw=2 ts=2 sts=2
autocmd FileType css setlocal sw=2 ts=2 sts=2
autocmd FileType less setlocal sw=2 ts=2 sts=2
autocmd FileType python setlocal foldmethod=indent foldnestmax=2
autocmd FileType go setlocal noexpandtab
autocmd FileType coffee setlocal sw=2 ts=2 sts=2
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

" highlight over 80 cols
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
 
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

" MAPS AND MAPS AND MAPS AND MAPS ============================================
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
nnoremap <silent> <leader>gd :Gvdiff<cr>
nnoremap <silent> <leader>gh :Gvdiff HEAD<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gx :wincmd h<cr>:q<cr>
" open file in Marked (mac only)
nnoremap <leader>md :silent !open -a Marked.app '%:p'<cr>
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
