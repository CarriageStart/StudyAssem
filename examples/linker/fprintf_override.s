
.globl fprintf
.section .data
mytext:
    .ascii "Haha! I intecepted you!\n"
mytext_end:

.section .text
fprintf:
    movq $1, %rdi
    leaq mytext(%rip), %rsi
    movq $(mytext_end - mytext), %rdx

    movq $1, %rax
    syscall
    ret

