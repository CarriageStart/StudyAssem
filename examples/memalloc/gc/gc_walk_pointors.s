.include "gc_defs.s"
.globl gc_walk_pointors

.equ LCL_SAVED_RBX, -16
gc_walk_pointors:
    enter $16, $0
    
    movq %rbx, LCL_SAVED_RBX(%rbp)
    movq pointor_list_start, %rbx
