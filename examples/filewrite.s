.globl main

.section .data
filename:
    .ascii "./myfile.txt\0"
openmode:
    .ascii "w\0"

formatstring1:
    .ascii "Tha age of %s is %d.\n\0"
sallyname:
    .ascii "Sally\0"
sallyage:
    .quad 32

formatstring2:
    .ascii "%d and %d are %s's favorite numbers\n\0"
joshname:
    .ascii "Josh\0"
joshnum1:
    .quad 3
joshnum2:
    .quad 7

.section .text
main:
    # 8 byte : FILE pointor
    enter $16, $0


    movq $filename, %rdi
    movq $openmode, %rsi
    call fopen
    # Here should be null check.
    cmpq $0, %rax
    je finish

    movq %rax, -8(%rbp)


    movq -8(%rbp), %rdi
    movq $formatstring1, %rsi
    movq $sallyname, %rdx
    movq sallyage, %rcx
    movq $0, %rax                   # Denote end of variadic function input parameters
    call fprintf

    
    movq -8(%rbp), %rdi
    movq $formatstring2, %rsi
    movq joshnum1, %rdx
    movq joshnum2, %rcx
    movq $joshname, %r8
    movq $0, %rax
    call fprintf

    movq -8(%rbp), %rdi
    call fclose

    movq $0, %rax
    leave 
    ret

finish:
    movq $60, %rax
    leave
    ret

