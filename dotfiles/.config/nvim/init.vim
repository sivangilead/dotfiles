" General: Notes
"
" Author: Samuel Roeca
" Date: August 15, 2017
" TLDR: vimrc minimum viable product for Python programming
"
" I've noticed that many vim/neovim beginners have trouble creating a useful
" vimrc. This file is intended to get a Python programmer who is new to vim
" set up with a vimrc that will enable the following:
"   1. Sane editing of Python files
"   2. Sane defaults for vim itself
"   3. An organizational skeleton that can be easily extended
"
" Notes:
"   * When in normal mode, scroll over a folded section and type 'za'
"       this toggles the folded section
"
" Initialization:
"   1. Follow instructions at https://github.com/junegunn/vim-plug to install
"      vim-plug for either Vim or Neovim
"   2. Open vim (hint: type vim at command line and press enter :p)
"   3. :PlugInstall
"   4. :PlugUpdate
"   5. You should be ready for MVP editing
"
" Updating:
"   If you want to upgrade your vim plugins to latest version
"     :PlugUpdate
"   If you want to upgrade vim-plug itself
"     :PlugUpgrade
" General: Leader mappings {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" General: global config {{{


" Code Completion:
set completeopt=menuone,longest,preview
set wildmode=longest,list,full
set wildmenu

" Hidden Buffer: enable instead of having to write each buffer
set hidden

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent their creation
set nobackup
set noswapfile

" Line Wrapping: do not wrap lines by default
set nowrap

" Highlight Search:
set incsearch
set inccommand=nosplit
augroup sroeca_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup END

filetype plugin indent on

" Spell Checking:
set dictionary=$HOME/.american-english-with-propcase.txt
set spelllang=en_us

" Single Space After Punctuation: useful when doing :%j (the opposite of gq)
set nojoinspaces

set showtabline=2

set autoread

set grepprg=rg\ --vimgrep

" Paste: this is actually typed <C-/>, but term nvim thinks this is <C-_>
set pastetoggle=<C-_>

set notimeout   " don't timeout on mappings
set ttimeout    " do timeout on terminal key codes

" Local Vimrc: If exrc is set, the current directory is searched for 3 files
" in order (Unix), using the first it finds: '.nvimrc', '_nvimrc', '.exrc'
set exrc

" Default Shell:
set shell=$SHELL

" Numbering:
set number

" Window Splitting: Set split settings (options: splitright, splitbelow)
set splitright

" Redraw Window:
augroup redraw_on_refocus
  autocmd!
  autocmd FocusGained * redraw!
augroup END

" Terminal Color Support: only set guicursor if truecolor
if $COLORTERM ==# 'truecolor'
  set termguicolors
else
  set guicursor=
endif

" Default Background:
set background=dark

" Lightline: specifics for Lightline
set laststatus=2
set ttimeoutlen=50
set noshowmode

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" Configure Updatetime: time Vim waits to do something after I stop moving
set updatetime=750

" Linux Dev Path: system libraries
set path+=/usr/include/x86_64-linux-gnu/

" }}}
" General: Plugin Install {{{

call plug#begin('~/.vim/plugged')

" Auto-Completion and Diagnostics

" nerdtree {{{
" open on startup
" autocmd vimenter * NERDTree

" open Nerdtree even if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" open using Ctrl+n
map <space>j :NERDTreeToggle<CR>
" }}}


function s:init_packages() abort
  packadd vim-packager
  call packager#init()
  call packager#add('git@github.com:kristijanhusak/vim-packager', {'type': 'opt'})

  "call packager#add('git@github.com:NLKNguyen/papercolor-theme.git') " color scheme
  call packager#add('git@github.com:tpope/vim-scriptease.git') " color scheme debugging
  call packager#add('git@github.com:itchyny/lightline.vim.git') " Airline/Powerline replacement
  call packager#add('git@github.com:pangloss/vim-javascript.git') " JS/JSX support
  call packager#add('git@github.com:pappasam/vim-jsx-typescript.git', {'branch': 'change-to-typescriptreact'}) " TSX support
  call packager#add('git@github.com:pappasam/papercolor-theme-slim')
  call packager#add('git@github.com:pangloss/vim-javascript.git') " JS/JSX support
  call packager#add('git@github.com:leafgarland/typescript-vim.git') " TS support
  call packager#add('git@github.com:peitalin/vim-jsx-typescript.git') " TSX support
endfunction



"system copy in vim- default cp command"
Plug 'christoomey/vim-system-copy'

Plug 'leafgarland/typescript-vim' " ts syntax


" TreeSitter:
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
" Plug 'nvim-treesitter/playground'


"Vim syntax highlighting for Vue components
Plug 'posva/vim-vue'

Plug 'maxmellon/vim-jsx-pretty'

Plug 'pappasam/vim-filetype-formatter'

" Auto-Completion and Diagnostics
Plug 'neoclide/coc.nvim', {'branch': 'release'}
for coc_plugin in [
      \ 'coc-extensions/coc-svelte',
      \ 'fannheyward/coc-markdownlint',
      \ 'neoclide/coc-css',
      \ 'neoclide/coc-html',
      \ 'neoclide/coc-json',
      \ 'neoclide/coc-rls',
      \ 'neoclide/coc-snippets',
      \ 'neoclide/coc-pairs',
      \ 'neoclide/coc-yaml',
      \ 'iamcco/coc-diagnostic',
      \ 'iamcco/coc-vimlsp',
      \ ]
  Plug coc_plugin, { 'do': 'yarn install --frozen-lockfile && yarn build' }
endfor


" Linting
Plug 'w0rp/ale'

Plug 'jiangmiao/auto-pairs'

Plug 'alvan/vim-closetag'

Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'scrooloose/nerdtree'

"java script plug
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': [
    \ 'javascript',
    \ 'typescript',
    \ 'css',
    \ 'less',
    \ 'scss',
    \ 'json',
    \ 'graphql',
    \ 'markdown',
    \ 'vue',
    \ 'lua',
    \ 'php',
    \ 'python',
    \ 'ruby',
    \ 'html',
    \ 'swift' ] }
Plug 'maksimr/vim-jsbeautify'
Plug 'pangloss/vim-javascript'
Plug 'pappasam/vim-filetype-formatter'
" Help for vim-plug
Plug 'junegunn/vim-plug'

" Make tabline prettier
Plug 'kh3phr3n/tabline'

" rust plug
Plug 'rust-lang/rust.vim'

" Commands run in vim's virtual screen and don't pollute main shell
Plug 'fcpg/vim-altscreen'

" Basic coloring
Plug 'NLKNguyen/papercolor-theme'

" Utils
Plug 'tpope/vim-commentary'

" Language-specific syntax
Plug 'vim-python/python-syntax'

" Indentation
Plug 'Vimjas/vim-python-pep8-indent'

call plug#end()

" }}}
" General: Status Line and Tab Line {{{

" Tab Line:
set tabline=%t

" Status Line:
set laststatus=2
set statusline=
set statusline+=\ %{mode()}\  " spaces after mode
set statusline+=%#CursorLine#
set statusline+=\   " space
set statusline+=%{&paste?'[PASTE]':''}
set statusline+=%{&spell?'[SPELL]':''}
set statusline+=%r
set statusline+=%m
set statusline+=%{get(b:,'gitbranch','')}
set statusline+=\   " space
set statusline+=%*  " Default color
set statusline+=\ %f
set statusline+=%=
set statusline+=%n  " buffer number
set statusline+=\ %y\  " File type
set statusline+=%#CursorLine#
set statusline+=\ %{&ff}\  " Unix or Dos
set statusline+=%*  " Default color
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}\  " file encoding
augroup statusline_local_overrides
  autocmd!
  autocmd FileType nerdtree setlocal statusline=\ NERDTree\ %#CursorLine#
