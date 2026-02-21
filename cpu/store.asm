.section .text
.extern reg_a
.extern reg_b
.extern reg_c
.extern reg_d
.extern reg_e
.extern reg_f
.extern reg_g
.extern reg_s

.extern find_register_index

.global instr_add

instr_store:
// Stores the value of the first register in the memory address held in the second register
// r0: The memory address of pc


    // Prologue - also saving lr for later
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10






    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr
    