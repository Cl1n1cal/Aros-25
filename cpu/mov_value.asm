.section .text

.extern reg_a
.extern reg_b
.extern reg_c
.extern reg_d
.extern reg_e
.extern reg_f
.extern reg_g
.extern reg_s

.extern error

.global instr_mov_val

instr_mov_val:
    // Mov a value into a register. A value is 4 bytes
    // r0: pc addr
    // r1: opcode

    // Fetch target register and fetch value
    ldrb r2, [r0, #0x1]
    ldr r3, [r0, #0x2]

    // Switch on the register operand
    cmp r2, #0x61 // reg_a
    beq .mov_a
    
    cmp r2, #0x62 // reg_b
    beq .mov_b
    
    cmp r2, #0x63 // reg_c
    beq .mov_c
    
    cmp r2, #0x64 // reg_d
    beq .mov_d
    
    cmp r2, #0x65 // reg_e
    beq .mov_e

    cmp r2, #0x66 // reg_f
    beq .mov_f

    cmp r2, #0x67 // reg_g
    beq .mov_g

    cmp r2, #0x73 // reg_s
    beq .mov_s
    
    b error

.mov_a:
    ldr r4, =reg_a
    str r3, [r4]
    b .instr_mov_val_done

.mov_b:
    ldr r4, =reg_b
    str r3, [r4]
    b .instr_mov_val_done

.mov_c:
    ldr r4, =reg_c
    str r3, [r4]
    b .instr_mov_val_done

.mov_d:
    ldr r4, =reg_d
    str r3, [r4]
    b .instr_mov_val_done

.mov_e:
    ldr r4, =reg_e
    str r3, [r4]
    b .instr_mov_val_done

.mov_f:
    ldr r4, =reg_f
    str r3, [r4]
    b .instr_mov_val_done

.mov_g:
    ldr r4, =reg_g
    str r3, [r4]
    b .instr_mov_val_done

.mov_s:
    ldr r4, =reg_s
    str r3, [r4]
    b .instr_mov_val_done



.instr_mov_val_done:
    // Set the size of a mov_val instr as the return value
    mov r0, #0x6
    bx lr
