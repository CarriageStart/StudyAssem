
.globl allocate, deallocate
.type allocate, @function
.type deallocate, @function

.section .data
# Information on heap segment.
memory_start:
    .quad 0
memory_end:
    .quad 0

.section .text


# Memory Block structure
#   Header : Uflag(8 bytes) + block size(8 bytes)
#   Data   : %rdi(what is requested)
.equ SIZE_HEADER, 16
.equ HDR_UFLAG_OFFSET, 0
.equ HDR_SIZE_OFFSET, 8


# Syscal for heap access
#    Syscall 12 
#   : move the "program break" of the heap segment by %rdi
#    and return the break location.
.equ BRK_SYSCALL, 12
.equ DEFAULT_HEAP_SIZE, 1024


# Register Convention internally used. (Side Effects)
#   %rdx - size requested
#   %rcx - copy of memory_end
#   %rsi - copy of pointor to current memory being examined

init_heap:
    movq $0, %rdi
    movq $BRK_SYSCALL, %rax
    syscall

    movq %rax, memory_start
    movq %rax, memory_end
    jmp start_alloc


alloc_new_block:
    movq %rcx, %r8

    movq %rcx, %rdi
    addq %rdx, %rdi
    movq %rdi, memory_end

    movq $BRK_SYSCALL, %rax
    syscall

    movq $1, HDR_UFLAG_OFFSET(%r8)
    movq %rdx, HDR_SIZE_OFFSET(%r8)

    addq $SIZE_HEADER, %r8
    movq %r8, %rax
    ret


# Entry Point 1 of this program
# register
# %rdi : size of data allocation
allocate:
    movq %rdi, %rdx
    addq $SIZE_HEADER, %rdx
    
    # First allocation, search heap first.
    cmpq $0, memory_start
    je init_heap

start_alloc:

    movq memory_start, %rsi
    movq memory_end, %rcx
loop_alloc:
    cmpq %rsi, %rcx
    je alloc_new_block

    cmpq $0, HDR_UFLAG_OFFSET(%rsi)
    jne move_next

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb move_next

    # We don't change the size of memory block
    movq $1, HDR_UFLAG_OFFSET(%rsi)
    addq $SIZE_HEADER, %rsi
    movq %rsi, %rax
    ret


move_next:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp loop_alloc



# Entry Point 2 of this program
deallocate:
    # We need to include the header size
    movq $0, HDR_UFLAG_OFFSET - SIZE_HEADER(%rdi)
    ret

