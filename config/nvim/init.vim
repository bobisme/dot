set foldmethod=marker
" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase
" allow buffers in the background
set hidden
" remember more commands and search history
set history=10000
" spaces instead of tabs
set expandtab
" default to 4 spaces for tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=78
" flash matching braces
set showmatch
set switchbuf=useopen
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Normally, Vim messes with iskeyword when you open a shell file.
" This can leak out, polluting other file types even after a 'set ft=' change.
" This variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" Change to a window, make it at least this wide
set winwidth=80
" Collapsed windows must at least be this wide
set winminwidth=5
" show special chars
set list
set listchars=tab:·\ ,extends:❯,precedes:❮,trail:·
" don't bother to redraw while running macros or pasting
set lazyredraw
" show for wrapped lines
let &showbreak='⋙ '
" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800
set shell=bash
" allow ESC in terminal
tnoremap <Esc> <C-\><C-n>

" fast grepping
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" UNDO, BACKUP AND SWAP {{{
  set noswapfile
  set backup
  set undofile
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
" }}}

" CUSTOM MAPPINGS {{{
  " use , as the leader
  let mapleader=","
  " paste from system
  nmap <leader>p "*p
  nmap <leader>P "*P
  nmap <leader><leader>p o<esc>"*p

  map <leader>y "*y
  nmap <leader>yy ^vg_"*y`]
  " source current line
  vmap <leader>S y:execute @@<cr>
  nmap <leader>S ^vg_y:execute @@<cr>
  " delete current buffer without closing window
  nmap <leader>bd :bprevious \| bdelete #<cr>
  nmap <leader>bD :bprevious \| bdelete! #<cr>
  " select contents of line
  nnoremap vv ^vg_
  " open file in Marked (mac only)
  nnoremap <leader>md :silent !open -a Marked\ 2.app '%:p'<cr>
  " move
  nnoremap <c-j> 10j
  nnoremap <c-k> 10k
  " FFFFFFFUUUUUU
  vmap <s-up> k
  vmap <s-down> j
  " save
  nmap <c-s> :write<cr>

  " clear the search buffer when hitting return
  nnoremap <CR> :nohlsearch<CR>/<BS>
  " markdown headlines
  nnoremap <leader>= :normal yypVr=<cr>gk
  nnoremap <leader>- :normal yypVr-<cr>gk
  " stop using arrow keys
  nnoremap <left>  :echo 'use h'<cr>
  nnoremap <right> :echo 'use l'<cr>
  nnoremap <up>    :echo 'use k'<cr>
  nnoremap <down>  :echo 'use j'<cr>
  " use them for list navigation instead
  nnoremap <s-left>  :cprev<cr>zvzz
  nnoremap <s-right> :cnext<cr>zvzz
  nnoremap <s-up>    :lprev<cr>zvzz
  nnoremap <s-down>  :lnext<cr>zvzz
  " insert ' => '
  imap <c-L> <space>=><space>
  " open the currently selected line of the quickfix, location
  nnoremap <leader>cc :exec ":cc " . line('.')<cr>
  nnoremap <leader>ll :exec ":ll " . line('.')<cr>

  " reformat selected text with Q
  vnoremap Q gq

  function! FunctionToArrow()
    if match(getline('.'), '=>') == -1
      exec 's/\<function\>/let/e'
      exec 's/\([^(]\+\)\(([^)]\+)\)\s*{/\1 = \2 => {/'
    else
      exec 's/\<\(let\|const\)\>/function/e'
      exec 's/\s*=>\s*/ /'
      exec 's/\s*=\s*\([^{]\+\)/\1/'
    endif
  endfunction
  au FileType javascript,jsx nnoremap <Leader>fn call FunctionToArrow()<cr>
" }}}

