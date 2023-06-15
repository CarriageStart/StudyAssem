.include "gc_defs.s" # Include where you want to use ".equ"
.globl gc_allocate
# Identical to allocate except it alligned stack and alloc size.

.section .text
# Input parameters
#   %rdi - Size requsted
# Side Effect:
#   %rdx - Size requsted
#   %rsi - Current memory examined
#   %rcx - heap end 

# Entry Point
gc_allocate:
    enter $16, $0

    # Calculate the required size in 16 byte aligned
    movq %rdi, %rdx 
    addq $HEADER_SIZE, %rdx
    addq $16, %rdx                 
    andq $0xfffffffffffffff0, %rdx # Align requsted size

    movq %rdx, -8(%rbp)
    # Consider last byte as decimal. Add 1 and floor down.

    movq heap_start, %rsi
    movq heap_end, %rcx

_allocate_loop:
    cmpq %rsi, %rcx
    je allocate_move_break
    
    cmpq $0, HDR_IN_USE_OFFSET(%rsi)
    jne _allocate_move_index

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb _allocate_move_index

    jmp _allocate_init_block

_allocate_move_index:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp _allocate_loop

_allocate_init_block:
    movq $1, HDR_IN_USE_OFFSET(%rsi)

    movq %rsi, %rcx
    addq %rdx, %rcx

    addq $HEADER_SIZE, %rsi

    movq %rsi, %rax
_zero_loop:
    cmpq %rsi, %rcx
    je _return

    movq $0, (%rsi)
    addq $8,  %rsi
    jmp _zero_loop
_return:
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

    movq %rdx, HDR_SIZE_OFFSET(%rsi)
    jmp _allocate_init_block



