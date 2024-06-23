set background=dark

set termguicolors

set cursorline

hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "vimvscode"

hi Normal guibg=#1E1E1E
hi NonText guifg=bg
hi comment guifg=#6A9955
hi string guifg=#CE9178
hi number guifg=#B5CEA8
hi special guifg=#D7BA7D
hi constant guifg=#569CD6
hi operator guifg=#D4D4D4
hi type guifg=#569CD6
hi statement guifg=#C586C0
hi preproc guifg=#C586C0
hi Visual guibg=#264F78
hi StatusLine guifg=#007ACC guibg=#FFFFFF
hi LineNr guifg=#858585
hi CursorLine cterm=NONE guibg=NONE
hi CursorLineNr cterm=NONE guifg=#C6C6C6

set laststatus=2

set statusline=Ln\ %l,\ Col\ %c%=%y
