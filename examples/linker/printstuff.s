.globl printstuff

.section .data
mytext:
    .ascii "Hello, There?!\n\0"

.section .text
printstuff:
    enter $0, $0

    movq stdout@GOTPCREL(%rip), %rdi
    movq (%rdi), %rdi
    leaq mytext(%rip), %rsi
    movq $0, %rax
    call fprintf@plt

    leave
    ret

