" =============================================================================
" Function  VIM configuration
" Author    huangchaowei
" Email     hcw0523beyond@163.com
" Date      2016-12-18
" Version   V1.0
" :h or :help for open vim manual，:h plugin name for open plugin manual
" <c-]> or K jump to the next file，<c-o> back to the prev file
" :script 查看加载的脚本文件
" :X 加密文件
" =============================================================================

" Windows/Linux
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" Console/Gvim
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" windows default configuration
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" Linux  default configuration
if g:islinux
    " highlight search
    set hlsearch
    " real time matching search
    set incsearch

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        " enable mouse under any mode
        set mouse=a
        " enable 256 color under consoele
        set t_Co=256
        " enable backspace key
        set backspace=2

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif

" global mapleader
" for example <leader>tc ==> ,tc
let mapleader = ","

" -----------------------------------------------------------------------------
" https://github.com/VundleVim/Vundle.vim
" -----------------------------------------------------------------------------
" disable vi compatible mode
set nocompatible
" disable check file type
filetype off

if g:islinux
    set rtp+=~/.vim/bundle/vundle/
    call vundle#begin('~/.vim/bundle/')
else
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#begin('$VIM/vimfiles/bundle/')
endif

" use Vundle for manag plugin。
Plugin 'gmarik/vundle'
Plugin 'jiangmiao/auto-pairs'
" fuzzy query document and buffer, then fast open the file
Plugin 'ctrlpvim/ctrlp.vim'
" zendcoding fast write html and css
Plugin 'mattn/emmet-vim'
" show indent line
" Plugin 'Yggdroot/indentLine'
" code completion
Plugin 'Shougo/neocomplcache.vim'
" code annotation
Plugin 'scrooloose/nerdcommenter'
" file tree
Plugin 'scrooloose/nerdtree'
" bottom line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Plugin 'tpope/vim-surround'
" check syntax
" Plugin 'scrooloose/syntastic'
" show parameter
" Plugin 'majutsushi/tagbar'
" txt browser
Plugin 'TxtBrowser'
" fast jump
Plugin 'Lokaltog/vim-easymotion'
Plugin 'altercation/vim-colors-solarized'
" mutiple select
Plugin 'terryma/vim-multiple-cursors'
call vundle#end()

" -----------------------------------------------------------------------------
" coding
" -----------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1
set fileformat=unix
set fileformats=unix,dos,mac
if (g:iswindows && g:isGUI)
    " to solve the menu code
    source $VIMRUNTIME/delmenu.vim
    " to solve the console code
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
endif

" -----------------------------------------------------------------------------
" document writing
" -----------------------------------------------------------------------------
filetype on
" load plugin according to file type
filetype plugin on
" open indent
filetype plugin indent on
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
set foldenable
set foldmethod=indent
set autoread
set ignorecase
set smartcase
" limit each line width under 80
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" -----------------------------------------------------------------------------
" interface
" -----------------------------------------------------------------------------
set number
" open status line
set laststatus=2
set cmdheight=2
" highlight current line
set cursorline
set nowrap
" hide welcome messages
set shortmess=atI
" set gui windows size
if g:isGUI
    " max windows
    au GUIEnter * simalt ~x
    " winpos 100 10
    " set lines=38 columns=120
endif
" color theme
if g:isGUI
    " colorscheme solarized
    colorscheme Tomorrow-Night-Bright
    " colorscheme Tomorrow-Night-Eighties
    " colorscheme darkburn
    " colorscheme desert_terminal
else
    colorscheme Tomorrow-Night-Eighties
endif
" show/hide toolbar
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nnoremap <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

" -----------------------------------------------------------------------------
" other
" -----------------------------------------------------------------------------
set writebackup
set nobackup
set noswapfile
set noundofile
" enter current edit file path
au BufRead,BufNewFile,BufEnter * cd %:p:h

" -----------------------------------------------------------------------------
" https://github.com/jiangmiao/auto-pairs.git
" modify <c-h> map
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" https://github.com/kien/ctrlp.vim
" <c-p> use this plugin
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" https://github.com/mattn/emmet-vim
" <c-y>, use this plugin
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" https://github.com/Yggdroot/indentLine
" -----------------------------------------------------------------------------
" open/close
" let g:indentLine_enabled = 0
" nnoremap <leader>il :IndentLinesToggle<CR>
" if g:isGUI
    " let g:indentLine_char = "┊"
    " let g:indentLine_first_char = "|"
" endif

" -----------------------------------------------------------------------------
" https://github.com/Shougo/neocomplcache.vim
" <c-n> next <c-p> prev
" -----------------------------------------------------------------------------
" open/close
let g:neocomplcache_enable_at_startup = 1

