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
.equ HDR_CNTFLAG_OFFSET, 0
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


# Entry Point 1 of this program
allocate:
    #   Inputs parameter :
    #   %rdi => size of data allocation
    movq %rdi, %rdx
    addq $SIZE_HEADER, %rdx
    
    # Check whether the heap is initialized.
    cmpq $0, memory_start
    je init_heap

start_alloc:                # Rather than storing the return address
    movq memory_start, %rsi # jmp is more fast(addr is labeled in instruction)!
    movq memory_end, %rcx

loop_alloc:
    cmpq %rsi, %rcx
    je alloc_new_block

    cmpq $0, HDR_CNTFLAG_OFFSET(%rsi)
    jne move_next

    cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
    jb move_next

    # We don't change the size of memory block
    movq $1, HDR_CNTFLAG_OFFSET(%rsi)
    addq $SIZE_HEADER, %rsi
    movq %rsi, %rax
    ret

move_next:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp loop_alloc

alloc_new_block:
    movq %rcx, %r8              # We have enough number of hands.

    movq %rcx, %rdi
    addq %rdx, %rdi
    movq %rdi, memory_end

    movq $BRK_SYSCALL, %rax
    syscall

    movq $1, HDR_CNTFLAG_OFFSET(%r8)
    movq %rdx, HDR_SIZE_OFFSET(%r8)

    addq $SIZE_HEADER, %r8
    movq %r8, %rax
    ret

init_heap:
    #  Syscall 12 (brk) moves the memory break(the end of memory segmenation)
    # by %rdi, and return new address of the memory break.
    movq $0, %rdi               # If rdi==0, it just give memory break address.
    movq $BRK_SYSCALL, %rax     # Since no heap space is used, it is start address
    syscall                     # of heap space.

    movq %rax, memory_start
    movq %rax, memory_end
    jmp start_alloc



# Entry Point 2 of this program
deallocate:
    # We need to include the header size
    movq $0, HDR_CNTFLAG_OFFSET - SIZE_HEADER(%rdi)
    ret

