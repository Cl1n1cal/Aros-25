.section .data
init_msg: .asciz "[Aros-25] Initializing Aros-25 CPU\n"
load_msg: .asciz "[Aros-25] Loading program argument: "

// For storing the fd of the first argument
arg1_fd: .word 0

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

    // Open the first argument
    add sp, sp, #0x8
    ldr r0, [sp]
    bl fopen
    ldr r1, =arg1_fd
    str r0, [r1]

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

    // Read the bytes from the first program argument into the memory
    ldr r0, =arg1_fd
    ldr r0, [r0]
    ldr r1, =mslot0
    ldr r1, [r1]
    ldr r2, =mslot0_s
    ldr r2, [r2]
    bl fread

    // Check the executable file signature
    // cannot mov directly into r1 because of number size
    ldr r0, =mslot0
    ldr r0, [r0]
    
    // Check upper nibble
    ldr r1, [r0]
    lsr r1, #0x10
    mov r2, #0x736f
    cmp r1, r2
    bne error

    // Check lower nibble
    ldr r1, [r0]
    mov r3, #0xffff 
    and r1, r3
    mov r2, #0x7261
    cmp r1, r2
    bne error

    // Start executing the memory
    ldr r0, =mslot0
    ldr r0, [r0]
    bl interpret_program

    bl error
