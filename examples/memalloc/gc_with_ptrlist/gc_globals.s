.include "gc_defs.s"

.globl heap_start, heap_end, stack_start, stack_end
.globl pointor_list_start, pointor_list_end, pointor_list_current

.section .data
heap_start:
    .quad 0
heap_end:
    .quad 0
stack_start:
    .quad 0
stack_end:
    .quad 0

.equ pointor_list_start, heap_end
pointor_list_end:
    .quad 0
pointor_list_current:
    .quad 0


