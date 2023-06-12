.include "gc_defs.s"

.global gc_scan_memory
.section .text
# Side effect 
#   %rax : current addr on pointor_list
#   %rbx : General Purpose
#   %rcx : Loop
#   %rdx : General Purpose
#   %r8 : heap_start
#   %r9 : heap_end
gc_scan_memory:
    # Input Parameters:
    #   %rdi - smaller address
    #   %rsi - bigger address
    enter $0, $0
    
    movq pointor_list_current, %rax
    movq heap_start, %r8
    movq heap_end, %r9

loop:
    cmpq %rdi, %rsi
    jmp exit_loop


    # Check whether it contains addr on heap(addr + format)
    movq (%rdi), %rdx
    movq %rdx, %rbx
        # Condition on address (Block within heap space)
    subq $HEADER_SIZE, %rbx
    cmpq %rbx, %r8
    jb move_next

    addq HDR_SIZE_OFFSET(%rbx), %rbx
    cmpq %rbx, %r9
    ja move_next

        # Condition on the memory block format : We marked 0.
    cmpq $0, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
    jne move_next


    # Mark and Insert : We postpone Deep inspection
    movq $1, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdx)
        # Insert
    movq HDR_SIZE_OFFSET-HEADER_SIZE(%rdx), %rcx
    subq $HEADER_SIZE, %rcx
insert_loop:
    movq %rdx, (%rax)
    addq $8, %rax
    addq $8, %rdx
    loopq insert_loop
move_next:
    addq $8, %rdi
    jmp loop


exit_loop:
    movq %rax, pointor_list_current
    leave
    ret


