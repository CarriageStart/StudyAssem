.include "gc_defs.s"

.globl gc_scan_base_objects

    # Base objects region : stack + data section
.section .text
gc_scan_base_objects:
    enter $0, $0
    
    # Inspect from the stack region
    movq stack_end, %rdi
    movq stack_start, %rsi
    subq %rdi, %rsi
    call gc_scan_memory
    
    # inspect from the data region
    movq $.rodata, %rdi
    andq $0xfffffffffffffff8, %rdi
    movq $_end, %rsi
    subq %rdi, %rsi
    call gc_scan_memory

    leave
    ret


