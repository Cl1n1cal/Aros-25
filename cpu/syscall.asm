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
.extern error

.global instr_add
.global instr_syscall

instr_syscall:
// Calls the correct syscall specified by the value in reg_s
// r0: Memory address of pc

    // Prologue - also saving lr for later
    push {r11, lr}
    mov r11, sp
    sub sp, sp, #0x10

    ldr r0, =reg_s                      // Get the address of reg_s
    ldr r0, [r0]                        // Get the value at the address of reg_s

    //cmp r0, #0x0                      // Syscall: Open
    //beq .syscall_open

    //cmp r0, #0x1                      // Syscall: Read
    //beq .syscall_read

    //cmp r0, #0x2                      // Syscall: Write
    //beq .syscall_write                // Not implemented

    cmp r0, #0x3                        // Syscall: Mmap2
    beq .syscall_mmap

.instr_syscall_done:
    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr


.syscall_mmap:
// Enables the program to allocate memory with the mmap2 syscall
// Uses the aros registers to get the values
// Return: Reg_a will contain the memory address of the allocation
    
    // Check the size in reg_a - not larger than 0x100 bytes per allocation
    ldr r1, =reg_a                      // Get the address of reg_a
    ldr r1, [r1]                        // Get the value at reg_a

    cmp r0, #0x100                      // Compare reg_a value (size) to the max allowed size
    bgt error                           // Give error and termiante if larger than 0x100 bytes

    // Setup the syscall
    eor r0, r0      // Addr: NULL
    mov r2, #0x3    // PROT_READ | PROT_WRITE
    mov r3, #0x22   // MAP_PRIVATE | MAP_ANONYMOUS
    mov r4, #-0x1   // Fd: NULL
    str r0, [sp]    // Offset: 0 (Given in 4096 byte blocks on arm 32)
    mov r7, #0xc0   // Mmap2 : Syscall number 192
    swi 0

    // Put the result into reg_a
    ldr r1, =reg_a                      // Get the address of reg_a
    str r0, [r1]                        // Store the resulting memory allocation in reg_a
    
    b .instr_syscall_done