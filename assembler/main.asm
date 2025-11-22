.section .data
error_msg: .asciz "Usage: ./Aros-25-as test.aros"
fhandle: .word 0

.section .text

// Standard imports
.extern error
.extern print
.extern strlen
.extern open_file

// Memory handling
.extern alloc_mem
.extern mslot0

.global _start

_start:
    // Check number of cmd line arguments is 2
    ldr r0, [sp]
    cmp r0, #0x2
    bne print_err_and_exit

    // Open the first argument early to prevent race TOCTOU
    add sp, sp, #0x8
    ldr r0, [sp]
    bl open_file

    // Store the file desc. in fhandle
    ldr r1, =fhandle
    str r0, [r1]

    // Allocate memory before reading the file
    ldr r0, [mslot0]
    mov r1, #0x1000
    bl alloc_mem

print_err_and_exit:
    ldr r0, =error_msg
    bl strlen
    mov r1, r0
    ldr r0, =error_msg
    bl print
    bne error

