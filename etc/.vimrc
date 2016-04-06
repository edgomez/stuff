" Author: Edouard Gomez
" Last Edited: 2004-05-16

" No Vi compatible mode
:set nocp

" Enable syntax 
:syntax on

" Force noautoindent by default
:set noautoindent

" Do use backpace the way it is meant to be
:set bs=2

" Show the ruler all the time
:set ruler

" Show the current mode
:set showmode

" Show the current command being typed
:set showcmd

" Enable incremental searching by default
:set incsearch

" Highlight the matches of the last search
:set showmatch

" Don't wrap text
:set nowrap

" No beep beep, just screen flashes
:set visualbell

" Use the emacs colorscheme
":colorscheme wintersday

" Use a mono font in GUI
:set guifont=Bitstream\ Vera\ Sans\ Mono\ 8

" Use css for html output
:let html_use_css=1

" Don't put swp files everywhere but there
:set directory=~/.vim/swp/

" This function is used for C/Java/C++ editing.
:function MyCStyle()
	:set noexpandtab
	:set tabstop=8
	:set shiftwidth=8 
	:set cindent
	:set cinkeys=0{,0},:,0#,!<Tab>,!^F,!o,!O
   	:set formatoptions=tcqor
	:set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
:endfunction

" Java addons to the C style
:function MyJavaStyle()
        :let java_mark_braces_in_parens_as_errors=1
        :let java_highlight_all=1
        :let java_highlight_debug=1
        :let java_ignore_javadoc=1
        :let java_highlight_java_lang_ids=1
        :let java_highlight_functions="style"
        :let java_minlines=150
:endfunction

" XviD specific addons to the C style
:function XviDStyle()
	:set tabstop=4
	:set shiftwidth=4 
:endfunction

:function XMLStyle()
	:set tabstop=2
	:set shiftwidth=2
	:set expandtab
:endfunction

" diff mode bindings
:function MyDiffBindings()
	:if &diff != 0
		:nmap <Buffer> <BS> [c
		:nmap <Buffer> <Space> ]c
	:endif
:endfunction

" Some automatic rules for certain files
:au BufRead *.xml,*.html,*.htm,*.xhtml call XMLStyle()
:au BufRead *.c,*.cpp,*.java,*.cc,*.h call MyCStyle()
:au BufRead /*/xvidcore*/*.[ch] call XviDStyle()
:au BufRead *.java call MyJavaStyle()
:au BufRead /tmp/mutt-* set textwidth=62

" Allow buffer editing w/o auto writing, a must have
:set hidden

" Flush buffers when closing them
:set nobuflisted

" Convenient shortcuts for directory editor
:noremap <silent> <F4> :e! ~/C<CR>
:noremap <silent> <F5> :e! .<CR>

" Bind buffer explorer actions
:let g:bufExplorerSortBy='mru'
:noremap <silent> <F6> :BufExplorer<CR>

" Taglist related init
:let Tlist_Ctags_Cmd="ctags-exuberant"
:nnoremap <silent> <F7> :Tlist<CR>
:nnoremap <silent> <F8> :TlistUpdate<CR>
:nnoremap <silent> <F9> :TlistClose<CR>
