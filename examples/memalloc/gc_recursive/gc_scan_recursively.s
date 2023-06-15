.include "gc_defs.s"

.global gc_scan_recursively
.section .text

# Scan from %rdi to %rsi(except %rsi itself)
# recursively.
#
# Input Parameters:
#   %rdi - smaller address
#   %rsi - bigger address
# Side effect 
#   %rbx : General Purpose
#   %rdx : Addr to test
#   %r8 : heap_start
#   %r9 : heap_end

gc_scan_recursively:
    movq heap_start, %r8
    movq heap_end, %r9

_recursive_loop:
    cmpq %rdi, %rsi
    je _exit_loop

    # Check whether it contains addr on heap(addr + format)
    movq (%rdi), %rdx
    subq $HEADER_SIZE, %rdx 
    movq %rdx, %rbx

        # Condition of start address (Block within heap space)
    cmpq %r8, %rdx
    jb _move_next # jmp %r8 > %rdx
    cmpq %r9, %rdx
    jae _move_next # jmp %r9 <= %rdx

        # Condition of end addr of block
    addq HDR_SIZE_OFFSET(%rdx), %rdx
    cmpq %r9, %rdx
    ja _move_next # %r9 < %rdx

        # Condition on the memory block format : 0 
        #(If 1, it is already checked, otherwise, it is not valid)
    cmpq $0, HDR_IN_USE_OFFSET(%rbx)
    jne _move_next

    # Mark as used
    movq $1, HDR_IN_USE_OFFSET(%rbx)

    # Check the saved data recursively
    pushq %rdi
    pushq %rsi

    addq $HEADER_SIZE, %rbx
    movq %rbx, %rdi
    movq %rdx, %rsi

    call _recursive_loop

    popq %rsi
    popq %rdi

_move_next:
    addq $8, %rdi
    jmp _recursive_loop

_exit_loop:
    ret


