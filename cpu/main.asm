.section .data
init_msg: .asciz "[Aros-25] Initializing Aros-25 CPU\n"
load_msg: .asciz "[Aros-25] Loading program argument: "

// For storing the fd of the first argument
arg1_fd: .word 0

.mslot0: .word 0
.mslot0_s: .word 0

stack: .word 0
stack_s: .word 0

.section .text

// External functions
.extern error
.extern print
.extern strlen
.extern print_newline
.extern fopen
.extern alloc_mem
.extern free_mem
.extern reg_bp

.global _start
.global stack
.global stack_s

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

    // Allocate program memory with mmap
    ldr r0, =.mslot0
    mov r1, #0x1000
    ldr r2, =.mslot0_s
    str r1, [r2]
    ldr r1, =.mslot0_s
    eor r3, r3, r3                  // No extra flags
    bl alloc_mem

    // Allocate stack memory for cpu
    ldr r0, =stack
    mov r1, #0x1000
    ldr r2, =stack_s
    str r1, [r2]
    ldr r1, =stack_s
    eor r3, r3                      // No extra flags
    bl alloc_mem

    // Setup the stack - grows downwards like normally
    ldr r0, =stack                  // Load stack address
    ldr r0, [r0]                    // Load mmap memory at stack addr
    ldr r1, =reg_bp                 // Load address of base pointer
    ldr r2, =stack_s                // Load address of stack size
    ldr r2, [r2]                    // Load value at stack size address
    sub r2, r2, #0x8                // Sub 8 bytes since we are 0 indexed and we want 1 guard memory slot so we don't go OOB when popping
    add r4, r0, r2                  // Get the largest stack address
    str r4, [r1]                    // Store the largest stack address into reg_bp
    ldr r0, =reg_sp                 // Load the address of stack pointer
    str r4, [r0]                    // Set the stack pointer to the same value as base pointer


    // Read the bytes from the first program argument into the program memory
    ldr r0, =arg1_fd
    ldr r0, [r0]
    ldr r1, =.mslot0
    ldr r1, [r1]
    ldr r2, =.mslot0_s
    ldr r2, [r2]
    bl fread

    // Check the executable file signature
    // cannot mov directly into r1 because of number size
    ldr r0, =.mslot0
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
    ldr r0, =.mslot0
    ldr r0, [r0]
    bl interpret_program

    bl error
