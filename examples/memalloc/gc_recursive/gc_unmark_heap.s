.include "gc_defs.s"

.globl gc_scan_unmark
.section .text
# Mark all heap data as "not-used".
#
# No input parameters
# Side Effects :
#   %rcx : Ptr to memory block examined
#   %rdx : End addr of heap
gc_scan_unmark:
    enter $0, $0

    movq heap_start, %rcx
    movq heap_end, %rdx

loop:
    cmpq %rcx, %rdx
    je finish
    
    movq $0, HDR_IN_USE_OFFSET(%rcx)
    addq HDR_SIZE_OFFSET(%rcx), %rcx
    jmp loop

finish:
    leave 
    ret
