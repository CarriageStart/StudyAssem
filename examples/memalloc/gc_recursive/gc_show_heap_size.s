.globl gc_show_heap_size

# Accumulate the used heap size and print
# Input Parameters
#   None
# Side Effects
#   %rsi : Start addr of heap
#   %rdi : End addr of heap
#   %rcx : Back-up of %rdx
#   %rdx : Accumulated size
# Output 
#   Bytes of used
.section .data
output:
    .ascii "Currently, %d bytes are used in heap\n\0"
.section .text
gc_show_heap_size:
    enter $0, $0

    movq $0, %rdx
    movq heap_start, %rsi
    movq heap_end, %rdi

_loop:
    cmpq %rsi, %rdi
    je _finish_loop

    cmpq $1, HDR_IN_USE_OFFSET(%rsi)
    jne _move_next

    addq HDR_SIZE_OFFSET(%rsi), %rdx
    
_move_next:
    addq HDR_SIZE_OFFSET(%rsi), %rsi
    jmp _loop
    
_finish_loop:
    movq stdout, %rdi
    movq $output, %rsi
    movq $0, %rax
    call fprintf

    movq %rdx, %rax
    leave
    ret
    
