
syn match execution '\[.+\]'
syn keyword DiagnosicKeywords error warning warn note
syn keyword Compilers g++ gcc cc cc1 cc1plus cc1plusplus ninja
syn match translationUnit ' .*\.c'
syn match translationUnit ' .*\.cpp'

hi def link execution Constant
hi def link DiagnosicKeywords PreProc
hi def link Compilers Statement
hi def link translationUnit Type
