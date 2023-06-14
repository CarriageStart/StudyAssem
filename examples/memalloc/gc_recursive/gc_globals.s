.include "gc_defs.s"

.globl heap_start, heap_end, stack_start, stack_end

.section .data
heap_start:
    .quad 0
heap_end:
    .quad 0
stack_start:
    .quad 0
stack_end:
    .quad 0

