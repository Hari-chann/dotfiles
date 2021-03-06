" Install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plug by :PlugInstall
" Plug url is after 'github.com/'
" to Remove plug
"   delete the plug line 
"   source .vimrc
"   then run :PlugClean, choose yes to delete directories 

call plug#begin('~/.vim/plugged')

Plug 'andymass/vim-matchup'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdtree'
Plug 'sharkdp/fd'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'pangloss/vim-javascript'
Plug 'sainnhe/sonokai'
Plug 'srcery-colors/srcery-vim'
Plug 'ghifarit53/tokyonight-vim'


call plug#end()

set backspace=indent,eol,start
set clipboard^=unnamed,unnamedplus
set encoding=utf-8
set expandtab
set hidden
set hlsearch
set incsearch
set laststatus=2
set list
set noswapfile
set nowrap
set number
set shiftwidth=2
set signcolumn=number
set tabstop=2

set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
" off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
" off and the line continues beyond the left of the screen

function! FilePath()
  return expand('%') !=# '' ? expand('%') : '[No Name]'
endfunction

function! GetCWD()
  return fnamemodify(getcwd(), ':t')
endfunction

let g:lightline = {
      \ 'colorscheme': 'tokyonight',
       \ 'active': {
       \   'left': [ [ 'mode',  'paste', 'gitbranch' ],
       \             [ 'readonly', 'filepath', 'modified' ] ],
       \   'right': [ [ 'lineinfo' ],
       \              [ 'percent' ],
       \              [ 'cwd', 'fileformat', 'fileencoding', 'filetype' ] ]
       \ },
       \ 'inactive': {
       \   'left': [ [ 'mode',  'paste', 'gitbranch' ],
       \             [ 'mode', 'readonly', 'filepath', 'modified' ],
       \             [ 'mode', 'readonly', 'filepath', 'modified' ] ]
       \ },
       \ 'component_function': {
       \   'gitbranch': 'fugitive#head',
       \   'filepath': 'FilePath',
       \   'cwd': 'GetCWD'
       \ }
      \ }

let g:sonokai_style = 'atlantis'
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 1

" vim window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Jump to tag in vertical split
nnoremap <silent> <C-w>} :exec ':vert stjump' expand('<cword>')<CR>

" Hide highlighting of current search results
nnoremap <silent> <CR> :nohlsearch<CR>

"## nerdtree config ##
" Toggle NERDTree show
map <C-n> :NERDTreeToggle<CR>

"Open current file directory
map <C-o> :NERDTreeToggle %<CR>
" disabled C-Z suspending vim / tmux
nnoremap <c-z> <nop>

" fzf config
nnoremap <C-p> :Files<CR>
let $FZF_DEFAULT_COMMAND = "fd --type file --hidden --no-ignore --exclude '{.git,node_modules,vendor,build,tmp,sorbet,flow-typed}'"
let $FZF_DEFAULT_OPTS = "--color bg+:-1,hl:107,hl+:114,fg:245,fg+:255"

nnoremap <C-f> :Rg<Space>

syntax on
set t_Co=256
" set up truecolors
if (has("termguicolors"))
  set termguicolors
endif

colorscheme tokyonight 
set background=dark

" vim-matchup config
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_hi_surround_always = 1
let g:javascript_plugin_flow = 1

hi MatchParen ctermfg=11
hi MatchParen guifg=darkyellow

" Set vim's bg to transparent so that it adapts to
" current terminal's bg color.
" hi normal ctermbg=NONE


" Search through methods in current file using tags
function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
     let maxes[i] = max([get(maxes, i, 0), len(list[i])])
     let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
    \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    call fzf#run({
    \ 'source':  s:btags_source(),
    \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
    \ 'down':    '40%',
    \ 'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! BTags call s:btags()
nnoremap <C-b> :BTags<CR>

" Prepend rubocop linter and fixer with 'bundle exec'
let g:ale_ruby_rubocop_executable = 'bundle'

" Configure fixers for ALE
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'ruby': ['rubocop']
\}

au FocusLost,WinLeave * :silent! w " Saves when exiting the buffer or losing focus
"au FocusGained,BufEnter * :silent! ! " reloads file when entering the buffer or gaining focus

"Bind F8 to fixing problems with ALE
nnoremap <F8> :ALEFix<CR>

" Bind F5 to source vimrc
nnoremap <F5> :so $MYVIMRC<CR>
