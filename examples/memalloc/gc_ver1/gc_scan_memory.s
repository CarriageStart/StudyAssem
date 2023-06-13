.include "gc_defs.s"

.global gc_scan_memory
.section .text


# Side effect 
#   %rbx : General Purpose
#   %rdx : Addr to test
#   %r8 : heap_start
#   %r9 : heap_end
#   %r10 : current addr on pointor_stack
gc_scan_memory:
    # Input Parameters:
    #   %rdi - smaller address
    #   %rsi - bigger address
    enter $0, $0
    
    movq pointor_stack_current, %r10
    movq heap_start, %r8
    movq heap_end, %r9

_loop:
    cmpq %rdi, %rsi
    jmp _exit_loop


    # Check whether it contains addr on heap(addr + format)
    movq (%rdi), %rdx
    movq %rdx, %rbx
        # Condition on address (Block within heap space)
    subq $HEADER_SIZE, %rdx
    cmpq %rdx, %r8
    jb _move_next

    movq %rbx, %rdx
    addq HDR_SIZE_OFFSET(%rdx), %rdx
    cmpq %rdx, %r9
    ja _move_next

        # Condition on the memory block format : 0 or 1
    movq %rbx, %rdx
    cmpq $0, HDR_IN_USE_OFFSET(%rdx)
    je _continue
    cmpq $1, HDR_IN_USE_OFFSET(%rdx)
    je _continue
    jmp _move_next

_continue:
    pushq %rdi
    pushq %rsi

    # Mark and Insert : We postpone Deep inspection
    movq $1, HDR_IN_USE_OFFSET(%rdx)
    movq HDR_SIZE_OFFSET(%rdx), %rsi
    addq $HEADER_SIZE, %rdx
        # Insert
    movq %rdx, %rdi
    call gc_push_block

    movq %rbx, %rdx
    popq %rsi
    popq %rdi

_move_next:
    addq $8, %rdi
    jmp _loop

_exit_loop:
    leave
    ret


