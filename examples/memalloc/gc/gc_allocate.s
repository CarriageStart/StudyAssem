.include "gc_defs.s" # Include where you want to use ".equ"
.globl gc_allocate
# Identical to allocate except it alligned stack and alloc size.

.section .text
# Side Effect:
#   %rdx - Size requsted
#   %rsi - Current memory examined
#   %rcx - heap end 

# Entry Point
gc_allocate:
    # Input parameters
    #   %rdi - Size requsted
    enter $16, $0
    movq %rdi, -8(%rbp)

    movq %rdi, %rdx 
    addq $HEADER_SIZE, %rdx
    addq $16, %rdx                  # Align requsted size
    andq $0xfffffffffffffff0, %rdx
    # Consider last byte as decimal. Add 1 and floor down.

    movq heap_start, %rsi
    movq heap_end, %rcx

allocate_loop:
    cmpq %rsi, %rcx
    je allocate_move_break
    
    cmpq $0, HDR_IN_USE_OFFSET(%rsi)
    jne allocate_move_index

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb allocate_move_index

    jmp allocate_init_block

allocate_move_index:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp allocate_loop

allocate_init_block:
    movq $1, HDR_IN_USE_OFFSET(%rsi)
    movq %rdx, HDR_SIZE_OFFSET(%rsi)
    addq $HEADER_SIZE, %rsi

    movq %rsi, %rax
    movq -8(%rbp), %rcx
_zero_loop:
    movq $0, (%rsi)
    incq %rsi
    loop _zero_loop
    
    leave
    ret

allocate_move_break:
    movq %rcx, %rsi
    # %rsi, %rdx should be intact.

    movq %rcx, %rdi
    addq %rdx, %rdi
    movq %rdi, heap_end
    movq $BRK_SYSCALL, %rax     # Note syscall 12 changes %rcx
    syscall                     # But leave %rsi and %rdx intact.

    jmp allocate_init_block