augroup END
  autocmd BufNewFile,BufRead,BufEnter *.slack-term,*.prettierrc,*.graphqlconfig
        \ set filetype=json

" Strip newlines from a string
function! StripNewlines(instring)
  return substitute(a:instring, '\v^\n*(.{-})\n*$', '\1', '')
endfunction

function! StatuslineGitBranch()
  let b:gitbranch = ''
  if &modifiable
    try
      let branch_name = StripNewlines(system(
            \ 'git -C ' .
            \ expand('%:p:h') .
            \ ' rev-parse --abbrev-ref HEAD'))
      if !v:shell_error
        let b:gitbranch = '[git::' . branch_name . ']'
      endif
    catch
    endtry
  endif
endfunction

augroup get_git_branch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" }}}
" General: Indentation (tabs, spaces, width, etc) {{{

augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python setlocal shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END

" }}}
" General: Folding Settings {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END


let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

" }}}
" General: Trailing whitespace {{{

" This section should go before syntax highlighting
" because autocommands must be declared before syntax library is loaded
function! TrimWhitespace()
  if &ft == 'markdown'
    return
  endif
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction

highlight EOLWS ctermbg=red guibg=red
match EOLWS /\s\+$/
augroup whitespace_color
  autocmd!
  autocmd ColorScheme * highlight EOLWS ctermbg=red guibg=red
  autocmd InsertEnter * highlight EOLWS NONE
  autocmd InsertLeave * highlight EOLWS ctermbg=red guibg=red
