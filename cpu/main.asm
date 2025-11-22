.section .data
init_msg: .asciz "[Aros-25] Initializing Aros-25 CPU\n"
load_msg: .asciz "[Aros-25] Loading program argument: "

.section .text

// External functions
.extern error
.extern print
.extern strlen
.extern print_newline
.extern fopen
.extern alloc_mem
.extern free_mem

// External memory
.extern mslot0

.global _start

_start:
    // Check number of cmd line arguments is 2
    ldr r0, [sp]
    cmp r0, #0x2
    bne error

    // Open the first argument early to prevent race TOCTOU
    add sp, sp, #0x8
    ldr r0, [sp]
    bl fopen
    mov r0, r15

    // Print init message
    ldr r0, =init_msg
    bl strlen
    mov r1, r0
    ldr r0, =init_msg
    bl print

    // Print load program message
    ldr r0, =load_msg
    bl strlen
    mov r1, r0
    ldr r0, =load_msg
    bl print

    // Print first program argument
    ldr r0, [sp]
    bl strlen
    mov r1, r0
    ldr r0, [sp]
    bl print
    bl print_newline

    // Allocate memory with mmap
    ldr r0, =mslot0
    mov r1, #0x1000
    ldr r2, =mslot0_s
    str r1, [r2]
    ldr r1, =mslot0_s
    bl alloc_mem

    bl error
