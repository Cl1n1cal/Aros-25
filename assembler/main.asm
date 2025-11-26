
.section .text

// Standard imports
.extern error
.extern print
.extern strlen
.extern fopen
.extern fread

// Memory handling
.extern alloc_mem
.extern mslot0
.extern mslot0_s

.global _start

_start:
    // Check number of cmd line arguments is 2
    ldr r0, [sp]
    cmp r0, #0x2
    bne print_err_and_exit

    // Open the first argument early to prevent race TOCTOU
    add sp, sp, #0x8
    ldr r0, [sp]
    bl fopen

    // Store the file desc. in fhandle
    ldr r1, =fhandle
    str r0, [r1]

    // Allocate memory before reading the file
    ldr r0, =mslot0
    ldr r1, =mslot0_s
    mov r2, #0x1000
    str r2, [r1]

    bl alloc_mem

    // Read from the file and into the allocated memory
    // r0
    ldr r0, =fhandle
    ldr r0, [r0]
    // r1
    ldr r1, =mslot0
    ldr r1, [r1]
    // r2
    ldr r2, =mslot0_s // r2
    ldr r2, [r2]
    bl fread

    // Call the lexer with the memory region that contains the program
    ldr r0, =mslot0
    bl lexer



print_err_and_exit:
    ldr r0, =error_msg
    bl strlen
    mov r1, r0
    ldr r0, =error_msg
    bl print
    bne error

.section .data
error_msg: .asciz "Usage: ./Aros-25-as test.aros"
fhandle: .word 0
