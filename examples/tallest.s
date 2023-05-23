
.globl _start
.section .text
_start:
    leaq people, %rbx   # %rbx points to one record.
    movq numpeople, %rcx
    # Tallest value
    movq $0, %rdi

    # Precondition (Early Exit)
    cmpq $0, %rcx
    je finish

    # Main Loop
mainloop:
    movq HEIGHT_OFFSET(%rbx), %rax
    cmpq %rdi, %rax
    jbe loop_control
    movq %rax, %rdi

loop_control:
    add $PERSON_RECORD_SIZE, %rbx
    loopq mainloop

finish:
    movq $60, %rax
    syscall
    

