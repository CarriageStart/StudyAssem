
.globl main
.section .data
output:
    .ascii "Hello!\n\0"

.section .text
main:
    enter $0, $0

    movq stdout@GOTPCREL(%rip), %rdi
    movq (%rdi), %rdi
    leaq output(%rip), %rsi
    movq $0, %rax
    call fprintf@plt

    movq $0, %rax

    leave
    ret


