// registers.asm

// General-purpose registers
.global a
.global b
.global c
.global d
.global e

// Special purpose registers
.global pc


.section .data

// General purpose registers 
reg_a: .word 0
reg_b: .word 0
reg_c: .word 0
reg_d: .word 0
reg_e: .word 0

a:
    .word reg_a
b:
    .word reg_b
c:
    .word reg_c
d:
    .word reg_d
e:
    .word reg_e

// Special purpose registers
reg_pc: .word 0

pc:
    .word reg_pc
