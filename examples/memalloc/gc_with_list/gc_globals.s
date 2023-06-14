.include "gc_defs.s"

.globl heap_start, heap_end, stack_start, stack_end
.globl pointor_stack_start, pointor_stack_end, pointor_stack_current

.section .data
heap_start:
    .quad 0
heap_end:
    .quad 0
stack_start:
    .quad 0
stack_end:
    .quad 0

.equ pointor_stack_start, heap_end
pointor_stack_end:
    .quad 0
pointor_stack_current:
    .quad 0


