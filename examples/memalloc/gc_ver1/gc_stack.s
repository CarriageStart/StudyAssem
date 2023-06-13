
# Stack data structure for pointor list
.globl gc_stack_init, gc_push_pointor, gc_pop_pointor, gc_push_block

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
    # Input parmeter
    #   %rdi : addr of pointor to push
    #
    # Side Effects
    #   %rsi : Addr to put in
    #   %rdx : Curretn stack point
    #   %rax : In case of side effect

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
    # Return : -1 (no entry), pointor (if any)
    # Side Effect
    #   %rdi : Current stack point
    #   %rax : Return value
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


gc_push_block:
    # Input parmeter
    #   %rdi : Start addr to push
    #   %rsi : Number of bytes to push
    # Side Effects
    #   %rdx : Start addr to push
    #   %rcx : Current stack point
    #   %rax : Side effect of syscall 12

    enter $0, $0    
    movq %rdi, %rdx

    # Currently free size
    movq pointor_stack_current, %rdi
    movq %rdi, %rcx
    addq %rsi, %rdi

    # Check whether extension needed
    cmpq %rdi, pointor_stack_end
    jb _push_block
    
    # Extend the pointor stack
    movq %rdi, pointor_stack_end
        # Avoid side effect of syscall
    movq %rdi, %rsi
        # Syscall 12
    movq $BRK_SYSCALL, %rax
    syscall

    # Push the block
_push_block: 
        # Restore destination addr of stack
    movq %rsi, %rdi
_push_block_loop:
    cmpq %rcx, %rdi
    je _end_push_block

    movq %rdx, (%rcx)

    add $8, %rcx
    add $8, %rdx
    jmp _push_block_loop

_end_push_block:
    movq %rdi, pointor_stack_current
    leave
    ret



