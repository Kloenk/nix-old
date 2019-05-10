{ ... }:

''
  source $VIMRUNTIME/defaults.vim

  " make vim more vimy
  set nocompatible
  
  " encoding
  set encoding=utf-8
  
  " Theme
  "colorscheme afterglow
  
  " UI
  set history=50
  set ruler
  set showcmd
  
  " Tag jumping
  command! MakeTags !ctags -R . --exclude=target &
  
  " File search
  set path+=**
  set wildmenu
  set wildignore+=**/target**,**/*.iml,**/.git/**
  
  " Search
  set hlsearch
  
  " File browsing
  filetype plugin on
  let g:netrw_banner=0        " disable annoying banner
  let g:netrw_browse_split=4  " open in prior window
  let g:netrw_altv=1          " open splits to the right
  let g:netrw_liststyle=3     " tree view
  let g:netrw_list_hide=netrw_gitignore#Hide()
  let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
  
  " Code folding
  set nu
  set foldmethod=indent
  set foldlevel=99
  nnoremap <space> za
  
  " Code styling
  filetype plugin indent on
  syntax on
  
  " Completion
  set autoindent
  inoremap { {<CR>}<ESC>O
  
  " SBT integration
  nnoremap <C-b> :w<CR>:!sbt -client package<CR>:!scala ./target/*/*.jar<CR>
  
  "execute pathogen#infect()
  " filetype plugin indent on
  
  
  " cargo commands
  :com! CargoCheck !cargo check
''
