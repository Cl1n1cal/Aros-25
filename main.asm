# test program
.section .data
reg_a: .word 0
reg_b: .word 0
reg_c: .word 0
reg_d: .word 0
reg_e: .word 0

.section .text

.global _start
_start:
    // Find the correct register to load the value into 
    // r0 : register
    // r1 : value

    // Switch on the register operand
    cmp r0, #0x61 // a 
    be imm_a
    cmp r0, #0x62 // b
    be imm_b
    cmp r0, #0x63 // c
    be imm_c
    cmp r0, #0x64 // d
    be imm_d
    cmp r0, #0x65 // e
    be imm_e
    mov r0, #0xff // error
    b error

imm_a:
    ldr r0, a
    str r1, [r0]
    b done

imm_b:
    ldr r0, b
    str r1, [r0]
    b done

imm_c:
    ldr r0, c
    str r1, [r0]
    b done

imm_d:
    ldr r0, d
    str r1, [r0]
    b done

imm_e:
    ldr r0, e
    str r1, [r0]
    b done

done:
    // Exit routine
    mov r7, #1
    swi 0

error:
    // Exit with error 0xff
    mov r7, #1
    swi 0
    

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
