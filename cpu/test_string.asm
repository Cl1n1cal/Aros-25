.section .data

mystr: .asciz "Hello world\n"


.section .text

.extern print
.extern strlen

.global _start

_start:
    // call get_str_len
    ldr r0, =mystr
    bl strlen

    // call print using the result of strlen
    mov r1, r0
    ldr r0, =mystr
    bl print

    // exit
    mov r7, #0x1
    mov r0, #0x0
    swi 0


