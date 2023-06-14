
.globl gc_init
# Initiate the garbage collector
# - Store stack start position
# - Initiate heap and store heap info.
#
# Input parameters 
#   None
# Side Effects 
#   %rdi : Input parameter for syscall 12
#   %rax : Input parameter for syscall 12

.section .text
gc_init:
    movq %rbp, stack_start  
    enter $0, $0    
    
    movq $0, %rdi
    movq $BRK_SYSCALL, %rax
    syscall
    
    movq %rax, heap_start
    movq %rax, heap_end
    
    leave
    ret


# Book implementation
    # Initiate Stack and Heap
    # No "enter" instruction : 
    #       assume %rbp has the previous strack base addr
    #movq $rbp, stack_start  
    #
    #movq $0, %rdi
    #movq $BRK_SYSCALL, %rax
    #syscall
    #
    #movq %rax, heap_start
    #movq %rax, heap_end
    #
    #ret
    

    
