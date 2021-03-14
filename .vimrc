call plug#begin('~/.vim/plugged')
Plug 'heavenshell/vim-jsdoc'
Plug 'sebdah/vim-delve'
Plug 'mhinz/vim-startify'
Plug 'altercation/vim-colors-solarized'
Plug 'buoto/gotests-vim'
Plug 'csliu/a.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ericbn/vim-relativize'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf'
Plug 'junegunn/gv.vim'
Plug 'kien/ctrlp.vim'
Plug 'natebosch/vim-lsc'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'townk/vim-autoclose'
Plug 'Valloric/YouCompleteMe'
Plug 'airblade/vim-gitgutter'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
call plug#end()

syntax on
filetype plugin indent on

set nohls
set clipboard=unnamed

set tabstop=4 shiftwidth=4 expandtab
set backspace=indent,eol,start
set t_Co=256
set termguicolors

let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

let mapleader=","
map <C-n> :NERDTreeToggle<CR>

set nobackup
set nowritebackup
set noswapfile
set number 
set ignorecase
set smartcase

noremap <Leader>s :update<CR>

nnoremap <silent><F1> :compiler eslint<CR>\|:make %<CR>
"nnoremap <silent><F2> :Neoformat<CR>
"nnoremap <silent><F2> E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
nnoremap <silent><F3> :ALENext<CR>
nnoremap <silent><F4> :ALEPrevious<CR>
nnoremap <silent><F7> :cnext<CR>
nnoremap <silent><F8> :cprevious<CR>
nnoremap <silent><F9> :color random<CR>
nnoremap <silent><F12> :!ctags -R .<CR>

nnoremap <leader>. :CtrlPTag<cr>
nnoremap <silent> <Leader>b :TagbarToggle<CR>

nnoremap <leader>1 :set paste!<cr>

let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](doc|tmp|node_modules|public\/dist|coverage)',
            \ 'file': '\v\.(exe|so|dll)$',
            \ }

" set diffopt+=iwhite

if filereadable(".vimrc.local")
    source .vimrc.local
endif

let g:syntastic_javascript_checkers = ['eslint']

set scrolloff=7

" insert current filename
:inoremap \fn <C-R>=expand("%:t:r")<CR>

" switch buffers without save
set hidden

" vim-go
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>gd :GoDeclsDir<cr>
au FileType go nmap <F10> :GoTest -short<cr>
au FileType go nmap <F12> <Plug>(go-def)

au FileType gitcommit setlocal tw=72

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
"let g:airline#extensions#ale#enabled = 1

let g:deoplete#enable_at_startup = 1

" OmniSharp
let g:OmniSharp_selector_ui = 'ctrlp'

" fzf
set rtp+=~/.fzf

"set relativenumber

set background=dark
if has("gui_running")
    "set guifont=Hack:h15
    "set guifont=InputMonoCondensed:h16
    "set guifont=M+\ 2m\ regular:h16
    "set guifont=M+\ 1mn\ regular:h15
    "set guifont=Dank\ Mono\ Regular:h18
    "set guifont=Hermit\ Medium:h15
    "set guifont=mononoki:h16
    "set guifont=Go\ Mono:h16
    set guifont=Fira\ Code\ Retina:h15
    "set guifont=InconsolataGo:h18
    "set guifont=Menlo\ Regular:h15
    "set guifont=Hermit\ Light:h15
    "set guifont=Share-TechMono:h16
    "set guifont=IBM\ Plex\ Mono:h16
    "set guifont=Courier\ Prime:h16
    "set guifont=CamingoCode:h16
    "set guifont=PragmataPro:h18
    "set guifont=mplus-2m-regular:h18

    "set background=light
    "set background=dark

    "color brogrammer
    "color 1989
    "color solarized
    "color chance-of-storm
    "color anotherdark
    "color codeschool
    "color Monokai
    "color parsec
    "color colibri
    "color falcon
    "color afterglow
    "color nord
    "color slate
endif

colo darkZ

let g:neoformat_enabled_javascript = ['prettier']
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}

set shortmess-=F

" Use all the defaults (recommended):
let g:lsc_auto_map = v:true

" Apply the defaults with a few overrides:
let g:lsc_auto_map = {'defaults': v:true, 'FindReferences': '<leader>r'}

" Setting a value to a blank string leaves that command unmapped:
let g:lsc_auto_map = {'defaults': v:true, 'FindImplementations': ''}

" ... or set only the commands you want mapped without defaults.
" Complete default mappings are:
let g:lsc_auto_map = {
            \ 'GoToDefinition': '<C-]>',
            \ 'GoToDefinitionSplit': ['<C-W>]', '<C-W><C-]>'],
            \ 'FindReferences': 'gr',
            \ 'NextReference': '<C-n>',
            \ 'PreviousReference': '<C-p>',
            \ 'FindImplementations': 'gI',
            \ 'FindCodeActions': 'ga',
            \ 'Rename': 'gR',
            \ 'ShowHover': v:true,
            \ 'DocumentSymbol': 'go',
            \ 'WorkspaceSymbol': 'gS',
            \ 'SignatureHelp': 'gm',
            \ 'Completion': 'completefunc',
            \}

" augroup autoindent
"     au!
"     autocmd BufWritePre * :normal migg=G`i
" augroup End

highlight LineNr guifg=grey


