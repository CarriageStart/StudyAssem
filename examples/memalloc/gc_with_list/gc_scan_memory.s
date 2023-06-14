.include "gc_defs.s"

.global gc_scan_memory
.section .text


# Side effect 
#   %rbx : General Purpose
#   %rdx : Addr to test
#   %r8 : heap_start
#   %r9 : heap_end
gc_scan_memory:
    # Input Parameters:
    #   %rdi - smaller address
    #   %rsi - bigger address
    movq heap_start, %r8
    movq heap_end, %r9

_loop:
    cmpq %rdi, %rsi
    je _exit_loop


    # Check whether it contains addr on heap(addr + format)
    movq (%rdi), %rdx
    subq $HEADER_SIZE, %rdx 
    movq %rdx, %rbx
        # Condition on address (Block within heap space)
    cmpq %rdx, %r8
    jb _move_next

    addq HDR_SIZE_OFFSET(%rdx), %rdx
    cmpq %rdx, %r9
    ja _move_next

        # Condition on the memory block format : 0 
        #(If 1, it is already checked, otherwise, it is not valid)
    cmpq $0, HDR_IN_USE_OFFSET - HEADER_SIZE(%rbx)
    jne _move_next

    # Mark as used
    movq $1, HDR_IN_USE_OFFSET - HEADER_SIZE(%rbx)

    # Check the saved data recursively
    pushq %rdi
    pushq %rsi

    movq %rbx, %rdi
    movq %rdx, %rsi

    call _loop

    popq %rsi
    popq %rdi

_move_next:
    addq $8, %rdi
    jmp _loop

_exit_loop:
    ret


