.include "gc_defs.s"

.global gc_scan_memory
.section .text
# Side effect 
#   %rbx : addr examined
#   %rdx : heap_start
#   %rcx : heap_end
#   %r8 : Pointor in heap size
gc_scan_memory:
    # Input Parameters:
    #   %rdi - smaller address
    #   %rsi - bigger address
    enter $0, $0
    
    movq heap_start, %rdx
    movq heap_end, %rcx
    movq $HEADER_SIZE, %r8
    addq $16, %r8       # Heap is aligned in 16 bytes

loop:
    cmpq %rdi, %rsi
    jmp exit_loop

    movq %rdi, %rbx
inspection:
    # Condition on address (within heap space)
    cmpq %rbx, %rdx
    jb move_next

    cmpq %rbx, %rcx
    jae move_next

    # Mark as used
    movq $1, HDR_IN_USE_OFFSET(%rbx)

    # Deep inspection
        # Check the size 
    cmpq %r8, HDR_SIZE_OFFSET(%rbx)
    jne move_next

        # Inspect the pointing location
    movq HEADER_SIZE(%rbx), %rbx
    jmp inspection

move_next:
    addq $8, %rdi
    jmp loop

exit_loop:
    leave
    ret


