.globl main

.section .data

formatstring1:
    .ascii "The age of %s is %d.\n\0"
kihoonname1:
    .ascii "Kihoon\0"
kihoonage1:
    .quad 27
    
formatstring2:
    .ascii "%d and %d are %s's favorite numbers\n\0"
joshname:
    .ascii "Josh\0"
joshnum1:
    .quad 3
joshnum2:
    .quad 7

.section .text
main:
    movq stdout, %rdi
    movq $formatstring1, %rsi
    movq $kihoonname1, %rdx
    movq kihoonage1, %rcx
    movq $0, %rax
    call fprintf


    movq stdout, %rdi
    movq $formatstring2, %rsi
    movq joshnum1, %rdx
    movq joshnum2, %rcx
    movq $joshname, %r8
    movq $0, %rax
    call fprintf
    

    movq $0, %rax
    ret

finish:
    movq $60, %rax
    ret

    



