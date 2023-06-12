.include "gc_defs.s"
.globl gc_walk_pointors

.equ LCL_SAVED_RBX, -16
gc_walk_pointors:
    enter $16, $0
    
    movq pointor_list_end, %rbx
    movq %rbx, LCL_SAVED_RBX(%rbp)
    movq pointor_list_start, %rbx
loop: 
    cmpq %rbx, pointor_list_current
    je finish

    movq (%rbx), %rdi
    cmpq $1, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
    je continue

    call gc_is_valid_ptr
    cmpq $1, %rax
    jne continue


