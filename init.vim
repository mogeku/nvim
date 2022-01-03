" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|

" Author: @momo




" ===
" === Set global var for different system
" ===
if !exists("g:os")
	if has("win64") || has("win32") || has("win16")
		let g:os = "win"
	else
		let g:os = substitute(system('uname'), '\n', '', '')
	endif
endif

if has("win64") || has("win32") || has("win16")
	let $NVIM_HOME = $HOME.'/AppData/Local/nvim'
else
	let $NVIM_HOME = $HOME.'/.config/nvim'
endif

" ===
" === Auto load for first time uses
" ===
if empty(glob($NVIM_HOME.'/autoload/plug.vim'))
	if g:os == "win"
		silent !curl -fLo AppData/Local/nvim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	else
		silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	endif
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.vim/plugged/wildfire.vim/autoload/wildfire.vim'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ===
" === Create a _machine_specific.vim file to adjust machine specific stuff, like python interpreter location
" ===
let has_machine_specific_file = 1
if empty(glob($NVIM_HOME.'/_machine_specific.vim'))
	let has_machine_specific_file = 0
	silent! exec "!cp ".$NVIM_HOME."/default_configs/_machine_specific_default.vim ".$NVIM_HOME."/_machine_specific.vim"
endif
source $NVIM_HOME/_machine_specific.vim


" ===
" === System
" ===
"set clipboard=unnamedplus
if g:os == "win"
	set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
endif
let &t_ut=''	"矫正终端部分配色
set autochdir   "自动切换目录为当前目录

set re=0

" experimental
set lazyredraw "性能考虑, 避免不必要的重绘
"set regexpengine=1

set cmdheight=2
"set shortmess=a

" ===
" === Editor behavior
" ===
filetype on	"侦测文件类型
filetype indent on
filetype plugin on	"载入文件类型插件
filetype plugin indent on "开启文件类型检查，并且载入与该类型对应的缩进规则。比如，如果编辑的是.py文件，Vim 就是会找 Python 的缩进规则~/.vim/indent/python.vim。

set modifiable "设置可修改
set noswapfile "关闭swap交换文件

"set mouse=a "启用鼠标
set nocompatible	"不与Vi兼容(采用Vim自己的操作指令)
syntax on	"开启智能语义高亮
set nocursorcolumn	"不要高亮显示当前列
set cursorline	"高亮显示当前行
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
set nu		"显示行号
set rnu		"显示相对行号
set showcmd	"输入的命令
set wildmenu	"命令行模式下开启Tab自动补全功能
set wildmode=full:list   " Better command line completion
set wrap	"过长的行自动分成几行显示
set timeoutlen=400	"设置两个键直接的等待延迟
set autochdir   "自动切换目录为当前目录
set virtualedit=block,onemore   "允许光标出现在最后一个字符的后面
set viewoptions=cursor,folds,slash,unix

"搜索相关设置
set hlsearch	"高亮显示搜索项
set incsearch	"搜索时进行实时搜索, 每输入一个字符就进行匹配
set ignorecase	"搜索时忽略大小写
set smartcase	"搜索时若有大写则严格匹配大写, 否则忽略大小写
"每次进入Vim清空上一次的高亮搜索"
exec "nohlsearch"

"文字处理相关设置
set expandtab   "使用空格来替换Tab
set tabstop=4   "设置所有的Tab和缩进为4个空格
set shiftwidth=4    "设定<<和>>命令移动时的宽度为4
set softtabstop=4   "使得按退格键时可以一次删除4个空格
set scrolloff=5    "光标移动到buffer的顶部和底部时保持5行距离
set textwidth=0 "关闭输入文字时, 超过其值后输入空格自动换行
set indentexpr=
set backspace=indent,eol,start  "让退格键可以删除 indent(缩进), eol(行首, 合并两行), start(删除此次插入前的输入)

"保存上次编辑时的 undo
if g:os == "win"
	silent !mkdir -p \%USERPROFILE\%\AppData\Local\nvim\tmp\backup
	silent !mkdir -p \%USERPROFILE\%\AppData\Local\nvim\tmp\undo
	"silent !mkdir -p \%USERPROFILE\%\AppData\Local\nvim\tmp\sessions
	set backupdir=$NVIM_HOME\tmp\backup,.
	set directory=$NVIM_HOME\tmp\backup,.
	if has('persistent_undo')
		set undofile
		set undodir=$NVIM_HOME\tmp\undo,.
	endif
