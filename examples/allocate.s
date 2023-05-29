
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
.equ HDR_SIZE. 16
.equ HDR_UFLAG_OFFSET. 0
.equ HDR_SIZE_OFFSET. 8

.equ BRK_SYSCALL. 12

# register
# %rdi : size of data allocation
allocate:
    movq %rdi, %rdx
    addq HDR_SIZE, %rdx
    
    cmpq $0, memory_start
    je initial_alloc

continue_alloc:
    

initial_alloc:
    addq %rdx, memory_start
