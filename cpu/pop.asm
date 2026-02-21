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

.global instr_pop

instr_pop:
// Increments reg_sp by 4 bytes (1 address) and writes value from address into register
// Should not be able to pop beyond the reg_bp - use reg_bp as guard
// r0: The memory address of pc

    // Prologue - instr_pop
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    // Fetch instruction information
    ldrb r0, [r0, #0x1]                 // Load the register that we wish to pop into
    bl find_register_index              // Get the index of the register

    ldr r1, =reg_a                      // Load the address of the first register
    lsl r0, #0x2                        // Multiply the register index by 4 - to get index-offset
    add r0, r0, r1                      // Add the base address and the index-offset to get the correct register

    // Read the value on the stack before incrementing reg_sp
    ldr r2, =reg_sp                     // Load the address of reg_sp
    ldr r2, [r2]                        // Load the memory address at reg_sp
    ldr r3, [r2]                        // Load the value at the memory address of reg_sp (to be put into the desired register)
    str r3, [r0]                        // Store the value into the specified register
    add r2, r2, #0x4                    // Increment the stack address by 1 memory slot (0x4 bytes)
    
    // Check reg_sp aginst the reg_bp to prevent OOB read
    ldr r3, =reg_bp                     // Load the address of reb_bp
    ldr r3, [r3]                        // Load the memory address at reg_bp
    cmp r2, r3                          // Compare updated reg_sp to the reb_bp (Should be lower or equal)
    bgt error                           // If reg_sp is greater than than reb_bp of stack there is OOB read

    // Update the address in reg_sp
    ldr r1, =reg_sp                     // Load the address of reg_sp
    str r2, [r1]                        // Save the updated reg_sp memory address into reg_sp

    // Epilogue instr_pop
    mov sp, r11
    pop {r11, lr}
    bx lr
    