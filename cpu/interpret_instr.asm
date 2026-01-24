.section .text

.extern instr_mov_val
.extern pc

.global interpret_instr

interpret_instr:
    // Find the matching opcode
    // This part of the program uses the pc for reference

    push {r14}

    // Fetch instruction opcode
    ldr r0, =reg_pc
    ldr r0, [r0]
    ldrb r1, [r0]

    cmp r1, #0x1 // mov value
    beq instr_mov_val

    cmp r1, #0x2 // mov reg to reg
    beq instr_mov_reg

    pop {r14}
    bx lr


.section .data