else
	silent !mkdir -p $HOME/.config/nvim/tmp/backup
	silent !mkdir -p $HOME/.config/nvim/tmp/undo
	"silent !mkdir -p $HOME/.config/nvim/tmp/sessions
	set backupdir=$HOME/.config/nvim/tmp/backup,.
	set directory=$HOME/.config/nvim/tmp/backup,.
	if has('persistent_undo')
		set undofile
		set undodir=$HOME/.config/nvim/tmp/undo,.
	endif
endif

"每次打开vim, 将光标移动到上一次编辑时的位置
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" ===
" === Code fold
" ===
"激活折叠功能"
set foldenable
"set nofen（这个是关闭折叠功能）"

"设置按照语法方式折叠（可简写set fdm=XX）"
"有6种折叠方法：
"manual   手工定义折叠"
"indent   更多的缩进表示更高级别的折叠"
"expr     用表达式来定义折叠"
"syntax   用语法高亮来定义折叠"
"diff     对没有更改的文本进行折叠"
"marker   对文中的标志进行折叠"
set foldmethod=indent
"set fdl=0（这个是不选用任何折叠方法）"

"设置折叠区域的宽度"
"如果不为0，则在屏幕左侧显示一个折叠标识列
"分别用“-”和“+”来表示打开和关闭的折叠
"set foldcolumn=0

"设置折叠层数为3"
set foldlevel=99

"设置为自动关闭折叠"
"set foldclose=all

"用空格键来代替zo和zc快捷键实现开关折叠"
"zo O-pen a fold (打开折叠)
"zc C-lose a fold (关闭折叠)
"zf F-old creation (创建折叠)
"nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>


" ===
" === Encode setting
" ===
set encoding=utf-8
set fencs=utf-8,gbk,utf-16,utf-32,ucs-bom
set fileencoding=utf-8

" ===
" === Custom key map
" ===
"设定leader键为空格
let mapleader=" "

"括号的自动匹配
"inoremap ' ''<LEFT>
"inoremap " ""<LEFT>
"inoremap ( ()<LEFT>
"inoremap < <><LEFT>
"inoremap [ []<LEFT>
"inoremap { {}<LEFT>
"inoremap {<CR> {<CR>}<ESC>O

"输入模式下自由的左右移动
inoremap <C-f> <RIGHT>
inoremap <C-b> <LEFT>

"上开空白行和下开空白行
noremap <CR> o<ESC>k

"当切换匹配项时, 将其居中显示
noremap n nzz
noremap N Nzz

"设置 空格+回车 就清除所有高亮的匹配项
noremap <LEADER><CR> :nohlsearch<CR>
noremap <C-j> J
noremap J 5j
noremap K 5k
noremap H 5h
noremap L 5l

"向右将当前文件分屏
map <LEADER>sl :set splitright<CR>:vsp<CR>
"向左将当前文件分屏
map <LEADER>sh :set nosplitright<CR>:vsp<CR>
"向下将当前文件分屏
map <LEADER>sj :set splitbelow<CR>:sp<CR>
"向上将当前文件分屏
map <LEADER>sk :set nosplitbelow<CR>:sp<CR>

"将快速在分屏的文件中移动, 将<C-w>替换为空格
noremap <LEADER>l <C-w>l
noremap <LEADER>h <C-w>h
noremap <LEADER>j <C-w>j
noremap <LEADER>k <C-w>k

"将设置分屏大小设置为 方向键
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical res -5<CR>
map <right> :vertical res +5<CR>

"打开新的标签页
map to :tabe<CR>
map th :tabp<CR>
map tl :tabn<CR>

"buffer设置
" noremap bh :bp<CR>
" noremap bl :bn<CR>
" noremap b0 :bfirst<CR>
"打开我的vimrc设置
if g:os == "win"
	if has("nvim")
		map ti :tabe $HOME/AppData/Local/nvim/init.vim<CR>
	else
		map ti :tabe $HOME/.vim/_vimrc<CR>
	endif
else
	if has("nvim")
		map ti :tabe $HOME/.config/nvim/init.vim<CR>
	else
		map ti :tabe $HOME/.vim/.vimrc<CR>
	endif
endif

" ===
" === Plugin load
" ===
call plug#begin('~/.vim/plugged')

" Editor dress
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'joshdick/onedark.vim'

" Treesitter 代码高亮
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'

