.section .text

.extern instr_mov_val
.extern instr_mov_reg
.extern instr_add
.extern pc

.global interpret_instr

interpret_instr:
    // Find the matching opcode
    // r0: Memory address of pc

    // Prologue
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Fetch instruction opcode
    ldrb r1, [r0]

    // Set the link register to the end of this function. This way the called function can bx lr when done
    ldr r14, =.interpret_instr_done

    // Select the correct function to call
    cmp r1, #0x1 // mov value
    beq instr_mov_val                       // Branch to target function

    cmp r1, #0x2 // mov reg to reg
    beq instr_mov_reg

    cmp r1, #0x3 // add
    beq instr_add

    cmp r1, #0x6 // syscall
    beq instr_syscall

.interpret_instr_done:
    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr
