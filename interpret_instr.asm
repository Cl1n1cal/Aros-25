.section .text

.extern instr_mov

.global _start

_start:
    // Find the matching opcode 
    // r0 : opcode
    // r1 : reg
    // r2 : reg/value

    cmp r0, #0x1 // mov
    mov r0, r1
    mov r1, r2
    beq instr_mov
    b error

error:
    // Exit with error 0xff
    mov r0, #0xff
    mov r7, #1
    swi 0

.section .data

op_mov: .byte 0x1 

