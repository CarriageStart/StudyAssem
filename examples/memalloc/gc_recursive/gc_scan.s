.globl gc_scan
.section .text

# gc_scan of the current stack and data section
#
# Input Parameters : None
# Side Effects : 
# - gc_scan_unmark
#   %rcx: Addr of memory block to unmakr
#   %rdx: End addr of heap
# - gc_scan_start/gc_scan_recursive
#   %rdi : Start addr of base region
#   %rsi : End addr of base region
#   %rbx : General Purpose
#   %rdx : Addr to test
#   %r8 : heap_start
#   %r9 : heap_end

gc_scan:
    enter $0, $0
    
    # Define stack scan region : by current stack pointor
    movq %rsp, stack_end
    # Mark all as unused.
    call gc_scan_unmark
    #  Recursively find blocks that 
    # can be reachable from the base_object
    call gc_scan_start

    leave
    ret
