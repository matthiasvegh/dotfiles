set nu
set smartindent
set tabstop=4
set shiftwidth=4
set hlsearch
set enc=utf8
set tenc=utf-8
set nocompatible
filetype off
set laststatus=2
set cindent

if $TERM =~ '^screen'
	set t_Co=256
    nmap <Esc>OH <Home>
    imap <Esc>OH <Home>
    vmap <Esc>OH <Home>
    nmap <Esc>OF <End>
	imap <Esc>OF <End>
	vmap <Esc>OF <End>
endif

set smartcase
set incsearch
let mapleader = ","

set colorcolumn=81
set listchars=eol:↲,tab:␉·,trail:␠,nbsp:⎵
autocmd VimEnter * hi SpecialKey term=bold cterm=bold ctermfg=11 ctermbg=None
set list

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Bundles
Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
nnoremap <Leader>t :YcmCompleter GetType<CR>
Plugin 'altercation/vim-colors-solarized'
Plugin 'rosenfeld/conque-term'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
nnoremap <Leader>n :NERDTreeSteppedOpen<cr>
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'vim-jp/cpp-vim'
Plugin 'rhysd/vim-clang-format'
let g:clang_format#command = 'clang-format-3.7'
Plugin 'itchyny/lightline.vim'
set foldmethod=marker
" {{{
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
	  \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
" }}}
set noshowmode
let NERDTreeIgnore = ['\.pyc$', '\.o$']
Plugin 'kana/vim-operator-user'
Plugin 'vim-scripts/TeTrIs.vim'
Plugin 'vim-scripts/cmdalias.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'xolox/vim-misc'
Plugin 'kshenoy/vim-signature'
Plugin 'xolox/vim-session'
:let g:session_autosave = 'yes'
:let g:session_autoload = 'no'
Plugin 'justincampbell/vim-eighties'
let g:eighties_enabled = 0
let g:eighties_minimum_width = 80
let g:eighties_compute = 1 " Disable this if you just want the minimum + extra
Plugin 'vim-scripts/vimux'
Plugin 'tpope/vim-fugitive'
Plugin 'farseer90718/vim-taskwarrior'
Plugin 'Shougo/unite.vim'
nnoremap <silent> <C-p> :Unite -start-insert -buffer-name=files -winheight=10 file_rec/async<cr>
nnoremap <Leader>f :Unite -auto-preview grep:.<cr>
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'tpope/vim-sleuth'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'bbchung/clighter8'
let g:clighter_occurrences_mode=1 " enable fast symbol highlight

if !empty(glob("/usr/lib/x86_64-linux-gnu/libclang-5.0.so"))
  let g:clighter8_libclang_path='/usr/lib/x86_64-linux-gnu/libclang-5.0.so'
endif

Plugin 'rhysd/committia.vim'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'solarnz/thrift.vim'
Plugin 'lyuts/vim-rtags'
Plugin 'majutsushi/tagbar'
nnoremap <buffer><leader>t :TagbarToggle<CR>
"Plugin 'martong/vim-compiledb-path'
"autocmd VimEnter * silent CompileDbPathIfExists compile_commands.json
"autocmd VimEnter * silent CompileDbPathIfExists build/compile_commands.json
Plugin 'wellle/tmux-complete.vim'
let g:tmuxcomplete#trigger = 'omnifunc'
Plugin 'int3/vim-extradite'
Plugin 'wakatime/vim-wakatime'
Plugin 'mfukar/robotframework-vim'
Plugin 'sophacles/vim-processing'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'rhysd/wandbox-vim'
Plugin 'vim-scripts/DrawIt'
Plugin 'w0rp/ale'
let g:ale_linters = {
  \ 'cpp' : []
  \ }
" Bundles over
call vundle#end()
filetype plugin indent on
" YouCompleteMe Config
let g:ycm_global_ycm_extra_conf = '/home/emtyvgh/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'objc' : ['->', '.'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
" clang-format config
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType c,cpp,objc let g:clang_format#auto_format_on_insert_leave=1
autocmd FileType c,cpp,objc hi clighter8MemberRefExpr term=NONE cterm=NONE ctermbg=None ctermfg=187 gui=NONE
autocmd FileType c,cpp,objc hi clighter8MacroInstantiation term=NONE cterm=NONE ctermbg=None ctermfg=5 gui=NONE
autocmd FileType c,cpp,objc hi clighter8Namespace term=NONE cterm=italic ctermbg=None ctermfg=60 gui=NONE
autocmd FileType c,cpp,objc hi link clighter8NamespaceRef clighter8Namespace
autocmd FileType c,cpp,objc hi link clighter8Stat Statement
autocmd VimEnter * Alias W w
autocmd VimEnter * Alias Q q
autocmd VimEnter * Alias Qa qa
autocmd VimEnter * Alias X x

set t_Co=256
syntax on
set background=dark
set backspace=indent,eol,start
colorscheme solarized
" Terminal background is already solarized blue, when chaning tmux panes
" use new background instead of overriding with solarized blue
highlight Normal ctermbg=None
set wildmenu
let g:NERDTreeDirArrows=0
"highlight Comment cterm=underline
"let g:Powerline_symbols = 'fancy'
" now set it up to change the status line based on mode

" bindkeys
map gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap q: :
" Get rid of that pesky q: as I frequently hit q, then try to :! do something
" but can't because qi: opens the bleeding command history window

"set mouse=a
"set ttymouse=xterm2
"above make mouse and tmux integration possible

nnoremap <F10> i
inoremap <F10> <ESC>l
vnoremap <F10> <ESC>l
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
au InsertEnter * hi statusline guibg=Blue ctermfg=8 guifg=White ctermbg=2

nnoremap <esc> :let @/ = ""<return><esc>
imap <S-Tab> <Esc><<i

set t_ZH=[3m
highlight Comment cterm=italic

let shell=$SHELL

if shell == '/usr/bin/zsh'
  set title
endif

if &term == "screen-256color"
  set t_ts=k
  set t_fs=\
endif

set titlestring=vim\ %t

if !empty(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
