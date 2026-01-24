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

