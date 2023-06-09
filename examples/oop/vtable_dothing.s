
.globl doThing
.section .text
    # Input parameters :
    #   rdi : object pointor
    #   rsi : vtable pointor

doThing:
    .equ LCL_ANIMAL_OBJ_OFFSET, -8
    .equ LCL_ANIMAL_VTABLE_OFFSET, -16

    enter $16, $0
    #  Usually, the input parameters in registers, which frequently 
    # and continually used are needed to be stored in stack space.
    movq %rdi, LCL_ANIMAL_OBJ_OFFSET(%rbp)
    movq %rsi, LCL_ANIMAL_VTABLE_OFFSET(%rbp)

    # Speak!
    call *VTABLE_ANIMAL_SPEAK_OFFSET(%rsi)

    # Eat!
    movq LCL_ANIMAL_OBJ_OFFSET(%rbp), %rdi
    movq LCL_ANIMAL_VTABLE_OFFSET(%rbp), %rsi
    call *VTABLE_ANIMAL_EAT_OFFSET(%rsi)

    leave
    ret

