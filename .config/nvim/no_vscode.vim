" Plugins Section
" ---------------

call plug#begin()

" I. Always-loaded plugins
Plug 'dracula/vim'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-crystalline'
Plug 'simnalamburt/vim-mundo'
Plug 'christoomey/vim-tmux-navigator'

" 1. A Latex Suite
Plug 'lervag/vimtex', {'for' : ['tex', 'latex']}

" 2. An extendable code snippets plugin
Plug 'SirVer/ultisnips'   , {'for': ['cpp', 'c', 'python', 'tex', 'latex', 'markdown', 'html', 'javascript', 'vim']}
Plug 'honza/vim-snippets'  , {'for': ['cpp', 'c', 'python', 'tex', 'latex', 'markdown', 'html', 'javascript', 'vim']}

" 3. Intellisense-like completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
Plug 'aperezdc/vim-template', {'for': ['cpp', 'c']}
" Recommended Extensions
" :CocInstall coc-calc coc-git coc-vimlsp coc-clangd coc-python coc-cmake coc-json coc-template

" 4. Markdown support
"Plug 'iamcco/markdown-preview.nvim', { 'for': 'markdown', 'do': 'cd app && yarn install'  }

" 5. Distraction-free editing and reading
Plug 'junegunn/goyo.vim', { 'on': 'Goyo'}

call plug#end()

" Configuration Section
" ---------------------

" 0. General sane defaults

set background=dark
" The leader key
let mapleader = ","
" Disable vi compatibility
set nocompatible
" Set encoding
set encoding=utf-8
" Mouse support
set mouse=a
" Show line numbers
set number
set relativenumber
" Wrap stuff
set textwidth=80
" Be able to arrow key and backspace across newlines
set whichwrap=bs<>[]
" Make laggy connections work faster
set ttyfast
" Highlight search matches
set hlsearch 
" Real-time search highlighting
set incsearch 
" Ignore case in searches if no uppercase characters
set smartcase 
" Imply global for new searches
set gdefault 
" Indenting
set smartindent
set softtabstop=4
set tabstop=4
set shiftwidth=0
filetype plugin indent on
" Tabs
set smarttab
" Code syntax support
syntax enable
" Proper backspace behavior
set backspace=indent,eol,start
" Commandline completion
set wildmenu
" Colorscheme
colorscheme dracula
" Disable backups
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" The status line
"
"
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" By default vista.vim never run if not called.
" Call it only for OpenFOAM files
autocmd FileType cpp call vista#RunForNearestMethodOrFunction()

function! StatusLine(current, width)
  let l:s = ''

  if a:current
    let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
  else
    let l:s .= '%#CrystallineInactive#'
  endif
  let l:s .= ' %f%h%w%m%r '
  let l:s .= get(b:, 'vista_nearest_method_or_function', '')
  " But defaults to COC-Git extension
  if exists('g:coc_git_status')
	let l:s .= crystalline#right_sep('', 'Fill') . ' %{g:coc_git_status}'
	let l:s .= '... %{coc#status()}'
  else
  " Use fugitive if you have it installed
   if a:current
    let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
   endif
  endif

  let l:s .= '%='
  if a:current
    let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
    let l:s .= crystalline#left_mode_sep('')
  endif
  if a:width > 80
    let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
  else
    let l:s .= ' '
  endif

  return l:s
endfunction
function! TabLine()
  let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
  return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction
let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'dracula'
let g:crystalline_separators = [ "|", "|"]
set showtabline=2
set guioptions-=e
set laststatus=2


" 1. Enable builtins for programmers

" Jump from if blocks to else ...
runtime macros/matchit.vim

" 2. The Latex Suite

" 3. Code Snippets

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsEditSplit="vertical"

" 4. Intellisense autocompletion

" Clangd should be called with --suggest-missing-includes --completion-style=bundled
" in CocConfig

" Coc Specific maps

set updatetime=300
set shortmess+=c
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup cocformatgroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
vmap if <Plug>(coc-funcobj-i)
vmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Set templates directory
let g:templates_directory=['~/.config/nvim/coc-templates']

" General Maps {{{
tnoremap <Esc> <C-\><C-n>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" }}}
" Coc-Calc Maps {{{
imap <C-S-a> <Plug>(coc-calc-result-replace)
" }}}
"
" Coc-Git Maps {{{
nnoremap <silent> <space>b  :<C-u>CocList bcommits<CR>
" }}}

" Vista indentation levels
" e.g., more compact: ["▸ ", ""]
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" Vista default executive
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }


" Who the hell enabled gdefault???
set nogdefault
" And why may Tabs are messedup?
set expandtab
" Color 80th column
set colorcolumn=80
" Force No folding
set nofoldenable



" Persistent undo
" ENABLE THIS only if undotree ins installed
if has('persistent_undo')
    " define a path to store persistent_undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call system('mkdir -p ' . target_path)
    endif

    " point Vim to the defined undo directory.
    let &undodir = target_path

    " finally, enable undo persistence.
    set undofile

    nnoremap <leader>u :MundoToggle<CR>
endif




" 5 Fix Vim-Tmux layout conflict
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>
