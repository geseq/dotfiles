" Enable syntax highlighting
syntax on
colo pablo
set colorcolumn=80,100
highlight ColorColumn ctermbg=7

" Start
set nocompatible
" Add line numbers
set number
" Disable line wrap
set nowrap
" Enhance command-line completion
set wildmenu
" Hide unsaved changes instead of closing them
set hidden
" Allow backspace to delete indentation and inserted text
" i.e. how it works in most programs
set backspace=indent,eol,start
" indent  allow backspacing over autoindent
" eol     allow backspacing over line breaks (join lines)
" start   allow backspacing over the start of insert; CTRL-W and CTRL-U
"        stop once at the start of insert.

set ttyfast
" Flash screen instead of beep sound
set visualbell
" Change how vim represents characters on the screen
set encoding=utf-8 nobomb
" Set the encoding of files written
set fileencoding=utf-8
" Set file format
set ffs=unix,dos,mac

" Highlight current line
set cursorline
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd

" Split below and to the right by default
set splitbelow
set splitright

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Automatically :write before running commands
set autowrite

" No backups or swap
set nobackup
set nowritebackup
set nowb
set noswapfile

" Large undo history
set undolevels=1000
" Centralize undo history
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undos


" Update find path to search subdirectories
set path=$PWD/**

" Set leader to dot(.)
let mapleader = " "

" Remap hjkl to jkl;
" noremap ; l
" noremap l k
" noremap k j
" noremap j h
noremap s h
noremap , j

" Window movement with Ctrl+(hjkl)
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-s> <C-w>h
nnoremap <C-l> <C-w>l
" <C-,> won't work due to https://vimhelp.org/vim_faq.txt.html#faq-20.5

nnoremap bj 10<c-d>
nnoremap bk 10<c-u>

" Look for files with FZF on ff
nnoremap <silent> <C-p> :Files<CR>
map <silent> <leader>sf :Files<CR>
" Look for gitfiles with fg
map <silent> <leader>sg :GFiles<CR>
" Show buffers with lb
map <silent> <leader>lb :Buffers<CR>
" Show tags with lt
map <silent> <leader>lt :Tags<CR>
" Search all file contents with  ripgrep on Ctrl+g
nnoremap <silent> <C-g> :Rg<CR>
map <silent> <leader>fa :Rg<CR>
" Search within file with FZF on Ctrl+f
nnoremap <silent> <C-f> :BLines<CR>
map <silent> <leader>fs :BLines<CR>
" Open buffer list ready to fill in on <space>b
nnoremap <Leader>b :ls<Cr>:b<Space>
" Remap escape to qq and <leader>e
inoremap qq <Esc>
inoremap <Leader>e <Esc>

" Open Netrw for file browsing with dash(-)
nnoremap <silent> - :Explore<CR>

if has('unix')
    vmap <silent> <leader>cc "+y
elseif has('macunix')
    vmap <silent> <leader>cc "*y
endif

" Tab sanity
set expandtab
set tabstop=4
set shiftwidth=4

" Show hidden characters, tabs, trailing whitespace
set list
set listchars=tab:→\ ,trail:·,nbsp:·

" Different tab/space stops"
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype css setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype scss setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
autocmd FileType make setlocal noexpandtab
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype tf setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype js setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab

au FileType go nmap <leader>gd <Plug>(go-def-vertical)

" Hardcore mode, disable arrow keys.
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

filetype plugin indent on

" Netrw
"

" Set treeview as default
let g:netrw_liststyle = 3

" Sort fix from https://github.com/tpope/vim-vinegar
function! s:sort_sequence(suffixes) abort
    return '[\/]$,*' . (empty(a:suffixes) ? '' : ',\%(' .
                \ join(map(split(a:suffixes, ','), 'escape(v:val, ".*$~")'), '\|') . '\)[*@]\=$')
endfunction
let g:netrw_sort_sequence = s:sort_sequence(&suffixes)


" --------------- PLUGIN CONFIG ---------------

" Don't search file names with rg
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)


" Mucomplete
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
let g:mucomplete#enable_auto_at_startup = 1



" Languageclient-neovim
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)


" Colorscheme
set t_Co=256
set background=dark
colorscheme PaperColor
highlight ColorColumn ctermbg=238 guibg=#232728

" GO
"

" go-vim plugin specific commands
" Also run `goimports` on your current file on every save
" Might be be slow on large codebases, if so, just comment it out
let g:go_fmt_command = "goimports"

" Status line types/signatures.
let g:go_auto_type_info = 1

autocmd Filetype go inoremap <buffer> . .<C-x><C-o>

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Launch gopls when Go files are in use
let g:LanguageClient_serverCommands = {
            \ 'go': ['gopls']
            \ }

" If you want to disable gofmt on save
" let g:go_fmt_autosave = 0


" TF
"
let g:terraform_align=1
let g:terraform_fmt_on_save=1



" air-line plugin specific commands
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'



" FZF
"

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let g:fzf_action = {
            \ 'ctrl-q': function('s:build_quickfix_list'),
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Show fzf at the bottom
let g:fzf_layout = { 'down': '~30%' }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

if has('unix')
    source ~/.fzf/plugin/fzf.vim
elseif has('macunix')
    set rtp+=/usr/local/opt/fzf
endif



" Autoformat
let g:python3_host_prog='/usr/bin/python3'
noremap <Leader>af :Autoformat<CR>
au BufWrite * silent! :Autoformat
let g:formatdef_autopep8 = "'autopep8 - --max-line-length 180 --range '.a:firstline.' '.a:lastline"

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