" Pretty Dress 主题
Plug 'theniceboy/nvim-deus'
"Plug 'arzg/vim-colors-xcode'

" Status line 底部状态栏
Plug 'theniceboy/eleline.vim' "主题
Plug 'ojroques/vim-scrollstatus' "当前页数滚动条

" General Highlighter
if g:os != "win"
	Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' } "显示rgb码 对应的颜色
endif
Plug 'RRethy/vim-illuminate' "自动高亮光标下的其他相同单词

" File navigation
"Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' } "浮窗模糊查找
if g:os != "win"
    Plug 'kevinhwang91/rnvimr' "浮窗ranger
endif
Plug 'airblade/vim-rooter' "自动更改工作目录为当前vim打开文件目录
Plug 'pechorin/any-jump.vim' "自动跳转定义

" Taglist
Plug 'liuchengxu/vista.vim' "显示搜索LSP符号,tags

" Debugger "调试, 暂时不用, 暂时使用pycharm
" Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python --enable-go'}

" Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'} "自动补全
"Plug 'neoclide/coc.nvim', {'branch': 'release', 'tag': 'v0.0.79'}
"Plug 'wellle/tmux-complete.vim' "查找tmux其他窗口中的字符串来补全

" Snippets
Plug 'SirVer/ultisnips'
"Plug 'theniceboy/vim-snippets'

" Undo Tree
Plug 'mbbill/undotree' "显示撤回的记录 Shift+L

" Git
Plug 'theniceboy/vim-gitignore', { 'for': ['gitignore', 'vim-plug'] } "gitignore的语法高亮
Plug 'theniceboy/fzf-gitignore', { 'do': ':UpdateRemotePlugins' } "通过fzf来创建gitignore gi
"Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter' "显示当前行在git中的不同
Plug 'cohama/agit.vim' "以gitk的方式来查看commit :Agit
Plug 'kdheepak/lazygit.nvim' "打开lazygit, 以gui的方式来使用git

" LaTex
" Plug 'lervag/vimtex' "查看LaTex文件

" HTML, CSS, JavaScript, Typescript, PHP, JSON, etc.
Plug 'elzr/vim-json' "Json高亮
"Plug 'neoclide/jsonc.vim' "cJSON(c语言的json解析器) 的语法高亮
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag' "html自动输入闭合标签
" Plug 'hail2u/vim-css3-syntax' " , { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
" Plug 'pangloss/vim-javascript', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
" Plug 'jelera/vim-javascript-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
"Plug 'jaxbot/browserlink.vim'
Plug 'HerringtonDarkholme/yats.vim' "TypeScript 语法
" Plug 'posva/vim-vue'
" Plug 'evanleck/vim-svelte', {'branch': 'main'}
" Plug 'leafOfTree/vim-svelte-plugin'
" Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } "ES6 CSS 语法,预览
Plug 'pantharshit00/vim-prisma' 

" Go
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }

" Python
" Plug 'tmhedberg/SimpylFold', { 'for' :['python', 'vim-plug'] }
Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins'}
"Plug 'vim-scripts/indentpython.vim', { 'for' :['python', 'vim-plug'] }
"Plug 'plytophogy/vim-virtualenv', { 'for' :['python', 'vim-plug'] }
Plug 'tweekmonster/braceless.vim', { 'for' :['python', 'vim-plug'] }

" Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'f-person/pubspec-assist-nvim', { 'for' : ['pubspec.yaml'] }

" Swift
Plug 'keith/swift.vim'
Plug 'arzg/vim-swift'

" Markdown
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown', 'vim-plug'] }
Plug 'dkarter/bullets.vim'

" Other filetypes

" Editor Enhancement
"Plug 'Raimondi/delimitMate'
Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi'
Plug 'tomtom/tcomment_vim' " in <space>c to comment a line
Plug 'theniceboy/antovim' " gs to switch
Plug 'tpope/vim-surround' " type yskw' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'gcmt/wildfire.vim' " in Visual mode, type k' to select all text in '', or type k) k] k} kp
Plug 'junegunn/vim-after-object' " da= to delete what's after =
Plug 'godlygeek/tabular' " ga, or :Tabularize <regex> to align
Plug 'tpope/vim-capslock'	" Ctrl+L (insert) to toggle capslock
Plug 'easymotion/vim-easymotion' "快速跳转
" Plug 'Konfekt/FastFold'
"Plug 'junegunn/vim-peekaboo'
"Plug 'wellle/context.vim'
Plug 'svermeulen/vim-subversive'
Plug 'theniceboy/argtextobj.vim'
Plug 'rhysd/clever-f.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'theniceboy/pair-maker.vim'
" Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'Yggdroot/indentLine'

