.section .data

mystr: .asciz "Hello world\n"


.section .text

.extern print

.global _start

_start:
    // call print
    mov r1, #0xc
    ldr r0, =mystr
    bl print

    // exit
    mov r7, #0x1
    mov r0, #0x0
    swi 0


