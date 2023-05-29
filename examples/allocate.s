
.globl allocate, deallocate
.type allocate, @function
.type deallocate, @function

.section .data
memory_start:
    .quad 0
memory_end:
    .quad 0

.section .text

# Memory Block Header structure
.equ SIZE_HEADER. 16
.equ HDR_UFLAG_OFFSET. 0
.equ HDR_SIZE_OFFSET. 8

.equ BRK_SYSCALL. 12

# Register used internally
#   %rdx - size requested
#   %rcx - copy of memory_end
#   %rsi - copy of pointor to current memory being examined

search_heap:
    movq $0, %rdi
    movq $BRK_SYSCALL, %rax
    syscall

    movq %rax, memory_start
    movq %rax, memory_end
    jmp start_alloc

move_break:
    movq %rcx, %r8
    movq %rcx, %rdi
    addq %rdx, %rdi
    movq %rdi, momery_end

    movq $BRK_SYSCALL, %rax
    syscall

    movq $1, HDR_UFLAG_OFFSET(%r8)
    movq %rdx, HDR_SIZE_OFFSET(%r8)

    addq $HEADER_SIZE, %r8
    movq %r8, %rax
    ret

# register
# %rdi : size of data allocation
allocate:
    movq %rdi, %rdx
    addq $SIZE_HEADER, %rdx
    
    # First allocation, search heap first.
    cmpq $0, memory_start
    je search_heap

start_alloc:
    movq memory_start, %rsi
    movq memory_end, %rcx

loop_alloc:
    cmpq %rsi, %rcx
    je movq_break

    cmpq $0, HDR_UFLAG_OFFSET(%rsi)
    jne move_next

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb move_next

    # We don't change the size of memory block
    movq %1, HDR_UFLAG_OFFSET(%rsi)
    addq $SIZE_HEADER, %rsi
    movq %rsi, %rax
    ret


move_next:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp loop_alloc

deallocate:
    # We need to include the header size
    movq $0, HDR_UFLAG_OFFSET - SIZE_HEADER(%rdi)
    ret