" -----------------------------------------------------------------------------
" https://github.com/scrooloose/nerdcommenter
" -----------------------------------------------------------------------------
" a space is left before right
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {'html':{'left':'<!--','right':'-->'}}
let g:NERDCustomDelimiters = {'smarty':{'left':'{%*','right':'*%}'}}
let g:NERDCustomDelimiters = {'htm':{'left':'<!--','right':'-->'}}

" -----------------------------------------------------------------------------
" https://github.com/scrooloose/nerdtree
" modify CD map
" -----------------------------------------------------------------------------
nnoremap <leader>l :NERDTreeToggle<cr>

" -----------------------------------------------------------------------------
" https://github.com/vim-airline/vim-airline
" -----------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_section_y = '%{strftime("%Y-%m-%d %H:%M %A")}'
let g:airline_theme='powerlineish'

" -----------------------------------------------------------------------------
" https://github.com/tpope/vim-surround
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" https://github.com/vim-syntastic/syntastic
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" http://www.vim.org/scripts/script.php?script_id=2627
" -----------------------------------------------------------------------------
" close taglist then show tagbar
" nnoremap tb :TlistClose<CR>:TagbarToggle<CR>
" nnoremap tb :TagbarToggle<CR>
" let g:tagbar_width=30
" let g:tagbar_left=1

" -----------------------------------------------------------------------------
" https://github.com/vim-scripts/TxtBrowser
" <leader>g open link，<leader>f translate, <leader>s search
" -----------------------------------------------------------------------------
" au BufRead,BufNewFile *.txt setlocal ft=txt

" -----------------------------------------------------------------------------
" window gvim copy ctags.exe to vim dictory
" -----------------------------------------------------------------------------
" set tags=./tags;

" -----------------------------------------------------------------------------
" gvimfullscreen gvimfullscreen.dll on vim80 dictory
" -----------------------------------------------------------------------------
" full window
if (g:iswindows && g:isGUI)
    nnoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" -----------------------------------------------------------------------------
" vimtweak vimtweak.dll on vim80 dictory
" -----------------------------------------------------------------------------
" <c-up> increace opacity, <c-down> reduce opacity
if (g:iswindows && g:isGUI)
    let g:Current_Alpha = 255
    let g:Top_Most = 0
    func! Alpha_add()
        let g:Current_Alpha = g:Current_Alpha + 10
        if g:Current_Alpha > 255
            let g:Current_Alpha = 255
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Alpha_sub()
        let g:Current_Alpha = g:Current_Alpha - 10
        if g:Current_Alpha < 155
            let g:Current_Alpha = 155
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Top_window()
        if  g:Top_Most == 0
            call libcallnr("vimtweak.dll","EnableTopMost",1)
            let g:Top_Most = 1
        else
            call libcallnr("vimtweak.dll","EnableTopMost",0)
            let g:Top_Most = 0
        endif
    endfunc

    nnoremap <c-up> :call Alpha_add()<CR>
    nnoremap <c-down> :call Alpha_sub()<CR>
    nnoremap <leader>wi :call Top_window()<CR>
endif

" =============================================================================
" https://github.com/easymotion/vim-easymotion
" :h easymotion <leader><leader>j down <leader><leader>k up <leader><leader>w word prev <leader><leader>b word back
" =============================================================================

" =============================================================================
" https://github.com/terryma/vim-multiple-cursors
" =============================================================================

" autocmd BufNewFile *.sh,*.py,*.html,*.java,*.php exec ":call s:insertHead()"
function s:insertHead()
    if expand("%:e") == 'sh'
        call s:shellFile()
    endif
endfunction

" shell
function s:shellFile()
     call setline(1, "#===============================================================")
     call setline(2, "# Copyright (C) ".strftime("%Y")." All rights reserved.")
     call setline(3, "# FileName:   ".expand("%"))
     call setline(4, "# Description: ")
     call setline(5, "# Author:     huangchaowei")
     call setline(6, "# Email:      huangchaowei@zbj.com")
     call setline(7, "# Date:       ".strftime("%Y-%m-%d %H:%M:%S"))
     call setline(8, "# Version:    v1.0")
     call setline(9, "# Modify:    ")
     call setline(10, "#===============================================================")
     call setline(11,"# The enviroment of the bash ")
     call setline(12,"#!/bin/bash")
 endfunction

" =============================================================================
" Key map
" =============================================================================
" install plugin
" nnoremap <leader>bi :PluginInstall <cr>
" update plugin
" nnoremap <leader>bu :PluginUpdate <cr>
" uninstall plugin
" nnoremap <leader>bc :PluginClean <cr>
" Save
nnoremap w :w <cr>
" Quit
nnoremap q :q! <cr>
" Return to normal mode.
noremap! <leader>e <esc>
noremap <leader>e <esc>
snoremap <leader>e <esc>
" Change normal mode to paste mode.
" nnoremap <leader>p :set paste <cr>
" inoremap <leader>p :set paste <cr>
" Change paster mode to normal mode.
" nnoremap <leader>po :set nopaste <cr>
" inoremap <leader>po :set nopaste <cr>
" Enter command mode.
nnoremap ; :
" Change disk.
nnoremap <leader>jc :NERDTree c:\\ <cr>
nnoremap <leader>jd :NERDTree d:\\ <cr>
nnoremap <leader>je :NERDTree e:\\ <cr>
nnoremap <leader>jf :NERDTree f:\\ <cr>
nnoremap <leader>jg :NERDTree g:\\ <cr>
nnoremap <leader>jx :NERDTree x:\\ <cr>
nnoremap <leader>jy :NERDTree y:\\ <cr>
nnoremap <leader>jz :NERDTree z:\\ <cr>
" Run php code. 
" nnoremap <leader>rp :!php % <cr>
" alt+j,k,h,l Resize the window size.
nnoremap <m-j> :resize +5<cr>
nnoremap <m-k> :resize -5<cr>
nnoremap <m-h> :vertical resize -5<cr>
nnoremap <m-l> :vertical resize +5<cr>
" New tab.
nnoremap tn :tabnew <cr>
" Go next tab.
nnoremap tp :tabp <cr>
" Go prev tab.
nnoremap te :tabn <cr>
" See all tabs.
nnoremap ts :tabs <cr>
" Close current tab.
nnoremap tc :tabc <cr>
" Close all tab.
nnoremap to :tabo <cr>
" Open/close indent.
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" Move up.
inoremap <c-k> <Up>
" Move down.
inoremap <c-j> <Down>
" Move left.
inoremap <c-h> <Left>
" Move right.
inoremap <c-l> <Right>
" Switch windows.
inoremap gk <esc><c-w>k
inoremap gj <esc><c-w>j
inoremap gh <esc><c-w>h
inoremap gl <esc><c-w>l
inoremap gt <esc><c-w>t
inoremap gb <esc><c-w>b
nnoremap gk <c-w>k
nnoremap gj <c-w>j
nnoremap gh <c-w>h
nnoremap gl <c-w>l
nnoremap gt <c-w>t
nnoremap gb <c-w>b
" Change window direction.
nnoremap ga <c-w>K
nnoremap gc <c-w>J
nnoremap gd <c-w>H
nnoremap ge <c-w>L
" Top of the line.
nnoremap <leader>a <home>
inoremap <leader>a <home>
" End of the line.
nnoremap <leader>n <end>
inoremap <leader>n <end>
" Move a word.
inoremap <m-l> <c-right>
inoremap <m-h> <c-left>
" Insert content in the last line.
inoremap <c-o> <esc>O
" Insert content in the next line.
inoremap <c-d> <esc>o
" delete chart before cursor
inoremap <c-f> <bs>
" delete chart after cursor
inoremap <c-b> <del>
" delete one word after cursor, <c-w> delete one word before cursor
inoremap <c-e> <esc>lcw
" delete all char begin current cursor to end, <c-u> delete all char begin cursor to start
inoremap <leader>da <esc>lC
" delete current line all char
inoremap <leader>dd <esc>cc
" toggle lower to upper
" inoremap <leader>dc <esc>l<s-~>i
" copy current cursor word
inoremap <leader>cw <esc>lye
" copy current cursor to start
inoremap <leader>ck <esc>ly<s-^>
" copy current cursor to end
inoremap <leader>cj <esc>ly<s-$>
" paste msg before current cursor
inoremap <leader>pk <esc>p
" split/vsplit current file
noremap <silent><leader>vs :split <cr>
noremap! <silent><leader>vs :split <cr>
noremap <silent><leader>vv :vsplit <cr>
noremap! <silent><leader>vv :vsplit <cr>
" set help manual language
nnoremap <silent><leader>hc :set helplang=cn <cr>
nnoremap <silent><leader>he :set helplang=en <cr>
" hide word type
" nnoremap <leader>hh :set conceallevel=0 <cr>
" Restore operation.
noremap <leader>rr <c-r>
noremap! <leader>rr <c-r>
" count file information
" noremap <leader>fi g<c-g>
" clear search highlight
noremap <leader>jr :nohls <cr>
" increase the indent
noremap <leader>di <s->>
" decrease the indent
noremap <leader>de <s-<>
