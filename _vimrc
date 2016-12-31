" =============================================================================
" Function  VIM配置文件
" Author    huangchaowei
" Email     hcw0523beyond@163.com
" Date      2016-12-18
" Version   V1.0
" :h或者:help打开vim帮助手册，:h 插件名称打开对应插件的帮助手册
" <c-]>或者K跳转到下一个文件，<c-o>返回上一个文件
" =============================================================================

" -----------------------------------------------------------------------------
" 操作系统判断及默认配置
" -----------------------------------------------------------------------------
" 判断操作系统Windows/Linux
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" 判断是终端/Gvim
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" windows默认配置
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

" Linux默认配置
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

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

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif

" =============================================================================
" 全局mapleader
" =============================================================================
" 注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
" 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
" 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键；如要修改"<leader>"键，可以把
" 下面的设置取消注释，并修改双引号中的键为你想要的，如修改为逗号键。
" 全局leader映射
let mapleader = ","

" -----------------------------------------------------------------------------
" Vundle插件管理工具配置
" https://github.com/VundleVim/Vundle.vim
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :help vundle
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料
" -----------------------------------------------------------------------------
set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    " 旧bundle方式
    " set rtp+=~/.vim/bundle/vundle/
    " call vundle#rc()
    " 新bundle方式
    set rtp+=~/.vim/bundle/vundle/
    call vundle#begin('~/.vim/bundle/')
else
    " 旧bundle方式
    " set rtp+=$VIM/vimfiles/bundle/vundle/
    " call vundle#rc('$VIM/vimfiles/bundle/')
    " 新bundle方式
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#begin('$VIM/vimfiles/bundle/')
endif

" 使用Vundle来管理插件，这个必须要有。新方式将bundle替换为plugin
Plugin 'gmarik/vundle'
" 括号自动补全
Plugin 'jiangmiao/auto-pairs'
" 主要功能是对文件以及buffer进行模糊查询，快速打开文件。
Plugin 'ctrlpvim/ctrlp.vim'
" zendcoding 的升级插件，实现html和css代码的快速编写
Plugin 'mattn/emmet-vim'
" 缩进提示线
Plugin 'Yggdroot/indentLine'
" 主要功能是进行代码补全
Plugin 'Shougo/neocomplcache.vim'
" 主要功能是进行代码注释
Plugin 'scrooloose/nerdcommenter'
" 主要功能是一款文件浏览器，可以查看文件目录结构打开相应的文件。
Plugin 'scrooloose/nerdtree'
" 新插件，替换powerline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" 括号匹配
Plugin 'tpope/vim-surround'
" 语法检测
Plugin 'scrooloose/syntastic'
" 变量查看器
Plugin 'majutsushi/tagbar'
" 文本浏览，<leader>g打开链接地址，<leader>f翻译单词，<leader>s打开浏览器搜索
Plugin 'TxtBrowser'
" 快速跳转
Plugin 'Lokaltog/vim-easymotion'
" 主题
Plugin 'altercation/vim-colors-solarized'
" 多行选择
Plugin 'terryma/vim-multiple-cursors'
" 新方式
call vundle#end()

" 安装插件
nnoremap <leader>bi :PluginInstall <cr>
" 更新插件
nnoremap <leader>bu :PluginUpdate <cr>
" 卸载插件
nnoremap <leader>bc :PluginClean <cr>

" -----------------------------------------------------------------------------
" 编码配置
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型
" 默认设置帮助手册为英文，在vimfiles/plugin/vimcdoc.vim中设置默认的帮助手册方式
" set helplang=en

if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/delmenu.vim                    "解决菜单乱码
    source $VIMRUNTIME/menu.vim                       "解决consle输出乱码
    language messages zh_CN.utf-8
endif
" 设置帮助手册为中文（默认）
nnoremap <leader>hc :set helplang=cn <cr>
nnoremap <leader>he :set helplang=en <cr>

" -----------------------------------------------------------------------------
" 编写文件时的配置
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
set foldenable                                        "启用折叠
set foldmethod=indent                                 "indent 折叠方式
" set foldmethod=marker                                "marker 折叠方式
set autoread                                          " 当文件在外部被修改，自动更新该文件
set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1) " 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉

" -----------------------------------------------------------------------------
" 界面配置
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=2                                       "设置命令行的高度为2，默认为1
set cursorline                                        "突出显示当前行
" set guifont=YaHei_Consolas_Hybrid:h10                 "设置字体:字号（字体名称空格用下划线代替）
set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面
" set conceallevel=0                                    " 隐藏字符原样显示
" 隐藏字符原样显示
nnoremap <leader>hh :set conceallevel=0 <cr>

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x                           "窗口启动时自动最大化
    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
endif

" 设置代码配色方案
if g:isGUI
    " colorscheme solarized                 "Gvim配色方案
    colorscheme Tomorrow-Night-Bright                 "Gvim配色方案
    " colorscheme Tomorrow-Night-Eighties               "终端配色方案
    " colorscheme darkburn               "终端配色方案
    " colorscheme desert_terminal              "终端配色方案
else
    colorscheme Tomorrow-Night-Eighties               "终端配色方案
endif
" 主题插件，存放于vimfiles/colors目录
"colorscheme molokai

" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
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
" 其它配置
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
set noswapfile                              "设置无临时文件
set noundofile                              " 不保存零时文件
" set vb t_vb=                                "关闭提示音
" 自动切换目录为当前编辑文件所在目录
au BufRead,BufNewFile,BufEnter * cd %:p:h

" -----------------------------------------------------------------------------
" auto-pairs 插件配
" git://github.com/jiangmiao/auto-pairs.git
" 该插件<c-h>键映射不太科学，找到vimfiles/auto-pairs/plugin/auto-pairs.vim修改该映射
" -----------------------------------------------------------------------------
" 用于括号与引号自动补全，不过会与函数原型提示插件echofunc冲突
" 所以我就没有加入echofunc插件

" -----------------------------------------------------------------------------
" ctrlp.vim 插件配置
" https://github.com/kien/ctrlp.vim
" -----------------------------------------------------------------------------
" 一个全路径模糊文件，缓冲区，最近最多使用，... 检索插件；详细帮助见 :h ctrlp
" 常规模式下输入：Ctrl + p 调用插件

" -----------------------------------------------------------------------------
" emmet-vim（前身为Zen coding） 插件配置
" https://github.com/mattn/emmet-vim
" -----------------------------------------------------------------------------
" HTML/CSS代码快速编写神器，默认为<c-y>,详细帮助见 :h emmet.txt

" -----------------------------------------------------------------------------
" indentLine 插件配置
" https://github.com/Yggdroot/indentLine
" -----------------------------------------------------------------------------
" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
" 开启/关闭对齐线
" 关闭
" let g:indentLine_enabled = 0
nnoremap <leader>il :IndentLinesToggle<CR>
" 设置Gvim的对齐线样式
if g:isGUI
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "|"
endif
" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色vim
" let g:indentLine_color_term = 239
" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色gvim
" let g:indentLine_color_gui = '#A4E57E'

" -----------------------------------------------------------------------------
" neocomplcache 插件配置
" https://github.com/Shougo/neocomplcache.vim
" -----------------------------------------------------------------------------
" 关键字补全、文件路径补全、tag补全等等，各种，非常好用，速度超快。
let g:neocomplcache_enable_at_startup = 1     "vim 启动时启用插件
" let g:neocomplcache_disable_auto_complete = 1 "不自动弹出补全列表
" 在弹出补全列表后用 <c-p> 或 <c-n> 进行上下选择效果比较好

" -----------------------------------------------------------------------------
" nerdcommenter 插件配置
" https://github.com/scrooloose/nerdcommenter
" -----------------------------------------------------------------------------
" 我主要用于C/C++代码注释(其它的也行)
" 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
" <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
" <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
" <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
" <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
" <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
" <Leader>cA 行尾注释
let g:NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格
let g:NERDCustomDelimiters = {'html':{'left':'<!--','right':'-->'}}
" 公司smarty注释格式，其它地方可取消
let g:NERDCustomDelimiters = {'smarty':{'left':'{%*','right':'*%}'}}
let g:NERDCustomDelimiters = {'htm':{'left':'<!--','right':'-->'}}

