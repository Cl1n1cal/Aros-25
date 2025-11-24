.section .text

.global _start

_start:
    mov r0, #1
    ldr r1, =IB
    str r0, [r1]
    mov r0, #0

.section .data

IB: .zero 16

.equ IDENTIFIER, 0x1
