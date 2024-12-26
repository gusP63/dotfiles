let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source '~/.vimrc' 
endif

"Preferences
set termguicolors
set noshowmode
let mapleader=" "
set tabstop=4
set shiftwidth=4
set expandtab

function! Formatonsave()
  let l:formatdiff = 1
  py3f /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

" PLUGINS
call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'terryma/vim-smooth-scroll'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'yegappan/lsp'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tmsvg/pear-tree'

call plug#end()

" FZF
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" THEME
color catppuccin_mocha
let g:lightline = {'colorscheme': 'catppuccin_mocha'}
set encoding=UTF_8
set number
set relativenumber

" KEYBINDINGS
nnoremap <leader>e :NERDTreeFocus<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <leader>fm :LspFormat<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fa :Files ~<CR>

let lspOpts = #{
        \   aleSupport: v:false,
        \   autoComplete: v:true,
        \   autoHighlight: v:false,
        \   autoHighlightDiags: v:true,
        \   autoPopulateDiags: v:false,
        \   completionMatcher: 'case',
        \   completionMatcherValue: 1,
        \   diagSignErrorText: 'E>',
        \   diagSignHintText: 'H>',
        \   diagSignInfoText: 'I>',
        \   diagSignWarningText: 'W>',
        \   echoSignature: v:false,
        \   hideDisabledCodeActions: v:false,
        \   highlightDiagInline: v:true,
        \   hoverInPreview: v:false,
        \   ignoreMissingServer: v:false,
        \   keepFocusInDiags: v:true,
        \   keepFocusInReferences: v:true,
        \   completionTextEdit: v:true,
        \   diagVirtualTextAlign: 'after',
        \   diagVirtualTextWrap: 'default',
        \   noNewlineInCompletion: v:false,
        \   omniComplete: v:null,
        \   outlineOnRight: v:false,
        \   outlineWinSize: 20,
        \   semanticHighlight: v:true,
        \   showDiagInBalloon: v:false,
        \   showDiagInPopup: v:false,
        \   showDiagOnStatusLine: v:false,
        \   showDiagWithSign: v:true,
        \   showDiagWithVirtualText: v:true,
        \   showInlayHints: v:true,
        \   showSignature: v:true,
        \   snippetSupport: v:false,
        \   ultisnipsSupport: v:false,
        \   useBufferCompletion: v:false,
        \   usePopupInCodeAction: v:false,
        \   useQuickfixForLocations: v:false,
        \   vsnipSupport: v:false,
        \   bufferCompletionTimeout: 100,
        \   customCompletionKinds: v:false,
        \   completionKinds: {},
        \   filterCompletionDuplicates: v:false,
	\ }

autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
	\	  name: 'clang',
	\	  filetype: ['c', 'cpp'],
	\	  path: '/usr/bin/clangd',
	\	  args: ['--background-index']
	\ }]
autocmd User LspSetup call LspAddServer(lspServers)




