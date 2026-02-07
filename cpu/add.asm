.section .text
.extern reg_a
.extern reg_b
.extern reg_c
.extern reg_d
.extern reg_e
.extern find_register_index

.global instr_add

instr_add:
// Adds the value of two registers like Arm does: r0, r1, x0 for example
// r0: The memory address of pc


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

    // Get the index of the third register
    ldr r2, [r11, #-0x4]        // Restore the pc pointer
    ldrb r0, [r2, #0x3]         // Load the value of the second register
    bl find_register_index     // Get the index of the register
    str r0, [r11, #-0x10]       // Save the index of the second register for later

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
    str r1, [r11, #-0xc]        // Save the address of the second register for later

    // Compute the address of the second register using reg_a as the offset with index 0
    ldr r0, [r11, #-0x10]       // Load the index value of the first register
    lsl r0, #0x2                // Multiply the index by 4 - to get index-offset
    ldr r1, =reg_a              // Get the address of reg_a to use as base address when offsetting
    add r1, r1, r0              // Add the base address and the index-offset - r1 contains third register address

    // Get the value of third register and add it to the value of the second register
    ldr r3, [r1]                // Get the value of the third register
    ldr r1, [r11, #-0xc]        // Get the address of the second register
    ldr r2, [r1]                // Get the value of the second register
    add r2, r2, r3              // Add the second and third register values
    ldr r1, [r11, #-0x8]             // Get the address of the first register
    str r2, [r1]                // Write the result of the addition on the address of the first register

    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr
    