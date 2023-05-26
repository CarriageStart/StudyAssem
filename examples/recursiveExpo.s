.globl exponent

.section .text
    # %rdi has a base
    # %rsi has a integer exponent
exponent:
    cmpq $1, %rsi
    jne multiply

    movq $1, %rax
    leave
    ret
 
multiply:
    



