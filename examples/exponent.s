.globl exponent                        # Function name
.type exponent, @function               
    # ".type" directive sets the type of the symbol
    # There are "function", "object", and "tls_object"
    # It is used for optimization purpose.

.section .text
exponent:
    # %rdi has a base
    # %rsi has a integer exponent

    enter $16, $0
    movq %rsi, -8(%rbp)
    movq $1, %rax

mainloop:
    mulq %rdi
    decq -8(%rbp)
    jnz mainloop

complete:
    leave
    ret
