# My first assembly program. This is a comment.
.global _start

.section .text

_start:
    movq $60, %rax
    movq $3, %rdi
    syscall
