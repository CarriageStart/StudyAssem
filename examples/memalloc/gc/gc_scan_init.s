.globl gc_scan_init
.section .rodata

# Registers
#   %rdi : size of total data of the program
#   %rdx : size of stack
#   %rcx : size of stack
.secton .text
gc_scan_init:
    enter $0, $0
    
    movq %rsp, stack_end

    # Size of stack
    movq stack_start, %rdi
    subq stack_end, %rdi

    andq $0xfffffffffffffff8, %rdi  # 8 byte align

    # Size of rodata
    movq $.rodata, %rdx
    movq $_end, %rcx
    subq %rdx, %rcx
    addq %rcx, %rdi

    # size of heap
    movq heap_end, %rdx
    subq heap_start, %rdx
    addq %rdx, %rdi

    # 
    
