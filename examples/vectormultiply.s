
.globl main
.section .data
# 4byte(single) * 4 * 8 bits/byte = 128 bits
# The whole array can be stored in one SSE register.
# This also 16-byte-aligned.
starting_value: 
    .single 2.1, 2.1, 2.1, 2.1
multiply_by:
    .single 5.0, 6.0, 7.0, 8.0
print_out:
    .ascii "The result is %f, %f, %f, %f.\n\0"

.section .text
main:
    enter $0, $0
    # The data is already packed(array) in start.

    # Instruction to move whole 128 bits.
    movaps starting_value, %xmm5
    movaps multiply_by, %xmm4
    
    # Vector operation in single unit.
    mulps %xmm4, %xmm5

    # Unpacking the data for print
    movss %xmm5, %xmm0
    cvtss2sd %xmm0, %xmm0   # formatting for fprintf
    psrldq $4, %xmm5
    movss %xmm5, %xmm1
    cvtss2sd %xmm1, %xmm1   # formatting for fprintf
    psrldq $4, %xmm5
    movss %xmm5, %xmm2
    cvtss2sd %xmm2, %xmm2   # formatting for fprintf
    psrldq $4, %xmm5
    movss %xmm5, %xmm3
    cvtss2sd %xmm3, %xmm3   # formatting for fprintf
    movq $4, %rax           # Expect not to refer to memory

    # Print out (Expect to refer to memory)
    movq stdout, %rdi
    movq $print_out, %rsi
    #movq $4, %rax          # For optimisation, pack the register operations.
    call fprintf
    
    leave
    ret

