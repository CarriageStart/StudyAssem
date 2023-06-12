
# Stack data structure for pointor list
.globl gc_stack_init, gc_push_pointor, gc_pop_pointor

.section .text
.equ gc_default_stack_extension, 256
gc_stack_init:
    # Input parameters
    # %rdi : End of heap
    # %rsi : Requseted Size of pointor stack
    enter $0, $0    
    
    movq %rdi, pointor_stack_start
    movq %rdi, pointor_stack_current

    addq %rsi, %rdi
    movq %rdi, pointor_stack_end
    movq $BRK_SYSCALL, %rax
    syscall

    leave
    ret


gc_push_pointor:
    # %rdi : addr of pointor
    enter $0, $0    
    movq %rdi, %rsi

    movq pointor_stack_current, %rdx
    movq pointor_stack_end, %rdi

    # Check whether extension needed
    cmpq %rdx, %rdi
    jb _push

    addq gc_default_stack_extension, %rdi
    movq %rdi, pointor_stack_end
    movq $BRK_SYSCALL, %rax
    syscall

_push: 
    movq %rsi, (%rdx)
    addq $8, %rdx
    movq %rdx, pointor_stack_current

    leave
    ret


gc_pop_pointor:
    enter $0, $0

    movq pointor_stack_current, %rdi
    cmpq %rdi, pointor_stack_start
    je _no_entry

    subq $-8, %rdi
    movq (%rdi), %rax
    movq %rdi, pointor_stack_current
    leave
    ret

_no_entry:
    movq $-1, %rax
    leave
    ret


