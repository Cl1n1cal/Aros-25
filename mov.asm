.section .text

.extern a
.extern b
.extern c
.extern d
.extern e

.global instr_mov
.type instr_mov, @function

instr_mov:
    // Find the correct register to load the value into 
    // r0 : register
    // r1 : value

    // Switch on the register operand
    cmp r0, #0x61 // a 
    beq mov_a
    cmp r0, #0x62 // b
    beq mov_b
    cmp r0, #0x63 // c
    beq mov_c
    cmp r0, #0x64 // d
    beq mov_d
    cmp r0, #0x65 // e
    beq mov_e
    b error

mov_a:
    ldr r0, =a
    str r1, [r0]
    b done

mov_b:
    ldr r0, =b
    str r1, [r0]
    b done

mov_c:
    ldr r0, =c
    str r1, [r0]
    b done

mov_d:
    ldr r0, =d
    str r1, [r0]
    b done

mov_e:
    ldr r0, =e
    str r1, [r0]
    b done

done:
    bx

error:
    // Exit with error 0xff
    mov r0, #0xff
    mov r7, #1
    swi 0
