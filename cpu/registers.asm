// registers.asm

// General-purpose registers
.global reg_a
.global reg_b
.global reg_c
.global reg_d
.global reg_e

// Special purpose registers
.global reg_pc


.section .data

// General purpose registers 
reg_a: .word 0
reg_b: .word 0
reg_c: .word 0
reg_d: .word 0
reg_e: .word 0

// Special purpose registers
reg_pc: .word 0

.section .text

.extern error
.global find_register_index

find_register_index:
// Find the register index according to the value in r0
// Register reg_a has index 0 and we can use that to get the other register addresses
// Return: Index value of the specified register
// r0: Contains register value e.g. 0x61 for reg_a
    cmp r0, #0x61                   // a
    moveq r0, #0x0
    beq .find_register_index_done

    cmp r0, #0x62                   // b
    moveq r0, #0x1
    beq .find_register_index_done

    cmp r0, #0x63                   // c
    moveq r0, #0x02
    beq .find_register_index_done

    cmp r0, #0x64                   // d
    moveq r0, #0x03
    beq .find_register_index_done

    cmp r0, #0x65                   // e
    moveq r0, #0x04
    beq .find_register_index_done

    b error                         // If no register was found - give error

.find_register_index_done:
    bx lr
