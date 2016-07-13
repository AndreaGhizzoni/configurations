"" ============= Basic settings
set t_Co=256 
color molokai
set tabstop=4                          " visualize tabulation as 4 spaces (still tab)
set shiftwidth=4                       " spaces instead of tabs
set softtabstop=4                      " http://goo.gl/qMsEu
set expandtab                          " these three setting are used to use 

set autoindent                         " copy the indentation of previous line
set smartindent                        " insert one indentation in C-like files

set number                             " show line numbers
set colorcolumn=80                     " draw a column at 80 character

set showmatch                          " highlight the matching parenthesis
set incsearch                          " move the cursor while searching pattern
set hlsearch                           " set highlight for searched text

set wrap                               " wrap long line of text
set linebreak                          " to re-flow long line of text instantly
set textwidth=80                       " max with of the text
set formatoptions-=l                   " http://goo.gl/RnL9DI

set spell spelllang=en,it              " docs here https://goo.gl/17dMm

" ============== Backup/Swap/Undo directory
"set backup
"set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set writebackup

" ============== Vundle
set nocompatible                       " be improved, required
filetype off                           " required for vundle
set rtp+=~/.vim/bundle/Vundle.vim      " required for vundle
call vundle#begin()

" Plug-in for vundle-plugin-manager 
Plugin 'gmarik/Vundle.vim'
" My plug-in. These are all git hub pages, for doc check there.
Plugin 'tpope/vim-fugitive'           " for git integration
Plugin 'scrooloose/syntastic'         " for syntax
Plugin 'scrooloose/nerdtree'          " for tree directory
Plugin 'bling/vim-airline'            " for bottom status bar

Plugin 'fatih/vim-go'                 " for working with go

Plugin 'xolox/vim-easytags'           " dependency for tagbar
Plugin 'xolox/vim-misc'               " dependency for tagbar
Plugin 'majutsushi/tagbar'            " for outline of current file

" NB: this plugin is disable because break syntastic error check on save
"Plugin 'Valloric/YouCompleteMe'       " for auto complete functions

Plugin 'PotatoesMaster/i3-vim-syntax' " for i3 config file syntax highlighting

call vundle#end()
filetype plugin indent on

" ============= Vim-Go
" override the default path of go binaries from $GOPATH/bin to ~/.vim/gobinaries
let g:go_bin_path = "/home/andrea/.vim/gobinaries"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
" keybind to check for errors
:noremap <F12> :GoErrCheck<CR>

" ============= Tag Bar
" Press F8 to open the Tag Window
nmap <F8> :TagbarToggle<CR>
" Enable Tag Windows to display a go file
let g:tagbar_type_go = {
    \ 'ctagstype': 'go',
    \ 'kinds' : [
        \'p:package',
        \'f:function',
        \'v:variables',
        \'t:type',
        \'c:const'
    \]
\}

" ============= Search Highlight
" Press F4 to toggle highlighting on/off, and show current value.
:noremap <F4> :set hlsearch! hlsearch?<CR>

" ============= Spell Highlight
" Press F5 to toggle highlighting on/off, and show current value.
:noremap <F5> :set spell! spelllang?<CR>

" ============= Airline
set laststatus=2                               " airline always displayed 
let g:airline#extensions#tabline#enabled = 1   " enable smart tab airline

" ============= NERDTree
map <F2> :NERDTreeToggle<CR>

" ============= GO file type
au BufRead,BufNewFile *.go set filetype=go

" ============= Syntastic 
let g:syntastic_cpp_compiler = 'g++'                  " enable c++11
let g:syntastic_cpp_compiler_options = ' -std=c++0x'  " for syntasitc
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ============= Template
autocmd BufNewFile makefile,Makefile 0r ~/.vim/skeletons/makefile
autocmd BufNewFile *.html,*.php 0r ~/.vim/skeletons/template.html
" go template is done by vim-go plugin
"autocmd BufNewFile *.go 0r ~/.vim/skeletons/template.go
autocmd BufNewFile *.c 0r ~/.vim/skeletons/template.c
autocmd BufNewFile *.C,*.cpp,*.cc 0r ~/.vim/skeletons/template.cpp
autocmd BufNewFile *.desktop 0r ~/.vim/skeletons/template.desktop
autocmd BufNewFile *.sh 0r ~/.vim/skeletons/template.sh
autocmd BufNewFile *.bash 0r ~/.vim/skeletons/template.bash
autocmd BufNewFile *.l 0r ~/.vim/skeletons/template.l
autocmd BufNewFile *.y 0r ~/.vim/skeletons/template.y
