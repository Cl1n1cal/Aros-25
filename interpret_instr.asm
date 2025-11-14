.section .text

.extern instr_mov

.global interpret_instr
.type interpret_instr, @function

interpret_instr:
    // Find the matching opcode 
    // r0 : opcode
    // r1 : reg
    // r2 : reg/value

    cmp r0, #0x1 // mov
    mov r0, r1
    mov r1, r2
    bl instr_mov
    bx

error:
    // Exit with error 0x1
    mov r0, #0x1
    mov r7, #1
    swi 0

.section .data

op_mov: .byte 0x1 

