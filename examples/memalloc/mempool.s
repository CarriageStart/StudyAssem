.globl allocate, deallocate, deallocate_pool

.section .data
memory_start:
    .quad 0
memory_end:
    .quad 0

.section .text
.equ HEADER_SIZE, 32    # 3 * 8 bytes : addtional 8 bytes for allignment
# Contents
.equ HDR_IN_USE_OFFSET, 0
.equ HDR_SIZE_OFFSET, 8
.equ HDR_POOL_OFFSET, 16

.equ BRK_SYSCALL, 12


# Side Effects
#  %r10 - Memory pool pointor
#  %rdx - Size requested
#  %rsi - Pointor to current memory examined.
#  %rcx - Copy of memory_end

# Entry Point1
allocate:
    # Input parmeters : 
    #   %rdi - MemoryPool Pointor
    #   %rsi - Requseted size
    enter $0, $0
    movq %rdi, %r10
    movq %rsi, %rdx
    addq $HEADER_SIZE, %rdx

    movq memory_start, %rsi
    movq memory_end, %rcx

    cmpq $0, %rsi
    je init_heap

allocate_loop:
    cmpq %rsi, %rcx
    je new_block    # Allocate new block and return

    cmpq $0, HDR_IN_USE_OFFSET(%rsi)
    jne move_index

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb move_index
    
    movq $1, HDR_IN_USE_OFFSET(%rax)
    movq %r10, HDR_POOL_OFFSET(%rax)
    addq $HEADER_SIZE, %rsi
    movq %rsi, %rax
    leave
    ret
    
move_index:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp allocate_loop
    
new_block:
    movq %rcx, %r8

    movq %rcx, %rdi
    addq %rdx, %rdi
    movq %rdi, memory_end
    movq $BRK_SYSCALL, %rax
    syscall

    movq $1, HDR_IN_USE_OFFSET(%r8)
    movq %rdx, HDR_SIZE_OFFSET(%r8)
    movq %r10, HDR_POOL_OFFSET(%r8)

    addq $HEADER_SIZE, %r8
    movq %r8, %rax
    leave
    ret

init_heap:
    movq $0, %rdi
    movq $BRK_SYSCALL, %rax
    syscall
    
    movq %rax, memory_start
    movq %rax, memory_end

    movq %rax, %rsi
    movq %rax, %rcx
    jmp allocate_loop


# Entry Point2  : Optimized for pool.
deallocate:
    # rdi : Block to deallocate
    movq %rdi, %rsi
    subq $HEADER_SIZE, %rsi
deallocate_block:
    movq $0, HDR_IN_USE_OFFSET(%rsi)
    movq $0, HDR_POOL_OFFSET(%rsi)
    ret


# Entry Point3
deallocate_pool:
    movq %rdi, %r10

    movq memory_start, %rsi
    movq memory_end, %rcx

deallocate_pool_loop:   # There are more passes : Optimize the jump
    cmpq %rsi, %rcx
    je deallocate_pool_ret

    cmpq %r10, HDR_POOL_OFFSET(%rsi)
    je deallocate_block

    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp deallocate_pool_loop

deallocate_pool_ret:
    ret
    



