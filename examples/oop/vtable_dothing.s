
.globl doThings
.section text

doThings:
    .equ LCL_ANIMAL_OBJ_OFFSET, -8
    .equ LCL_ANIMAL_VTABLE_OFFSET, -16

    enter $16, $0
    mvoq %rdi, LCL_ANIMAL_OBJ_OFFSET(%rbp)
    mvoq %rsi, LCL_ANIMAL_OBJ_OFFSET(%rbp)


