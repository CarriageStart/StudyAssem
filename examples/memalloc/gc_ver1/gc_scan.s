.globl gc_scan
.section .text

# Input Parameters : None
# Side Effects : 
#   %rdi
gc_scan:
    enter $0, $0
    
    call gc_scan_init
    call gc_unmark_all
    call gc_scan_base_objects
    call gc_walk_pointors
    call gc_scan_cleanup


    call gc_is_valid_ptr
    cmpq $1, %rax
    jne continue
    leave
    ret
