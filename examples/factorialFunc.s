.globl factorial

.equ LOCAL_NUM, -8

.section .text
    # %rdi is the value for factorial.
factorial:
    # We will reserve space for 1 variable 
    # => the value we were called with.
    enter $16, $0

    cmpq $1, %rdi
    jne stackValue
    
    movq %rdi, %rax
    leave
    ret

stackValue:
    movq %rdi, LOCAL_NUM(%rbp)
    decq %rdi
    call factorial

    mulq LOCAL_NUM(%rbp)
    leave
    ret
