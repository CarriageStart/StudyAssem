.include "gc_defs.s"

.globl gc_scan_start

# Base objects region : stack + data section
# Start the scan for each base regions.
# Input Parameters  
#   None
# Side effect 
# - gc_scan_recursive
#   %rdi : Start addr of base region
#   %rsi : End addr of base region
#   %rbx : General Purpose
#   %rdx : Addr to test
#   %r8 : heap_start
#   %r9 : heap_end
.section .data # To reference the data region
.section .text
gc_scan_start:
    enter $0, $0
    
    # Inspect from the stack region
    movq stack_end, %rdi
    movq stack_start, %rsi
    #subq %rdi, %rsi
    call gc_scan_recursively
    
    # inspect from the data region
    #  - Change .rodata to .data
    #  => rdata cannot have heap memory reference...
    movq $.data, %rdi
    andq $0xfffffffffffffff8, %rdi
    movq $_end, %rsi
    call gc_scan_recursively

    leave
    ret


