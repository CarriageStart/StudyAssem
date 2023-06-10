.globl retain, release
.globl get_count

.section .text
.equ REFCOUNT_OFFSET, -16

retain:
    incq REFCOUNT_OFFSET(%rdi)
    ret

release:
    cmpq $0, REFCOUNT_OFFSET(%rdi)
    jbe release_ret

    decq REFCOUNT_OFFSET(%rdi)
release_ret:
    ret

get_count:
    movq REFCOUNT_OFFSET(%rdi), %rax
    ret