" -----------------------------------------------------------------------------
" nerdtree 插件配置
" https://github.com/scrooloose/nerdtree
" 该插件映射键CD导致进入目录时出现卡顿，找到插件的源代码(vimfiles/bundle/nerdtree/plugin/NERD_tree.vim)，修改相关API
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件
" 常规模式下调用插件
nnoremap to :NERDTreeToggle<cr>

" -----------------------------------------------------------------------------
" air-line 插件配置
" https://github.com/vim-airline/vim-airline
" -----------------------------------------------------------------------------
" 状态栏插件，更好的状态栏效果
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_section_y = '%{strftime("%Y-%m-%d %H:%M %A")}'
let g:airline_theme='powerlineish'

" -----------------------------------------------------------------------------
" surround 插件配置
" https://github.com/tpope/vim-surround
" -----------------------------------------------------------------------------
" 快速给单词/句子两边增加符号（包括html标签），缺点是不能用"."来重复命令
" 不过 repeat 插件可以解决这个问题，详细帮助见 :h surround.txt

" -----------------------------------------------------------------------------
" Syntastic 插件配置
" https://github.com/vim-syntastic/syntastic
" -----------------------------------------------------------------------------
" 用于保存文件时查检语法
" -----------------------------------------------------------------------------

" Tagbar 插件配置
" http://www.vim.org/scripts/script.php?script_id=2627
" -----------------------------------------------------------------------------
" 相对 TagList 能更好的支持面向对象
" 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
"nnoremap tb :TlistClose<CR>:TagbarToggle<CR>
nnoremap tb :TagbarToggle<CR>
let g:tagbar_width=30                       "设置窗口宽度
" let g:tagbar_left=1                         "在左侧窗口中显示

" -----------------------------------------------------------------------------
" txtbrowser 插件配置
" https://github.com/vim-scripts/TxtBrowser
" 该插件搜索单词翻译时出现错误，找到插件的源代码(vimfiles/bundle/TxtBrowser/plugin/txtbrowser.vim)，修改对应搜索引擎
" -----------------------------------------------------------------------------
" 用于文本文件生成标签与与语法高亮（调用TagList插件生成标签，如果可以）
au BufRead,BufNewFile *.txt setlocal ft=txt

" -----------------------------------------------------------------------------
" ctags 工具配置
" window gvim下需要把ctags.exe拷贝到对应vim目录
" -----------------------------------------------------------------------------
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
set tags=./tags;                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）

" -----------------------------------------------------------------------------
" gvimfullscreen 工具配置 请确保已安装了工具 gvimfullscreen.dll 存放在vim80目录中
" -----------------------------------------------------------------------------
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
    nnoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" -----------------------------------------------------------------------------
" vimtweak 工具配置 请确保以已装了工具 vimtweak.dll 存放在vim80目录中
" -----------------------------------------------------------------------------
" 这里只用于窗口透明与置顶
" 常规模式下 Ctrl + Up（上方向键） 增加不透明度，Ctrl + Down（下方向键） 减少不透明度，<Leader>t 窗口置顶与否切换
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

    "快捷键设置
    nnoremap <c-up> :call Alpha_add()<CR>
    nnoremap <c-down> :call Alpha_sub()<CR>
    nnoremap <leader>t :call Top_window()<CR>
endif

" =============================================================================
" easymotion快速跳转
" https://github.com/easymotion/vim-easymotion
" =============================================================================

" =============================================================================
" mutiple-cursor
" https://github.com/terryma/vim-multiple-cursors
" =============================================================================
" 多行选择

" 创建文件时，检测文件类型，并增加注释，可关闭影响性能
autocmd BufNewFile *.sh,*.py,*.html,*.java,*.php exec ":call s:insertHead()"
" 定义函数insertHead，自动插入文件头
function s:insertHead()
    if expand("%:e") == 'sh'
        call s:shellFile()
    endif
endfunction

