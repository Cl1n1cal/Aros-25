// registers.asm

// General-purpose registers
.global reg_a
.global reg_b
.global reg_c
.global reg_d
.global reg_e
.global reg_f
.global reg_g
.global reg_s                       // Used for selecting syscalls

// Special purpose registers
.global reg_pc
.global reg_bp
.global reg_sp

.section .data

// General purpose registers 
reg_a: .word 0
reg_b: .word 0
reg_c: .word 0
reg_d: .word 0
reg_e: .word 0
reg_f: .word 0
reg_g: .word 0
reg_s: .word 0

// Special purpose registers
reg_pc: .word 0
reg_bp: .word 0
reg_sp: .word 0

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

    cmp r0, #0x66                   // f
    moveq r0, #0x05
    beq .find_register_index_done

    cmp r0, #0x67                   // g
    moveq r0, #0x06
    beq .find_register_index_done

    cmp r0, #0x73                   // s
    moveq r0, #0x07
    beq .find_register_index_done

    // Special purpose has 0x10 as base and then 0x11, 0x12, 0x13 ... and so on
    cmp r0, #0x11                   // pc
    moveq r0, #0x08
    beq .find_register_index_done

    cmp r0, #0x12                   // bp
    moveq r0, #0x09
    beq .find_register_index_done

    cmp r0, #0x13                   // sp
    moveq r0, #0x0a
    beq .find_register_index_done


    b error                         // If no register was found - give error

.find_register_index_done:
    bx lr
