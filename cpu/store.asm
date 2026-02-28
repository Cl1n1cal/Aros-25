.section .text
.extern reg_a
.extern reg_b
.extern reg_c
.extern reg_d
.extern reg_e
.extern reg_f
.extern reg_g
.extern reg_s
.extern RW_guard

.extern find_register_index

.global instr_store

instr_store:
// Stores the value of the first register in the memory address held in the second register
// r0: The memory address of pc
// Returns: void

    // Prologue
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Get index of the first register
    mov r2, r0                  // Mov the pc pointer to r2
    ldrb r0, [r2, #0x1]         // Load the value of the first register
    str r2, [r11, #-0x4]        // Save pc pointer for later use
    bl find_register_index      // Get the index of the register
    str r0, [r11, #-0x8]        // Save the index of the first register for later

    // Get the index of the second register
    ldr r2, [r11, #-0x4]        // Restore the pc pointer
    ldrb r0, [r2, #0x2]         // Load the value of the second register
    bl find_register_index      // Get the index of the register
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

    // Get the value in the first register and store at the address contained in the 2nd register
    ldr r0, [r11, #-0x8]        // Load the address of the first register
    ldr r0, [r0]                // Load the value at the first register
    ldr r1, [r1]                // Load the (should be address) value in the 2nd register

    // Securtity check before storing
    ldr r3, =RW_guard           // Get the value at RW_guard
    cmp r1, r3                  // Compare the memory address to RW_guard
    blt error                   // If the target address is below RW_guard then exit the program

    // Store the value
    str r0, [r1]                // Store the value in the first register into the (should be) memory address in the 2nd register

    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr
    