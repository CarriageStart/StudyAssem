.globl squareme
.type squareme, @function

.section .text
squareme:
    movq %rdi, %rax
    imulq %rdi
    ret
