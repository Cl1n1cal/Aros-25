.section .text

.extern interpret_instr
.extern pc
.extern error

.global interpret_program

interpret_program:
    // Set the pc to the start of program memory and exectute instructions from there
    // r0: Start address of the executable program
    
    // Prologue
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10


    // Inc start addr by 4 to skip program signature
    add r0, r0, #0x4

    // Set pc
    ldr r1, =reg_pc
    str r0, [r1]

.interpret_loop:
// Runs through the program instructions using the pc

    // Find the size of the instruction using the opcode
    ldr r1, =reg_pc
    ldr r1, [r1]
    ldrb r0, [r1]                           // Opcode of current instruction
    bl .get_instr_size
    str r0, [r11, #-0x4]                    // Store the instruction size

    // Interpret the instruction
    ldr r1, =reg_pc
    ldr r0, [r1]                            // Use the actual memory address of the pc
    bl interpret_instr

    // Increment the program counter using the previously fetched size
    ldr r0, [r11, #-0x4]                    // Fetched the saved instruction size
    ldr r2, =reg_pc
    ldr r1, [r2]                            // Get the memory address of the pc
    add r1, r1, r0                          // Increment the address of the pc
    str r1, [r2]                            // Store the new address of the pc

    // Run next instr
    b .interpret_loop

    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr

.get_instr_size:
// Uses a switch statement to find the opcode
// Return: The size of the instruction
// r0: The opcode value of the instruction
    
    cmp r0, #0x1                    // Mov val
    moveq r0, #0x6                  // Size of mov val
    beq .get_instr_size_done

    cmp r0, #0x2                    // Mov reg
    moveq r0, #0x3                  // Size of mov reg
    beq .get_instr_size_done

    cmp r0, #0x2                    // Add
    moveq r0, #0x3                  // Size of add
    beq .get_instr_size_done

    cmp r0, #0x6                    // Syscall
    moveq r0, #0x1                  // Size of syscall
    beq .get_instr_size_done

.get_instr_size_done:
    bx lr