" shell 脚本
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
" 键盘映射
" =============================================================================
" 保存
nnoremap w :w <cr>
" 退出
nnoremap q :q! <cr>
" 返回普通模式
noremap! <leader>e <esc>
noremap <leader>e <esc>
snoremap <leader>e <esc>
" 粘贴模式
" nnoremap <leader>p :set paste <cr>
" inoremap <leader>p :set paste <cr>
" 普通模式
" nnoremap <leader>po :set nopaste <cr>
" inoremap <leader>po :set nopaste <cr>
" 快速进入命令模式
nnoremap ; :
" 盘符切换
nnoremap <leader>jc :NERDTree c:\\ <cr>
nnoremap <leader>jd :NERDTree d:\\ <cr>
nnoremap <leader>je :NERDTree e:\\ <cr>
nnoremap <leader>jf :NERDTree f:\\ <cr>
nnoremap <leader>jg :NERDTree g:\\ <cr>
nnoremap <leader>jx :NERDTree x:\\ <cr>
nnoremap <leader>jy :NERDTree y:\\ <cr>
nnoremap <leader>jz :NERDTree z:\\ <cr>
" 运行php代码
nnoremap <leader>rp :!php % <cr>
" 正常模式下 alt+j,k,h,l 调整分割窗口大小
nnoremap <m-j> :resize +5<cr>
nnoremap <m-k> :resize -5<cr>
nnoremap <m-h> :vertical resize -5<cr>
nnoremap <m-l> :vertical resize +5<cr>
" 新建
nnoremap fo :tabnew <cr>
" 前一个
nnoremap fp :tabp <cr>
" 后一个
nnoremap fn :tabn <cr>
" 查看所有
nnoremap fs :tabs <cr>
" 关闭当前
nnoremap ff :tabc <cr>
" 关闭所有
nnoremap fa :tabo <cr>
" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" Ctrl + K 插入模式下光标向上移动
inoremap <c-k> <Up>
" Ctrl + J 插入模式下光标向下移动
inoremap <c-j> <Down>
" Ctrl + H 插入模式下光标向左移动
inoremap <c-h> <Left>
" Ctrl + L 插入模式下光标向右移动
inoremap <c-l> <Right>
" 切换到上下左右‘最顶上、最底下的窗口中
inoremap fk <esc><c-w>k
inoremap fj <esc><c-w>j
inoremap fh <esc><c-w>h
inoremap fl <esc><c-w>l
inoremap ft <esc><c-w>t
inoremap fb <esc><c-w>b
nnoremap fk <c-w>k
nnoremap fj <c-w>j
nnoremap fh <c-w>h
nnoremap fl <c-w>l
nnoremap ft <c-w>t
nnoremap fb <c-w>b
" 将窗口固定到上下左右任意方向
nnoremap fK <c-w>K
nnoremap fJ <c-w>J
nnoremap fH <c-w>H
nnoremap fL <c-w>L
" 行首
nnoremap <leader>a <home>
inoremap <leader>a <home>
" 行尾
nnoremap <leader>n <end>
inoremap <leader>n <end>
" 移动一个单词
inoremap <m-l> <c-right>
inoremap <m-h> <c-left>
" 上一行插入内容
inoremap <c-o> <esc>O
" 下行插入内容
inoremap <c-d> <esc>o
" 删除光标前一个字符
inoremap <c-f> <bs>
" 删除光标后一个字符
inoremap <c-b> <del>
" 删除光标后一个单词，删除光标前一个单词，默认<c-w>
inoremap <c-e> <esc>lcw
" 删除光标后的所有字符到行尾，删除至行首默认为<c-u>
inoremap <leader>da <esc>lC
" 删除光标所在行所有字符
inoremap <leader>dd <esc>cc
" 大小写转换
inoremap <leader>dc <esc>l<s-~>i
" 复制光标下的单词
inoremap <leader>cw <esc>lye
" 复制光标下的内容至行首
inoremap <leader>ck <esc>ly<s-^>
" 复制光标下的内容至行末
inoremap <leader>cj <esc>ly<s-$>
" 粘贴复制的内容在光标前
inoremap <leader>pk <esc>lP
" 粘贴复制的内容在光标后
inoremap <leader>pk <esc>lp
" 垂直/水平分割当前文件
noremap <leader>vs :split <cr>
noremap! <leader>vs :split <cr>
noremap <leader>vv :vsplit <cr>
noremap! <leader>vv :vsplit <cr>
" 返回撤销
noremap fu <c-r>
noremap! fu <c-r>