" PLUGINS {{{
" Required:
call plug#begin('~/.local/share/nvim/plugged')
  " all the colors
  Plug 'flazz/vim-colorschemes'
  " 16-color ansii scheme
  Plug 'noahfrederick/vim-noctu'
  " use . repeat for more
  Plug 'tpope/vim-repeat'
  " surround
  Plug 'tpope/vim-surround'
  " easy substitution, cool replace trick, recasing
  Plug 'tpope/vim-abolish'
  " handy keybindings I use a lot
  Plug 'tpope/vim-unimpaired'
  " auto close keyword blocks
  Plug 'tpope/vim-endwise'
  " easy commenting/uncommenting
  Plug 'tomtom/tcomment_vim'
  " close quotes and parens
  Plug 'jiangmiao/auto-pairs'
  " auto-close tags when you type </
  Plug 'docunext/closetag.vim'
  " close buffer without closing window
  Plug 'cespare/vim-sbd'
  " snippets
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger="<c-j>"
  let g:UltiSnipsEditSplit="horizontal"

  " file browser
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  let NERDTreeIgnore = ['\.pyc$']
  nnoremap <leader>n :NERDTreeToggle<cr>

  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  nnoremap <leader>t :TagbarToggle<cr>

  " POLYGLOT {{{
  " A collection of language packs for Vim.
    Plug 'sheerun/vim-polyglot'
    let g:jsx_ext_required = 0
    let g:javascript_plugin_flow = 1
  " }}}
  Plug 'vim-scripts/haproxy', { 'for': 'haproxy' }
  " better javascript syntax
  Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
  " quick HTML/XML creation
  Plug 'mattn/emmet-vim'

  " GO {{{
    Plug 'fatih/vim-go', { 'for': 'go' }
    " turn on syntax highlighting
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    " install binaries to ~/bin
    let g:go_bin_path = expand("~/bin")
    " let $GOPATH=resolve(expand('~/go'))
    " let $GOROOT=resolve(expand('/usr/local/opt/go/libexec'))
    let g:go_fmt_command = "goimports"
    augroup vimgomaps
      au FileType go nmap <Leader>ds <Plug>(go-def-split)
      au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
      au FileType go nmap <Leader>dt <Plug>(go-def-tab)
      au FileType go nmap <leader>rt <Plug>(go-run-tab)
      au FileType go nmap <Leader>rs <Plug>(go-run-split)
      au FileType go nmap <Leader>rv <Plug>(go-run-vertical)
      au FileType go nmap <leader>r <Plug>(go-run)
      au FileType go nmap <leader>b <Plug>(go-build)
      au FileType go nmap <leader>t <Plug>(go-test)
      au FileType go nmap <leader>goc <Plug>(go-coverage)
      au FileType go nmap <Leader>gd <Plug>(go-doc)
      au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
      au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
      au FileType go nmap <Leader>s <Plug>(go-implements)
      au FileType go nmap <Leader>i <Plug>(go-info)
      au FileType go nmap <Leader>e <Plug>(go-rename)
    augroup end
  " }}}

  " haskell
  Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim', 'for': 'haskell' }

  " NEOMAKE {{{
    Plug 'benekastah/neomake'
    " run Neomake on save
    autocmd! BufWritePost * Neomake

    " flow maker {{{
      let g:flow_path = substitute(
        \ system('PATH=$(npm bin):$PATH && which flow'),
        \ '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
      " function! NeomakeFlowArgs()
      "   let path = expand('%:p')
      "   return ['-c', g:flow_path.' --json | flow-vim-quickfix']
      " endfunction

      let g:flow_maker = {
      \ 'exe': 'sh',
      \ 'args': ['-c', g:flow_path.' --json | flow-vim-quickfix'],
      \ 'errorformat': '%E%f:%l:%c\,%n: %m',
      \ 'cwd': '%:p:h'
      \ }
        " \ 'args': ['--from=vim', '--show-all-errors'],
      let g:flow_maker_2 = {
        \ 'exe': 'bash',
        \ 'args': ['-c', 'sleep 2; flow --from=vim --show-all-errors'],
        \ 'errorformat': '%EFile "%f"\, line %l\, characters %c-%m,%C%m,%Z%m',
        \ 'postprocess': function('neomake#makers#ft#javascript#FlowProcess')
        \ }
      let g:flow_maker_3 = {
        \ 'exe': 'bash',
        \ 'args': ['-c', 'sleep 1; flow --show-all-errors --json --strip-root | flow-vim-quickfix && sleep 1'],
        \ 'errorformat': '%E%f:%l:%c\,%n: %m',
        \ }
      let g:flow_maker_4 = {
        \ 'exe': 'flow-vim-quickfix',
        \ 'args': ['flow', '--show-all-errors', '--strip-root'],
        \ 'errorformat': '%E%f:%l:%c\,%n: %m',
        \ }
      let g:neomake_jsx_myflow_maker = g:flow_maker_2
      let g:neomake_javascript_myflow_maker = g:flow_maker_2
      let g:js_makers = ['eslint', 'myflow']
      let g:neomake_jsx_enabled_makers = g:js_makers
      let g:neomake_javascript_enabled_makers = g:js_makers
    " }}}

    let g:neomake_python_pylama_maker = {
      \ 'args': [
        \ '--format', 'pep8',
        \ '-i', 'D203,D212',
        \ '-l', 'pep8,mccabe,pyflakes,pep257,pylint'],
        \ 'errorformat': '%f:%l:%c: %m',
      \ }
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
  " }}}

  " AUTOCOMPLETE {{{
    " use arrows to go gthrough auto-complete menu and insert the text
    inoremap <expr> <down> ((pumvisible())?("\<C-n>"):("<down>"))
    inoremap <expr> <up> ((pumvisible())?("\<C-p>"):("<up>"))
    " plugin
    Plug 'Shougo/deoplete.nvim'
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#complete_method = 'omnifunc'
    Plug 'zchee/deoplete-go', {'do': 'make', 'for': 'go' }
    " python completion
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
    " Plug 'bling/vim-airline'
    " haskell
    Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }

    augroup omnifuncs
      autocmd!
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    augroup end

    " Rust completion
    " NOTES:
    " - install rust via rustup: https://www.rustup.rs/
    " - install rust source via `rustup component add rust-src`
    " - install racer via `cargo install racer`
    Plug 'racer-rust/vim-racer', { 'for': 'rust' }
    Plug 'sebastianmarkow/deoplete-rust', { 'for': 'rust' }
  " }}}

  " Awesome git management.
  Plug 'tpope/vim-fugitive'
  nnoremap <leader>gs :Gstatus<cr><c-w>k

  " remove ending whitespace
  Plug 'ntpeters/vim-better-whitespace'
  augroup stripwhitespace
    au BufEnter * EnableStripWhitespaceOnSave
  augroup end

  " fuzzy file/whatever finder
  let $FZF_DEFAULT_COMMAND='rg --files --follow'
  Plug 'junegunn/fzf', { 'do': './install --all', 'dir': '~/.fzf' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_command_prefix = 'Fzf'
  nnoremap <leader>ff :FzfFiles<cr>
  nnoremap <leader>fb :FzfBuffers<cr>

  " WRITING {{{
    Plug 'mattly/vim-markdown-enhancements', {'for': ['markdown', 'asciidoc']}
    Plug 'dhruvasagar/vim-table-mode'
    let g:table_mode_corner = '|'
    " auto-organizing ascii tables
    Plug 'godlygeek/tabular'
    Plug 'reedes/vim-pencil', {'for': ['markdown', 'asciidoc']}
    let g:pencil#map#suspend_af = 'K'
    Plug 'junegunn/limelight.vim', {'for': ['markdown', 'asciidoc']}
    let g:limelight_conceal_ctermfg = 'gray'
    Plug 'junegunn/goyo.vim', {'for': ['markdown', 'asciidoc']}

    function! s:goyo_enter()
      " turn off mux status line
      silent !tmux set status off
      " hide the mode
      set noshowmode
      " hide the command line
      set noshowcmd
      " keep the cursor in the middle of the screen
      set scrolloff=999
      " toggle other plugins
      Limelight
      Pencil
      silent TableModeEnable
    endfunction

    function! s:goyo_leave()
      silent !tmux set status on
      set showmode
      set showcmd
      set scrolloff=5
      Limelight
      Pencil
      silent TableModeEnable
    endfunction

    autocmd! User GoyoEnter
    autocmd! User GoyoLeave
    autocmd  User GoyoEnter nested call <SID>goyo_enter()
    autocmd  User GoyoLeave nested call <SID>goyo_leave()
  " }}}

  " Autoformat {{{
    Plug 'Chiel92/vim-autoformat'

    " Automatically call on these formats
    augroup autoformatonsave
      autocmd!
      au BufWrite *.rs :Autoformat
    augroup end
  " }}}
call plug#end()
" end plugins }}}

" CUSTOM COLORS {{{
  set background=dark
  " highlight current line
  set cursorline
  augroup colors
    au Colorscheme * hi Comment cterm=italic gui=italic ctermfg=gray
    au Colorscheme * hi PreProc ctermfg=blue
    " au Colorscheme * hi htmlBold cterm=bold ctermfg=white gui=bold
    " au Colorscheme * hi htmlBoldItalic cterm=bold,italic ctermfg=white
    " au Colorscheme * hi htmlH1 cterm=bold gui=bold
    " au Colorscheme * hi htmlItalic cterm=italic ctermfg=white gui=italic
    " au Colorscheme * hi DiffText ctermfg=none ctermbg=20
    " au Colorscheme * hi DiffChange ctermfg=none ctermbg=none cterm=italic
    au Colorscheme * hi DiffAdd ctermfg=black ctermbg=darkgreen cterm=bold
    " au Colorscheme * hi DiffDelete ctermfg=red ctermbg=none
    " au Colorscheme * hi Folded ctermbg=234 ctermfg=lightgreen cterm=bold
    " au Colorscheme * hi Special ctermfg=lightgreen
    " highlight 80th column
    set colorcolumn=80
    au Colorscheme * hi ColorColumn ctermbg=234
    " " au Colorscheme * hi Conceal ctermfg=red ctermbg=None
    " " flat divider column
    au Colorscheme * hi VertSplit ctermfg=darkgray ctermbg=black
    au Colorscheme * hi StatusLine ctermbg=gray ctermfg=black
    au Colorscheme * hi StatusLineNC ctermbg=darkgray ctermfg=black
    " au Colorscheme * hi CursorLine ctermbg=16
    " au Colorscheme * hi NonText ctermfg=darkgray
    " au Colorscheme * hi Visual ctermbg=23
  augroup end
  colorscheme noctu
" }}}

" INDENTS {{{
	set shiftwidth=4 tabstop=4 softtabstop=4
  augroup indents
    au FileType coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
    au FileType css,less setlocal sw=2 ts=2 sts=2 et
    au FileType fish setlocal sw=2 ts=2 sts=2 et
    au FileType go setlocal sw=4 ts=4 sts=4 noexpandtab iskeyword-=.
    au FileType html setlocal sw=2 ts=2 sts=2
    au FileType htmldjango setlocal sw=2 ts=2 sts=2
    au FileType jade,pug setlocal ts=2 sw=2 sts=2 et
    au FileType javascript,json setlocal sw=2 ts=2 sts=2 iskeyword-=.
    au FileType purescript setlocal sw=2 ts=2 sts=2 et
    au FileType python setlocal foldmethod=indent foldnestmax=2
    au FileType raml setlocal ts=2 sw=2 sts=2 et
    au FileType ruby setlocal ts=2 sw=2 sts=2 et
    au FileType sass,scss setlocal ts=2 sw=2 sts=2
    au FileType sh setlocal ts=2 sw=2 sts=2
    au FileType thrift setlocal ts=2 sw=2 sts=2 et
    au FileType vim setlocal sw=2 ts=2 sts=2
    au FileType xml setlocal sw=2 ts=2 sts=2
  augroup end
" }}}

" BETTER FOLD TEXT {{{
  set foldlevelstart=0

  function! LoshFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')
    let line = substitute(line, split(&foldmarker, ',')[0], '', 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . ' ᓬ' . ' '
  endfunction " }}}
  set foldtext=LoshFoldText()
" }}}

" SWITCH TO/FROM TEST FILE {{{
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file

  let in_js_project = match(current_file, '\.jsx\?$') != -1
  let in_dashboard = match(expand('%:p:h'), '/containers/dashboard/') != -1

  if in_js_project && in_dashboard
    let in_test = match(current_file, '[Tt]est\.js$') != -1
    let going_to_test = !in_test
    if going_to_test
      let new_file = substitute(new_file, '\.js\(x\)\?$', 'Test.js\1', '')
      let new_file = substitute(new_file, '^src/app/', 'test/', '')
    else
      let new_file = substitute(new_file, '[Tt]est\.js\(x\)\?$', '.js\1', '')
      let new_file = substitute(new_file, '^test/', 'src/app/', '')
    end
  end

  return new_file
endfunction

nnoremap <leader>. :call OpenTestAlternate()<cr>
" }}}

" MISC {{{
" replace %% with the urrent file dir
cnoremap %% <c-r>=expand('%:h')<cr>

augroup miscau
  " make quick fix span bottom
  au FileType qf wincmd J
  " make fugitive status/commit span top
  au FileType gitcommit wincmd K
augroup end

augroup leaveenter
  au WinEnter * setlocal wrap
  au WinLeave * setlocal nowrap
augroup end

augroup jumplastopen
  " From :help last-position-jump
  " This autocommand jumps to the last known position in a file
  " just after opening it, if the '" mark is set: >
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end

" If there is a workspace, set up for Arbor Go dev.
if isdirectory(expand('~/workspace'))
  let workspace = expand('~/workspace')
  let $GOPATH = workspace
  let $CPATH = '/usr/local/include:'.workspace.'/src/github.com/facebook/rocksdb/include'
end
" }}}
