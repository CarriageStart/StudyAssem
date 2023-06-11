.globl gc_scan
.section .text

# Input Parameters : None
# Side effect 
#   %rax : current addr on pointor_list
#   %rbx : addr examined
#   %rdx : heap_start
#   %rcx : heap_end
#   %r8  : Pointor in heap size
#   %rdi : Inspection start loc
#   %rsi : Inspection end loc
gc_scan:
    enter $0, $0
    
    #call gc_scan_init
    call gc_unmark_all
    call gc_scan_base_objects
    #call gc_walk_pointors
    #call gc_scan_cleanup

    leave
    ret
