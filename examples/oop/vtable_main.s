.globl main
.section .text

main:
    .equ LCL_CAT, -8
    .equ LCL_DOG, -16

    enter $16, $0

    call cat_new
    movq %rax, LCL_CAT(%rbp)
    call dog_new
    movq %rax, LCL_DOG(%rbp)

    movq LCL_CAT(%rbp), %rdi
    movq $cat_vtable_animal, %rsi
    call doThing

    movq LCL_DOG(%rbp), %rdi
    movq $dog_vtable_animal, %rsi
    call doThing

    movq LCL_CAT(%rbp), %rdi
    call free

    movq LCL_DOG(%rbp), %rdi
    call free

    leave
    ret