" For general writing
Plug 'junegunn/goyo.vim'
"Plug 'reedes/vim-wordy'
"Plug 'ron89/thesaurus_query.vim'

" Bookmarks
" Plug 'MattesGroeger/vim-bookmarks'

" Find & Replace
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] } "<LEADER>f

" Documentation
"Plug 'KabbAmine/zeavim.vim' " <LEADER>z to find doc

" Mini Vim-APP
"Plug 'jceb/vim-orgmode'
"Plug 'mhinz/vim-startify'
Plug 'skywind3000/asynctasks.vim' "为 Vim 引入类似 vscode 的 tasks 任务系统，用统一的方式系统化解决各类：编译/运行/测试/部署任务。
Plug 'skywind3000/asyncrun.vim'

" Vim Applications
"Plug 'itchyny/calendar.vim'

" Other visual enhancement
Plug 'luochen1990/rainbow'
Plug 'mg979/vim-xtabline'
Plug 'ryanoasis/vim-devicons'
Plug 'wincent/terminus'

" Other useful utilities
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite
" Plug 'makerj/vim-pdf'
"Plug 'xolox/vim-session'
"Plug 'xolox/vim-misc' " vim-session dep

" Dependencies
" Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'kana/vim-textobj-user'
" Plug 'roxma/nvim-yarp'


call plug#end()


" ===================== Start of Plugin Settings =====================

" ===
" === vim-airline
" ===
"let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline_theme='onedark'
"set laststatus=2	"设置状态行显示在倒数第2行

" ===
" === onedark
" ===
"colorscheme onedark


" ===
" === eleline.vim
" ===
let g:airline_powerline_fonts = 0


" ==
" == GitGutter
" ==
" let g:gitgutter_signs = 0
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'
" autocmd BufWritePost * GitGutter
nnoremap <LEADER>gf :GitGutterFold<CR>
nnoremap H :GitGutterPreviewHunk<CR>
nnoremap <LEADER>g- :GitGutterPrevHunk<CR>
nnoremap <LEADER>g= :GitGutterNextHunk<CR>


" ===
" === coc.nvim
" ===
let g:coc_global_extensions = [
	\ 'coc-css',
	\ 'coc-diagnostic',
	\ 'coc-docker',
	\ 'coc-eslint',
	\ 'coc-explorer',
	\ 'coc-flutter-tools',
	\ 'coc-gitignore',
	\ 'coc-html',
	\ 'coc-import-cost',
	\ 'coc-java',
	\ 'coc-jest',
	\ 'coc-json',
	\ 'coc-lists',
	\ 'coc-omnisharp',
	\ 'coc-prettier',
	\ 'coc-prisma',
	\ 'coc-pyright',
	\ 'coc-snippets',
	\ 'coc-sourcekit',
	\ 'coc-stylelint',
	\ 'coc-syntax',
	\ 'coc-tailwindcss',
	\ 'coc-tasks',
	\ 'coc-translator',
	\ 'coc-tsserver',
	\ 'coc-vetur',
	\ 'coc-vimlsp',
	\ 'coc-yaml',
	\ 'coc-yank',
	\ 'https://github.com/rodrigore/coc-tailwind-intellisense']
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-o> coc#refresh()
function! Show_documentation()
	call CocActionAsync('highlight')
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
"nnoremap <LEADER>h :call Show_documentation()<CR>

" set runtimepath^=$NVIM_HOME/coc-extensions/coc-flutter-tools/
" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']
" let $NVIM_COC_LOG_LEVEL = 'debug'
" let $NVIM_COC_LOG_FILE = '/Users/david/Desktop/log.txt'

"nnoremap <silent><nowait> <LEADER>d :CocList diagnostics<cr>
"nmap <silent> <LEADER>- <Plug>(coc-diagnostic-prev)
"nmap <silent> <LEADER>= <Plug>(coc-diagnostic-next)
"nnoremap <c-c> :CocCommand<CR>
" Text Objects
"xmap kf <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap kf <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)
"xmap kc <Plug>(coc-classobj-i)
"omap kc <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
" Useful commands
"打开历史剪切板
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr> 
"列出定义列表 
nmap <silent> gd <Plug>(coc-definition)
"分屏列出定义列表 
nmap <silent> gD :tab sp<CR><Plug>(coc-definition)
"转至类型定义
nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
"列出应用
nmap <silent> gr <Plug>(coc-references)
"重命名
nmap <leader>rn <Plug>(coc-rename)

