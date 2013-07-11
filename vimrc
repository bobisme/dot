" VUNDLE
set nocompatible               " be iMproved
filetype on                   " required!
filetype off                   " required!
set encoding=utf-8

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
" not updated enough
" Bundle 'kchmck/vim-coffee-script'
Bundle 'phreax/vim-coffee-script'
Bundle 'Raimondi/delimitMate'
" Bundle 'msanders/snipmate.vim'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-commentary'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'plasticboy/vim-markdown'
" Bundle 'tsaleh/vim-supertab'
Bundle 'docunext/closetag.vim'
Bundle 'sjl/gundo.vim'
" Bundle 'jceb/vim-orgmode'
Bundle 'hsitz/VimOrganizer'
Bundle 'jeffkreeftmeijer/vim-numbertoggle'
Bundle 'godlygeek/tabular'
" Bundle 'ivanov/vim-ipython'
Bundle 'ollummis/sbd.vim'
Bundle 'kien/ctrlp.vim'

" Powerline ==================================================================
" Bundle 'Lokaltog/vim-powerline'
" :let g:Powerline_symbols='unicode'

Bundle 'nvie/vim-flake8'
" Bundle 'skammer/vim-css-color'
" Bundle 'hail2u/vim-css3-syntax'
Bundle 'groenewege/vim-less'
" Bundle 'nanotech/jellybeans.vim'
Bundle 'tudorprodan/html_annoyance.vim'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'chriskempson/base16-vim'
Bundle 'me-vlad/python-syntax.vim'
let python_highlight_indents = 0
Bundle 'airblade/vim-gitgutter'
" make gitgutter not look stupid
highlight clear signColumn

Bundle 'dhruvasagar/vim-markify'
Bundle 'jnwhiteh/vim-golang'
Bundle 'Shougo/unite.vim'

" Bundle 'bling/vim-bufferline'
Bundle 'bling/vim-airline'
set laststatus=2

Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'

" vim-scripts repos
Bundle 'L9'
" Bundle 'FuzzyFinder'
" Bundle 'Better-CSS-Syntax-for-Vim'
" Bundle 'css_color.vim'
" Bundle 'python.vim'
" Bundle 'AutoComplPop'
Bundle 'VOoM'
Bundle 'po.vim--gray'
Bundle 'Python-Syntax-Folding'
Bundle 'loremipsum'
" Bundle 'Conque-Shell'
Bundle 'ack.vim'

" non github repos
" Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required! 

" FUZZYFINDER MAPPINGS
map <leader>zf :FufFile<cr>
map <leader>zb :FufBuffer<cr>

" VIM-INDENT-GUIDES
" let g:indent_guides_auto_colors = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 guifg=#202020 ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#000000 guifg=#151515 ctermbg=4
let g:indent_guides_auto_colors = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

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

" if has("gui_macvim")
"     let macvim_hig_shift_movement = 1
" endif

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

if has("gui_running")
  :set lines=100
  :set columns=173

  " highlight current line"
  " :set cursorline
  " hide toolbar
  :set go-=T
  :set guifont=Monaco:h14
endif

" set colors
:set t_Co=256 " 256 colors
:set background=dark
" :color grb256
:color base16-8o8

if has("gui_running")
    " Use the same symbols as TextMate for tabstops and EOLs
    " set listchars=tab:▸\ ,eol:¬
    set listchars=tab:▸\ 
    "Invisible character colors
    " highlight NonText guifg=#4a4a59
    " highlight SpecialKey guifg=#4a4a59
    set list
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
" au! Syntax python source ~/.vim/syntax/python.vim
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
autocmd FileType python nnoremap <buffer> <leader>8 :call Flake8()<CR>
" run on save
autocmd BufWritePost *.py call Flake8()
" ignore errors
" let g:flake8_ignore="E501,W293"

" SparkUp ====================================================================
augroup sparkup_types
  " Remove ALL autocommands of the current group.
  autocmd!
  " Add sparkup to new filetypes
  autocmd FileType mustache,php,htmldjango runtime! ftplugin/html/sparkup.vim
augroup END

" CoffeeLint ================================================================= 
let coffee_lint_options = '-f ~/coffeelint.json'
au BufWritePost *.coffee silent CoffeeLint!

" Go Fmt =====================================================================
au BufWritePre *.go silent Fmt

" GENERAL ====================================================================
command! W :w
command! Q :q
command! Wq :wq
set background=dark
set foldmethod=marker

" FILETYPE AUTOCOMMANDS ====================================================== 
" no expanding in html or javascript
autocmd FileType html setlocal noexpandtab sw=2 ts=2 sts=2
autocmd FileType htmldjango setlocal noexpandtab sw=2 ts=2 sts=2
autocmd FileType javascript setlocal noexpandtab sw=2 ts=2 sts=2
autocmd FileType python setlocal foldmethod=indent foldnestmax=2
autocmd FileType go setlocal noexpandtab
autocmd FileType coffee setlocal sw=2 ts=2 sts=2
" make commentary use // for go files
autocmd FileType go set commentstring=//\ %s
autocmd FileType c set commentstring=//\ %s
autocmd FileType c set formatprg=astyle\ -A2\ -s4\ -C\ -S\ -w\ -Y\ -p\ -W1\ -k1\ -j\ -c\ -xC79
" make quick fix span bottom
autocmd FileType qf wincmd J
" make fugitive status/commit span top
autocmd FileType gitcommit wincmd K

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
nnoremap <silent> <leader>gd :Gdiff HEAD<cr>
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gx :wincmd h<cr>:q<cr>
" open file in Marked (mac only)
nnoremap <leader>md :silent !open -a Marked.app '%:p'<cr>
" tagbar
nnoremap <leader>t :TagbarToggle<cr>
" save
nnoremap <leader>w :w<cr>
nnoremap <leader>ls :set syntax=txt<cr>:set syntax=less<cr>
" b#
nnoremap <leader>bb :b#<cr>
" markdown headlines
nnoremap <leader>= :normal yypVr=<cr>
nnoremap <leader>- :normal yypVr-<cr>
" make
nnoremap <silent> <leader>mm :make<cr>

