
.globl _start
.section .text
_start:
    movq $4, %rdi
    movq $2, %rsi
    call exponent

    movq %rax, %rdi
    movq $60, %rax
    syscall
