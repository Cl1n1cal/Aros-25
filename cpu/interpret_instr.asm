.section .text

.extern instr_mov_val
.extern pc

.global interpret_instr

interpret_instr:
    // Find the matching opcode
    // r0: Memory address of pc

    push {r14}

    // Fetch instruction opcode
    ldrb r1, [r0]

    cmp r1, #0x1 // mov value
    beq instr_mov_val

    cmp r1, #0x2 // mov reg to reg
    beq instr_mov_reg

    pop {r14}
    bx lr


.section .data


