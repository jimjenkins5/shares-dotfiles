set autoindent
set smartindent
set expandtab
set softtabstop=3
set shiftwidth=3
set noswapfile
set nobackup
set mouse=a
set nojoinspaces
if has("clipboard")
  set clipboard+=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif
set backspace=indent,eol,start
set pastetoggle=<leader>p
highlight ColorColumn ctermbg=1
syntax enable

" GUI Options
set guifont=Ubuntu\ Mono:h12
set guioptions-=T

" REMOVE TRAILING WHITESPACE ON SAVE
autocmd BufWritePre * :%s/\s\+$//e

" PLUGIN SETUP
" load plug
if has("win32")
   call plug#begin('~/vimfiles/plugged')
else
   call plug#begin('~/.vim/plugged')
endif

" Set the timeout for vim-plug to be really high so YouCompleteMe will install
let g:plug_timeout=300

Plug 'editorconfig/editorconfig-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'

" Syntax Files
Plug 'ericpruitt/tmux.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'alunny/pegjs-vim'
Plug 'posva/vim-vue'
Plug 'plasticboy/vim-markdown'

" TypeScript
Plug 'HerringtonDarkholme/yats'
Plug 'quramy/tsuquyomi'

" Color Schemes
Plug 'rafi/awesome-vim-colorschemes'
Plug 'wojciechkepka/vim-github-dark'

call plug#end()
" END PLUGIN SETUP

" Turn on default commenting plugin
try
  packadd comment
catch
endtry

" COLORSCHEME
set background=dark
colorscheme ghdark
" END COLORSCHEME

" YouCompleteMe TypeScript integration
if !exists("g:ycm_semantic_triggers")
   let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

" IGNORE DIRECTORIES FOR ctrlp AND OTHERS
set wildignore+=*/.git/*,*/node_modules/*,*/DS_STORE/*,*/coverage/*,*.swp

" NERDTree setup
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" KEY MAPPINGS
nmap ,f :CtrlP<CR>
map <C-n> :NERDTreeToggle<CR>
map <C-t> :tab sp<CR>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
inoremap ii <esc>
noremap # :set invnumber<CR>
map <leader>\ gcc<CR>
nmap <leader>s :set spell!<CR>
noremap <leader>f :%!python -m json.tool<CR>
" END KEY MAPPINGS

" SPELLCHECK
set spelllang=en_us
" END SPELLCHECK

let g:SuperTabDefaultCompletionType = "context"
let g:jsx_ext_required = 0
let g:vim_markdown_folding_disabled = 1

" indent contents of various html tags that I consider 'block' tags
let g:html_indent_style = "inc"
:let g:html_indent_inctags = "html,head,body,p,tbody,article"

if &term =~ '256color'
   " disable Background Color Erase (BCE) so that color schemes
   " render properly when inside 256-color tmux and GNU screen.
   " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
   set t_ut=
endif

" Set line wrapping for comments to 90 characters
fun! AdjustWrapForLine()
   if !exists('s:lastLine') || line('.') != s:lastLine
      let s:lastLine = line(".")
      let matched = matchstr(getline('.'), '^\s*\/\=\(\*\|\/\)')

      if !empty(matched)
         set textwidth=90
         set colorcolumn=90
      else
         set textwidth=140
         set colorcolumn=140
      endif
   endif
endfun
augroup JSLineWrap
   autocmd FileType javascript
      \ autocmd! JSLineWrap CursorMoved * call AdjustWrapForLine()
augroup END
" End of line wrapping config

" Increase length of commit summary guide
fun! AdjustGitCommitSummary()
   syn clear gitcommitSummary
   syn match gitcommitSummary "^.\{0,69\}" contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
endfun
autocmd FileType gitcommit call AdjustGitCommitSummary()
" End of commit summary guide
