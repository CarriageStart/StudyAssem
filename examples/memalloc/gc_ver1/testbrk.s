
.globl _start
.section .data
heap_end:
    .quad 0

.section .text
_start:
    # Test register
    movq $-1, %rsi
    movq $-1, %rdx
    movq $-1, %rcx

    movq $0, %rdi
    movq $12, %rax
    syscall
    movq %rax, heap_end

    movq $-1, %rsi
    movq $-1, %rdx
    movq $-1, %rcx

    movq heap_end, %rdi
    addq $16, %rdi
    movq $12, %rax
    syscall
    movq %rax, heap_end


