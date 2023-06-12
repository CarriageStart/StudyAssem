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


    #  Size of rodata : In some platform, 
    # segment aligned in 4 byte.
    movq $.rodata, %rdx
    andq $0xfffffffffffffff8, %rdx  # 8 byte align
    movq $_end, %rcx
    subq %rdx, %rcx
    addq %rcx, %rdi

    # Size of heap
    movq heap_end, %rdx
    subq heap_start, %rdx
    addq %rdx, %rdi

    # Initiate the pointor space
    movq pointor_list_start, %rdx
    movq %rdx, pointor_list_current

    addq %rdx, %rdi
    movq %rdi, pointor_list_end 
    movq $BRK_SYSCALL, %rax
    syscall
    
    leave
    ret
    
