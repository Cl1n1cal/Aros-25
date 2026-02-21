.section .text

.extern reg_a
.extern reg_b
.extern reg_c
.extern reg_d
.extern reg_e
.extern reg_f
.extern reg_g
.extern reg_pc
.extern reg_bp
.extern reg_sp

.extern find_register_index
.extern error
.extern stack

.global instr_push

instr_push:
// Increments reg_sp by 4 bytes (1 address) and writes value at address
// Should not be able to push beyond the top of the stack.
// Using the stack address (contains in stack varaiable from main.asm) for guarding top of stack
// r0: The memory address of pc

    // Prologue - instr_push
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Fetch instruction information
    ldrb r0, [r0, #0x1]                 // Load the register that we wish to push
    bl find_register_index              // Get the index of the register

    ldr r1, =reg_a                      // Load the address of the first register
    lsl r0, #0x2                        // Multiply the register index by 4 - to get index-offset
    add r0, r0, r1                      // Add the base address and the index-offset
    ldr r0, [r0]                        // Load the register value at the register address (to be pushed to the stack)

    // Increment reg_sp before writing to the stack
    ldr r2, =reg_sp                     // Load the address of reg_sp
    ldr r2, [r2]                        // Load the memory address at reg_sp
    sub r2, r2, #0x4                    // Subtract (stack grows downwards) the stack address by 1 memory slot (0x4 bytes)
    
    // Check reg_sp aginst the top of the stack to prevent OOB write
    ldr r3, =stack                      // Load the address of the stack
    ldr r3, [r3]                        // Load the memory address at stack
    cmp r2, r3                          // Compare updated reg_sp to the top of the stack (lowest addr)
    ble error                           // If reg_sp is equal or less than the top of stack there is OOB
    
    // Write the value from the specified register into the updated reg_sp memory address
    str r0, [r2]                        // Writing the value to the stack address

    // Update the address in reg_sp
    ldr r1, =reg_sp                     // Load the address of reg_sp
    str r2, [r1]                        // Save the updated reg_sp memory address into reg_sp

    // Epilogue instr_push
    mov sp, r11
    pop {r11, lr}
    bx lr
    