augroup END

augroup fix_whitespace_save
  autocmd!
  autocmd BufWritePre * call TrimWhitespace()
augroup END

" }}}
" General: Syntax highlighting {{{
".vimrc
map <c-f> :call JsBeautify()<cr>
" or
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" " code formatting, thanks sam
" let g:vim_filetype_formatter_verbose = 1
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black - -q --line-length 79',
      \ 'javascript': 'npx prettier --parser flow --stdin',
      \ 'javascript.jsx': 'npx prettier --parser flow --stdin',
      \ 'css': 'npx prettier --parser css --stdin',
      \ 'less': 'npx prettier --parser less --stdin',
      \ 'html': 'npx prettier --parser html --stdin',
      \ 'typescript': ['npx', 'typescript-language-server', '--stdio'],
      \ 'typescript.tsx': ['npx', 'typescript-language-server', '--stdio'],
      \}

augroup mapping_vim_filetype_formatter
  autocmd FileType python,javascript,javascript.jsx,css,less,json,html
        \ nnoremap <silent> <buffer> <leader>f :FiletypeFormat<cr>
augroup END

" }}}
" Auto formatting {{{
" let g:vim_filetype_formatter_commands = {
"       \ 'typescript': g:filetype_formatter#ft#formatters['javascript']['prettier'],
"       \ 'typescript.tsx': g:filetype_formatter#ft#formatters['javascript']['prettier'],
"       \ }
" " }}}
" ********************************************************************
" Papercolor: options
" ********************************************************************
let g:PaperColor_Theme_Options = {}
let g:PaperColor_Theme_Options.theme = {}

" Bold And Italics:
let g:PaperColor_Theme_Options.theme.default = {
      \ 'allow_bold': 1,
      \ 'allow_italic': 1,
      \ }

" VimJavascript:
let g:javascript_plugin_flow = 1

" Folds And Highlights:
let g:PaperColor_Theme_Options.theme['default.dark'] = {}
let g:PaperColor_Theme_Options.theme['default.dark'].override = {
      \ 'folded_bg' : ['gray22', '0'],
      \ 'folded_fg' : ['gray69', '6'],
      \ 'visual_fg' : ['gray12', '0'],
      \ 'visual_bg' : ['gray', '6'],
      \ }

" Language Specific Overrides:
let g:PaperColor_Theme_Options.language = {
      \    'python': {
      \      'highlight_builtins' : 1,
      \    },
      \    'cpp': {
      \      'highlight_standard_library': 1,
      \    },
      \    'c': {
      \      'highlight_builtins' : 1,
      \    }
      \ }



let g:closetag_filetypes = 'html,xhtml,javascript,javascript.jsx,jsx'

let g:closetag_shortcut = '>'

let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript': 'jsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }


" Vim Ale:
"Limit linters used for JavaScript.
let g:ale_linters = {
      \   'javascript': ['eslint', 'flow'],
      \   'python': ['pylint', 'mypy']
      \}


let g:deoplete#enable_at_startup = 1
let g:LanguageClient_serverCommands = {
      \ 'typescript': ['npx', 'typescript-language-server', '--stdio'],
      \ 'typescript.tsx': ['npx', 'typescript-language-server', '--stdio'],
      \ }
let g:LanguageClient_autoStart = 1
let g:LanguageClient_hoverPreview = 'Auto'
let g:LanguageClient_diagnosticsEnable = 0


" augroup language_servers
"   autocmd FileType * call ConfigureLanguageClient()
" augroup END

" Language Server Configuration {{{

" For coc
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}

" Load Syntax:
try
  colorscheme PaperColor
catch
  echo 'An error occured while configuring PaperColor'
endtry

"  Plugin: Configure {{{

" Python highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier


augroup javascript_syntax
  autocmd!
  autocmd FileType javascript syn keyword jsBooleanTrue this
  autocmd FileType javascript.jsx syn keyword jsBooleanTrue this
augroup end


" Typescript: fixes
augroup typescript_syntax
  autocmd!
  autocmd ColorScheme * highlight link typescriptExceptions Exception
  autocmd BufEnter * :syntax sync fromstart
augroup end

