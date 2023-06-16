.globl multbyten
.section .data
ten:
    .quad 10

.section .text
multbyten:
    enter $0, $0

    movq ten(%rip), %rax
    imulq %rdi

    leave
    ret