"打开文件浏览器
nmap tt :CocCommand explorer<CR>
" coc-translator 翻译单词
nmap ts <Plug>(coc-translator-p)

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>aw  <Plug>(coc-codeaction-selected)w

" coctodolist
" nnoremap <leader>tn :CocCommand todolist.create<CR>
" nnoremap <leader>tl :CocList todolist<CR>
" nnoremap <leader>tu :CocCommand todolist.download<CR>:CocCommand todolist.upload<CR>

" coc-tasks
noremap <silent> <leader>ts :CocList tasks<CR>

" coc-snippets
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-e> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-e>'
let g:coc_snippet_prev = '<c-n>'
imap <C-e> <Plug>(coc-snippets-expand-jump)
let g:snips_author = 'Lee'
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc


" ===
" === vim-instant-markdown
" ===
let g:instant_markdown_slow = 0
let g:instant_markdown_autostart = 0
" let g:instant_markdown_open_to_the_world = 1
" let g:instant_markdown_allow_unsafe_content = 1
" let g:instant_markdown_allow_external_content = 0
" let g:instant_markdown_mathjax = 1
let g:instant_markdown_autoscroll = 1


" ===
" === vim-table-mode
" ===
"开关表格模式
noremap <LEADER>tm :TableModeToggle<CR>
"let g:table_mode_disable_mappings = 1
let g:table_mode_cell_text_object_i_map = 'k<Bar>'


" ===
" === FZF
" ===
"模糊查找文件
nnoremap <c-p> :Leaderf file<CR>
" noremap <silent> <C-p> :Files<CR>
"模糊查找文件内容
noremap <silent> <C-f> :Rg<CR>
"模糊查找历史文件
noremap <silent> <C-h> :History<CR>
"模糊查找标签
noremap <C-t> :BTags<CR>
" noremap <silent> <C-l> :Lines<CR>
"模糊查找缓冲区
noremap <silent> <C-w> :Buffers<CR>
"noremap <leader>; :History:<CR>

let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

"noremap <c-d> :BD<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }


" ===
" === LeaderF
" ===
" let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_PreviewCode = 1
let g:Lf_ShowHidden = 1
let g:Lf_ShowDevIcons = 1
let g:Lf_CommandMap = {
\   '<C-k>': ['<C-u>'],
\   '<C-j>': ['<C-e>'],
\   '<C-]>': ['<C-v>'],
\   '<C-p>': ['<C-n>'],
\}
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WildIgnore = {
        \ 'dir': ['.git', 'vendor', 'node_modules'],
        \ 'file': ['__vim_project_root', 'class']
        \}
let g:Lf_UseMemoryCache = 0
let g:Lf_UseCache = 0


" ===
" === vim-bookmarks
" ===
" let g:bookmark_no_default_key_mappings = 1
" nmap mt <Plug>BookmarkToggle
" nmap ma <Plug>BookmarkAnnotate
" nmap ml <Plug>BookmarkShowAll
" nmap mi <Plug>BookmarkNext
" nmap mn <Plug>BookmarkPrev
" nmap mC <Plug>BookmarkClear
" nmap mX <Plug>BookmarkClearAll
" nmap mu <Plug>BookmarkMoveUp
" nmap me <Plug>BookmarkMoveDown
" nmap <Leader>g <Plug>BookmarkMoveToLine
" let g:bookmark_save_per_working_dir = 1
" let g:bookmark_auto_save = 1
" let g:bookmark_highlight_lines = 1
" let g:bookmark_manage_per_buffer = 1
" let g:bookmark_save_per_working_dir = 1
" let g:bookmark_center = 1
" let g:bookmark_auto_close = 1
" let g:bookmark_location_list = 1


" ===
" === Undotree
" ===
noremap L :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
	nmap <buffer> u <plug>UndotreeNextState
	nmap <buffer> e <plug>UndotreePreviousState
	nmap <buffer> U 5<plug>UndotreeNextState
	nmap <buffer> E 5<plug>UndotreePreviousState
endfunc

" ===
" === vim-visual-multi
" ===
let g:VM_theme             = 'iceblue'
let g:VM_default_mappings = 1
let g:VM_leader                     = {'default': ',', 'visual': ',', 'buffer': ','}  
" let g:VM_maps['Add Cursor At Pos']         = '<C-;>'
" let g:VM_maps                       = {}
" let g:VM_custom_motions             = {'n': 'h', 'i': 'l', 'u': 'k', 'e': 'j', 'N': '0', 'I': '$', 'h': 'e'}
" "let g:VM_maps['i']                  = 'k'
" "let g:VM_maps['I']                  = 'K'
" let g:VM_maps['Find Under']         = '<C-k>'
" let g:VM_maps['Find Subword Under'] = '<C-k>'
" "let g:VM_maps['Find Next']          = 'n'
" "let g:VM_maps['Find Prev']          = 'N'
" let g:VM_maps['Skip Region']        = 'q'
" let g:VM_maps['Remove Region']      = 'Q'
" let g:VM_maps["Undo"]               = 'u'
" let g:VM_maps["Redo"]               = '<C-r>'


" ===
" === Far.vim
" ===
noremap <LEADER>f :F  **/*<left><left><left><left><left>
let g:far#mapping = {
		\ "replace_undo" : ["l"],
		\ }


" ===
" === vim-calc
" ===
"noremap <LEADER>a :call Calc()<CR>
" Testing
"if !empty(glob('~/Github/vim-calc/vim-calc.vim'))
"source ~/Github/vim-calc/vim-calc.vim
"endif


" ===
" === Bullets.vim
" ===
" let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
			\ 'markdown',
			\ 'text',
			\ 'gitcommit',
			\ 'scratch'
			\]


" ===
" === Vista.vim
" ===
noremap <LEADER>v :Vista!!<CR>
noremap <c-t> :silent! Vista finder coc<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
" function! NearestMethodOrFunction() abort
" 	return get(b:, 'vista_nearest_method_or_function', '')
" endfunction
" set statusline+=%{NearestMethodOrFunction()}
" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:scrollstatus_size = 15

" ===
" === fzf-gitignore
" ===
noremap <LEADER>gi :FzfGitignore<CR>


" ===
" === Ultisnips
" ===
let g:tex_flavor = "latex"
inoremap <c-n> <nop>
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"
let g:UltiSnipsSnippetDirectories = [$NVIM_HOME.'/Ultisnips/', $NVIM_HOME.'/plugged/vim-snippets/UltiSnips/']
silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>
" Solve extreme insert-mode lag on macOS (by disabling autotrigger)
augroup ultisnips_no_auto_expansion
    au!
    au VimEnter * au! UltiSnips_AutoTrigger
augroup END



" ===
" === vimtex
" ===
"let g:vimtex_view_method = ''
let g:vimtex_view_general_viewer = 'llpp'
let g:vimtex_mappings_enabled = 0
let g:vimtex_text_obj_enabled = 0
let g:vimtex_motion_enabled = 0
let maplocalleader=' '


" ===
" === vim-calendar
" ===
"noremap \c :Calendar -position=here<CR>
"noremap \\ :Calendar -view=clock -position=here<CR>
"let g:calendar_google_calendar = 1
"let g:calendar_google_task = 1
"augroup calendar-mappings
"	autocmd!
"	" diamond cursor
"	autocmd FileType calendar nmap <buffer> u <Plug>(calendar_up)
"	autocmd FileType calendar nmap <buffer> n <Plug>(calendar_left)
"	autocmd FileType calendar nmap <buffer> e <Plug>(calendar_down)
"	autocmd FileType calendar nmap <buffer> i <Plug>(calendar_right)
"	autocmd FileType calendar nmap <buffer> <c-u> <Plug>(calendar_move_up)
"	autocmd FileType calendar nmap <buffer> <c-n> <Plug>(calendar_move_left)
"	autocmd FileType calendar nmap <buffer> <c-e> <Plug>(calendar_move_down)
"	autocmd FileType calendar nmap <buffer> <c-i> <Plug>(calendar_move_right)
"	autocmd FileType calendar nmap <buffer> k <Plug>(calendar_start_insert)
"	autocmd FileType calendar nmap <buffer> K <Plug>(calendar_start_insert_head)
"	" unmap <C-n>, <C-p> for other plugins
"	autocmd FileType calendar nunmap <buffer> <C-n>
"	autocmd FileType calendar nunmap <buffer> <C-p>
"augroup END


" ===
" === vim-go
" ===
let g:go_echo_go_info = 0
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_auto_type_info = 1
let g:go_def_mapping_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0
let g:go_doc_keywordprg_enabled = 0


" ===
" === OmniSharp
" ===
"let g:OmniSharp_typeLookupInPreview = 1
"let g:omnicomplete_fetch_full_documentation = 1

"let g:OmniSharp_server_use_mono = 1
"let g:OmniSharp_server_stdio = 1
"let g:OmniSharp_highlight_types = 2
"let g:OmniSharp_selector_ui = 'ctrlp'

"autocmd Filetype cs nnoremap <buffer> gd :OmniSharpPreviewDefinition<CR>
"autocmd Filetype cs nnoremap <buffer> gr :OmniSharpFindUsages<CR>
"autocmd Filetype cs nnoremap <buffer> gy :OmniSharpTypeLookup<CR>
"autocmd Filetype cs nnoremap <buffer> ga :OmniSharpGetCodeActions<CR>
"autocmd Filetype cs nnoremap <buffer> <LEADER>rn :OmniSharpRename<CR><C-N>:res +5<CR>

"sign define OmniSharpCodeActions text=💡

"let g:coc_sources_disable_map = { 'cs': ['cs', 'cs-1', 'cs-2', 'cs-3'] }

" ===
" === vim-easymotion
" ===
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_do_shade = 0
let g:EasyMotion_smartcase = 1
" map ' <Plug>(easymotion-overwin-f2)
" nmap ' <Plug>(easymotion-overwin-f2)
"map E <Plug>(easymotion-j)
"map U <Plug>(easymotion-k)
"nmap f <Plug>(easymotion-overwin-f)
"map \; <Plug>(easymotion-prefix)
"nmap ' <Plug>(easymotion-overwin-f2)
"map 'l <Plug>(easymotion-bd-jk)
"nmap 'l <Plug>(easymotion-overwin-line)
"map  'w <Plug>(easymotion-bd-w)
"nmap 'w <Plug>(easymotion-overwin-w)


" ===
" === goyo
" ===
map <LEADER>gy :Goyo<CR>


" ===
" === jsx
" ===
let g:vim_jsx_pretty_colorful_config = 1


" ===
" === fastfold
" ===
" nmap zuz <Plug>(FastFoldUpdate)
" let g:fastfold_savehook = 1
" let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
" let g:fastfold_fold_movement_commands = [']z', '[z', 'ze', 'zu']
" let g:markdown_folding = 1
" let g:tex_fold_enabled = 1
" let g:vimsyn_folding = 'af'
" let g:xml_syntax_folding = 1
" let g:javaScript_fold = 1
" let g:sh_fold_enabled= 7
" let g:ruby_fold = 1
" let g:perl_fold = 1
" let g:perl_fold_blocks = 1
" let g:r_syntax_folding = 1
" let g:rust_fold = 1
" let g:php_folding = 1


" ===
" === tabular
" ===
vmap ga :Tabularize /


" ===
" === vim-after-object
" ===
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')


" ===
" === rainbow
" ===
let g:rainbow_active = 1


" ===
" === xtabline
" ===
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0
let g:xtabline_settings.tabline_modes = ['tabs', 'buffers']
let g:xtabline_settings.enable_persistance = 0
let g:xtabline_settings.last_open_first = 1
noremap to :XTabCycleMode<CR>
noremap \p :echo expand('%:p')<CR>


" ===
" === vim-session
" ===
"let g:session_directory = $NVIM_HOME."/tmp/sessions"
"let g:session_autosave = 'no'
"let g:session_autoload = 'no'
"let g:session_command_aliases = 1
"set sessionoptions-=buffers
"set sessionoptions-=options
"noremap sl :OpenSession<CR>
"noremap sS :SaveSession<CR>
"noremap ss :SaveSession
"noremap sc :SaveSession<CR>:CloseSession<CR>:q<CR>
"noremap so :OpenSession default<CR>
"noremap sD :DeleteSession<CR>
""noremap sA :AppendTabSession<CR>


" ===
" === context.vim
" ===
"let g:context_add_mappings = 0
"noremap <leader>ct :ContextToggle<CR>


" ===
" === suda.vim
" ===
cnoreabbrev sudowrite w suda://%
cnoreabbrev sw w suda://%


" ===
" === vimspector
" ===
"let g:vimspector_enable_mappings = 'HUMAN'
"function! s:read_template_into_buffer(template)
"	" has to be a function to avoid the extra space fzf#run insers otherwise
"	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
"endfunction
"command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
"			\   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
"			\   'down': 20,
"			\   'sink': function('<sid>read_template_into_buffer')
"			\ })
"" noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
"sign define vimspectorBP text=☛ texthl=Normal
"sign define vimspectorBPDisabled text=☞ texthl=Normal
"sign define vimspectorPC text=🔶 texthl=SpellBad


" ===
" === reply.vim
" ===
"noremap <LEADER>rp :w<CR>:Repl<CR><C-\><C-N><C-w><C-h>
"noremap <LEADER>rs :ReplSend<CR><C-w><C-l>a<CR><C-\><C-N><C-w><C-h>
"noremap <LEADER>rt :ReplStop<CR>


" ===
" === vim-markdown-toc
" ===
"let g:vmt_auto_update_on_save = 0
"let g:vmt_dont_insert_fence = 1
let g:vmt_cycle_list_item_markers = 1
let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = '/TOC'


" ===
" === rnvimr
" ===
if g:os != "win"
    let g:rnvimr_ex_enable = 1
    let g:rnvimr_pick_enable = 1
    let g:rnvimr_draw_border = 0
    " let g:rnvimr_bw_enable = 1
    highlight link RnvimrNormal CursorLine
    nnoremap <silent> R :RnvimrToggle<CR><C-\><C-n>:RnvimrResize 0<CR>
    let g:rnvimr_action = {
                \ '<C-t>': 'NvimEdit tabedit',
                \ '<C-x>': 'NvimEdit split',
                \ '<C-v>': 'NvimEdit vsplit',
                \ 'gw': 'JumpNvimCwd',
                \ 'yw': 'EmitRangerCwd'
                \ }
    let g:rnvimr_layout = { 'relative': 'editor',
                \ 'width': &columns,
                \ 'height': &lines,
                \ 'col': 0,
                \ 'row': 0,
                \ 'style': 'minimal' }
    let g:rnvimr_presets = [{'width': 1.0, 'height': 1.0}]
endif


" ===
" === vim-subversive
" ===
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine) 

" ===
" === vim-illuminate
" ===
let g:Illuminate_delay = 750
let g:Illuminate_highlightUnderCursor = 0
hi illuminatedWord cterm=underline gui=underline


" ===
" === vim-rooter
" ===
let g:rooter_patterns = ['__vim_project_root', '.git/']
let g:rooter_silent_chdir = 1


" ===
" === AsyncRun
" ===
noremap gp :AsyncRun git push<CR>


" ===
" === AsyncTasks
" ===
let g:asyncrun_open = 6


" ===
" === dart-vim-plugin
" ===
let g:dart_style_guide = 2
let g:dart_format_on_save = 1
let g:dartfmt_options = ["-l 100"]


" ===
" === tcomment_vim
" ===
" noremap ci cl
let g:tcomment_textobject_inlinecomment = ''
nmap <LEADER>c g>c
vmap <LEADER>c g>
nmap <LEADER>u g<c
vmap <LEADER>u g<


" ===
" === any-jump
" ===
nnoremap cj :AnyJump<CR>
let g:any_jump_disable_default_keybindings = 1
let g:any_jump_window_height_ratio = 0.9
let g:any_jump_window_width_ratio  = 0.8


" ===
" === typescript-vim
" ===
let g:typescript_ignore_browserwords = 1


" ===
" === Agit
" ===
nnoremap <LEADER>gl :Agit<CR>
let g:agit_no_default_mappings = 1


" ===
" === nvim-treesitter
" ===
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"typescript", "dart", "java"},     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF


" ===
" === lazygit.nvim
" ===
noremap <c-g> :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 1.0 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_use_neovim_remote = 1 " for neovim-remote support


" ===================== End of Plugin Settings =====================



" ===
" === Terminal color config
" ===
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'

" ===
" === Dress up my vim
" ===
"color dracula
"color one
"color gruvbox
color deus
"let ayucolor="light"
"color ayu
"color xcodelighthc
"set background=light
"set cursorcolumn

hi NonText ctermfg=gray guifg=grey10
"hi SpecialKey ctermfg=blue guifg=grey70

" ===
" === Necessary Commands to Execute
" ===
exec "nohlsearch"

" Open the _machine_specific.vim file if it has just been created
if has_machine_specific_file == 0
	exec "e ".$NVIM_HOME."/_machine_specific.vim"
endif


