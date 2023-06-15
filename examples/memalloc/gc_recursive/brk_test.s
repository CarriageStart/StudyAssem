
.globl main
.section .data
output:
    .ascii "The RDX value is %d.\n\0"
output2:
    .ascii "Syscall 12 doesn't change RDX.\n\0"

.section .text
main:
    enter $16, $0
    movq $-1, %rdx
    
    movq $0, %rdi
    movq $12, %rax
    syscall
    movq %rax, -8(%rbp)

    movq stdout, %rdi
    movq $output, %rsi
    movq $0, %rax
    call fprintf
    
    cmpq $-1, %rdx
    call _print

    movq $-1, %rdx
    movq -8(%rbp), %rdi
    addq $16, %rdi
    movq $12, %rax
    syscall

    movq stdout, %rdi
    movq $output, %rsi
    movq $0, %rax
    call fprintf

    cmpq $-1, %rdx
    call _print

    leave
    ret

_print:
    enter $0, $0

    movq stdout, %rdi
    movq $output2, %rsi
    movq $0, %rax
    call fprintf

    leave
    ret

