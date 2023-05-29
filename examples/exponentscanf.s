.globl main

.section .data
promptformat:
    .ascii "Enter two numbers separated by spaces, then press return.\n\0"
scanformat:
    .ascii "%ld %ld\0"
testformat:
    .ascii "%ld %ld\n\0"
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

    # Many c library is optimized for 32 bit processor.
    # "fscanf" also operates in extended word size("%ebx"), therefore,
    # the most-significant 32 bits are not updated in fscanf operation. 
    # Therefore, you need to innitialize the value.
    #movq $0, LOCAL_NUMBER(%rbp)
    #movq $0, LOCAL_EXPONENT(%rbp)

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




