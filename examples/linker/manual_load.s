.globl main

.section .data
filename:
    .ascii "libmymath.so\0"
functionname:
    .ascii "printstuff\0"
   
.section .text
main:
    enter $0, $0

    movq $filename, %rdi
    movq $1, %rsi       # flag for lazy-loading
    call dlopen

    movq %rax, %rdi
    movq $functionname, %rsi
    call dlsym

    call *%rax

    leave
    ret
