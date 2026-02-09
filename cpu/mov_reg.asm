.section .text

.extern reg_a

.extern error
.extern find_register_index

.global instr_mov_reg


instr_mov_reg:
// Select the correct registers before moving values: reg_0 <- reg_1 like a classic mov instruction
// Return: Size of the mov_reg instruction: 3
// r0: Pointer to pc

    // Prologue - also saving lr for later
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Get index of the first register
    mov r2, r0                  // Mov the pc pointer to r2
    ldrb r0, [r2, #0x1]         // Load the value of the first register
    str r2, [r11, #-0x4]        // Save pc pointer for later use
    bl find_register_index     // Get the index of the register
    str r0, [r11, #-0x8]        // Save the index of the first register for later

    // Get the index of the second register
    ldr r2, [r11, #-0x4]        // Restore the pc pointer
    ldrb r0, [r2, #0x2]         // Load the value of the second register
    bl find_register_index     // Get the index of the register
    str r0, [r11, #-0xc]        // Save the index of the second register for later

    // Compute the address of the first register using reg_a as the offset with index 0
    ldr r0, [r11, #-0x8]        // Load the index value of the first register
    lsl r0, #0x2                // Multiply the index by 4 - to get index-offset
    ldr r1, =reg_a              // Get the address of reg_a to use as base address when offsetting
    add r1, r1, r0              // Add the base address and the index-offset
    str r1, [r11, #-0x8]        // Save the address of the first register for later

    // Compute the address of the second register using reg_a as the offset with index 0
    ldr r0, [r11, #-0xc]        // Load the index value of the first register
    lsl r0, #0x2                // Multiply the index by 4 - to get index-offset
    ldr r1, =reg_a              // Get the address of reg_a to use as base address when offsetting
    add r1, r1, r0              // Add the base address and the index-offset - r1 contains second register address

    // Get the address of the first register and copy the value from reg_1 to reg_0
    ldr r0, [r11, #-0x8]        // Retrieve the address of the first register
    ldr r2, [r1]                // Get the value of the second register
    str r2, [r0]                // Put the value into the first register completing: reg_0 <- reg_1
    
    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr


