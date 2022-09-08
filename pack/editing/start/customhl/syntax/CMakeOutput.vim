syntax match Progress "\[.\+\]"
syn keyword DiagnosticError error FAILED
syn keyword DiagnosticWarn warning warn 
syn keyword DiagnosticInfo note
syn match DiagnosticError "\^\~\+"
syn keyword Actions Building Linking Generating
syn match Compilers "[a-zA-Z0-9/\.\_\-+]\+g++\(-\d\+\)\{0,1\}" 
syn match Compilers "[a-zA-Z0-9/\.\_\-+]\+gcc\(-\d\+\)\{0,1\}" 
syn match Compilers "[a-zA-Z0-9/\.\_\-+]\+cc\(-\d\+\)\{0,1\}" 
syn match Compilers "[a-zA-Z0-9/\.\_\-+]\+clang\(-\d\+\)\{0,1\}" 
syn match Compilers "[a-zA-Z0-9/\.\_\-+]\+clang++\(-\d\+\)\{0,1\}" 
syn match Launcher "[a-zA-Z0-9/\.\_\-+]\+ccache\(-\d\+\)\{0,1\}" 
syn keyword TargetType executable library object C CXX

syn match translationUnit '[a-zA-Z0-9/\.\_\-+]\+\.\(cpp\|cxx\|c\|hpp\|hxx\.gch\|hxx\|h\)\(\.o\)\{0,1\}\(:\d\+\)\{0,2\}'

hi def link Progress PreProc
hi def link Actions Statement
hi def link Compilers Character
hi def link Launcher Compilers
hi def link translationUnit Directory
hi def link TargetType Statement
