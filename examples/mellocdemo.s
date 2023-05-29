
.globl main
.section .data
inputFormat:
    .ascii "%499s\0"
outputFormat:
    .ascii "%s\n\0"

.section .text
.equ LOCAL_NUMBER, -8
main:
    enter $16, $0

    movq $500, %rdi
    call malloc
    movq %rax, LOCAL_NUMBER(%rbp)

    movq stdin, %rdi
    movq $inputFormat, %rsi
    movq LOCAL_NUMBER(%rbp), %rdx
    movq $0, %rax
    call fscanf

    movq stdout, %rdi
    movq $outputFormat, %rsi
    movq LOCAL_NUMBER(%rbp), %rdx
    movq $0, %rax
    call fprintf

    movq LOCAL_NUMBER(%rbp), %rdi
    call free

    movq $0, %rax 
    leave
    ret

    
