.globl main

.section .data
promptformat:
    .ascii "Enter two numbers separated by spaces, then press return.\n\0"
scanformat:
    .ascii "%d %d\0"
testformat:
    .ascii "%d %d\n\0"
resultformat:
    .ascii "The result if %d.\n\0"

.section .text
.equ LOCAL_NUMBER, -8
.equ LOCAL_EXPONENT, -16

main:
    enter $16, $0

    movq stdout, %rdi
    movq $promptformat, %rsi
    movq $0, %rax
    call fprintf

# For fscanf, you need to nullify the bits
    movq $0, LOCAL_NUMBER(%rbp)
    movq $0, LOCAL_EXPONENT(%rbp)

    movq stdin, %rdi
    movq $scanformat, %rsi
    leaq LOCAL_NUMBER(%rbp), %rdx
    leaq LOCAL_EXPONENT(%rbp), %rcx
    movq $0, %rax
    call fscanf

    movq stdout, %rdi
    movq $testformat, %rsi
    movq LOCAL_NUMBER(%rbp), %rdx
    movq LOCAL_EXPONENT(%rbp), %rcx
    movq $0, %rax
    call fprintf

    movq LOCAL_NUMBER(%rbp), %rdi
    movq LOCAL_EXPONENT(%rbp), %rsi
    call exponent

    movq stdout, %rdi
    movq $resultformat, %rsi
    movq %rax, %rdx
    movq $0, %rax
    call fprintf

    leave
    ret




