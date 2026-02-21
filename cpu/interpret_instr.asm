.section .text

instr_jump_table:
    .word instr_mov_val
    .word instr_mov_reg
    .word instr_add
    .word instr_push
    .word instr_pop
    .word instr_syscall

.extern instr_mov_val
.extern instr_mov_reg
.extern instr_add
.extern instr_push
.extern instr_pop
.extern pc

.global interpret_instr

interpret_instr:
    // Find the matching opcode
    // r0: Memory address of pc

    // Prologue interpret_instr
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Fetch instruction opcode
    ldrb r1, [r0]

    // Select the correct function to call
    cmp r1, #0x1                            // mov value
    moveq r2, #0x0                          // instr_mov_val index
    beq .jump_table                         // Branch to jump table to save isntructions (too cumbersomne to step though)

    cmp r1, #0x2                            // mov reg to reg
    moveq r2, #0x1                          // instr_mov_reg index
    beq .jump_table

    cmp r1, #0x3                            // add
    moveq r2, #0x2                          // instr_add index
    beq .jump_table

    cmp r1, #0x4                            // push
    moveq r2, #0x3                          // instr_push index
    beq .jump_table

    cmp r1, #0x5                            // pop
    moveq r2, #0x4                          // instr_pop index
    beq .jump_table

    cmp r1, #0x6                            // syscall
    moveq r2, #0x5                          // instr_syscall index

.jump_table:
    // Calculate the correct function address in the instr_jump_table
    adr r3, instr_jump_table                // Get address of instr_jump_table
    ldr r4, [r3, r2, lsl #0x2]              // Calculate the address of the correct function. r0 is function index in jmp table. Lsl #0x2 is for 4 byte addresses.
    blx r4                                  // Branch with link to the correct function

    // Epilogue interpret_instr
    mov sp, r11
    pop {r11, lr}
    bx lr
