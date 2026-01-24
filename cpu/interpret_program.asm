.section .text

.extern interpret_instr
.extern pc
.extern error

.global interpret_program

interpret_program:
    // Set the pc to the start of program memory and exectute instructions from there
    // r0: Start address of the executable program

    // Inc start addr by 4 to skip program signature
    add r0, r0, #0x4

    // Set pc
    ldr r1, =reg_pc
    str r0, [r1]

.interpret_loop:
    // Returns size of instruction
    // Uses the pc to fetch instructions
    bl interpret_instr

    // Incremenet the pc with the return value of interpret_instr
    ldr r2, =reg_pc
    ldr r1, [r2]
    add r1, r1, r0
    str r1, [r2]

    // Run next instr
    b .interpret_loop