" QuickChangeFiletype:
" Sometimes we want to set some filetypes due to annoying behavior of plugins
" The following mappings make it easier to chage javascript plugin behavior
nnoremap <leader>jx :set filetype=javascript.jsx<CR>
nnoremap <leader>jj :set filetype=javascript<CR>

  " coc settings
  nnoremap <silent> <C-k> :call <SID>show_documentation()<CR>
  nmap <silent> <C-]> <Plug>(coc-definition)
  nmap <silent> <Leader>st <Plug>(coc-type-definition)
  nmap <silent> <Leader>si <Plug>(coc-implementation)
  nmap <silent> <Leader>su <Plug>(coc-references)
  nmap <silent> <Leader>sr <Plug>(coc-rename)
  " Next and previous items in list
  nnoremap <silent> <Leader>sn :<C-u>CocNext<CR>
  nnoremap <silent> <Leader>sp :<C-u>CocPrev<CR>
  nnoremap <silent> <Leader>sl :<C-u>CocListResume<CR>
  " Show commands
  nnoremap <silent> <Leader>sc :<C-u>CocList commands<CR>
  " Find symbol in current document
  nnoremap <silent> <Leader>ss :<C-u>CocList outline<CR>
  " Search workspace symbols
  nnoremap <silent> <Leader>sw :<C-u>CocList -I symbols<CR>

  " Use <c-space> to trigger completion
  inoremap <silent><expr> <c-space> coc#refresh()

  " Scroll in floating window
  nnoremap <expr><C-d> coc#float#has_float() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <expr><C-u> coc#float#has_float() ? coc#float#scroll(0) : "\<C-u>"
  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-e>"
  inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-y>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"
  vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"

  " CoC Intellisense {{{
nmap <silent> <leader>d <Plug>(coc-definition)
inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" }}}



augroup mapping_ale_fix
  autocmd FileType python,javascript,javascript.jsx,
        \ nnoremap  <space>ap :ALEPreviousWrap<cr> |
        \ nnoremap  <space>an :ALENextWrap<cr> |
        \ nnoremap  <space>at :ALEToggle<cr>
augroup END
" }}}
"  Vim Filetype Formatter --- {{{

" " code formatting, thanks sam
" let g:vim_filetype_formatter_verbose = 1
let g:vim_filetype_formatter_commands = {
      \ 'python': 'black - -q --line-length 79',
      \ 'javascript': 'npx -q prettier --parser flow',
      \ 'javascript.jsx': 'npx -q prettier --parser flow',
      \ 'typescript': 'npx -q prettier --parser typescript',
      \ 'typescript.tsx': 'npx -q prettier --parser typescript',
      \ 'css': 'npx -q prettier --parser css',
      \ 'less': 'npx -q prettier --parser less',
      \ 'html': 'npx -q prettier --parser html',
      \ 'vue': 'npx -q prettier --html-whitespace-sensitivity ignore --parser vue --stdin'
      \}
augroup mapping_vim_filetype_formatter
  autocmd FileType python,javascript,javascript.jsx,css,less,json,html
        \ nnoremap <silent> <buffer> <leader>f :FiletypeFormat<cr>
augroup END


"  }}}
""  Plugin: treesitter {{{

function s:init_treesitter()
  if !exists('g:loaded_nvim_treesitter')
    echom 'nvim-treesitter does not exist, skipping...'
    return
  endif
lua << EOF
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  textobjects = { enable = true },
  ensure_installed = {
    'bash',
    'c',
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'lua',
    'python',
    'query',
    'rust',
    'toml',
    'tsx',
    'typescript',
}})
EOF
endfunction

augroup custom_treesitter
  autocmd!
  autocmd VimEnter * call s:init_treesitter()
augroup end
"" General: Key remappings {{{

function! GlobalKeyMappings()
  " Put your key remappings here
  " Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap
  " This is defined as a function to allow me to reset all my key remappings
  " without needing to repeate myself.

  " MoveVisual: up and down visually only if count is specified before
  " Otherwise, you want to move up lines numerically e.g. ignore wrapped lines
  nnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'
  " Escape: also clears highlighting
  nnoremap <silent> <esc> :noh<return><esc>

  " J: basically, unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'
endfunction

call GlobalKeyMappings()

" }}}
" General: Cleanup {{{
" commands that need to run at the end of my vimrc

" disable unsafe commands in your project-specific .vimrc files
" This will prevent :autocmd, shell and write commands from being
" run inside project-specific .vimrc files unless they’re owned by you.
set secure

" }}}

