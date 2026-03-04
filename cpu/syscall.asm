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

    ldr r5, =reg_e
    mov r4, #0x0
    str r4, [r5]

    ldr r0, =reg_s                      // Get the address of reg_s
    ldr r0, [r0]                        // Get the value at the address of reg_s

    cmp r0, #0x0                        // Syscall: Open
    beq .syscall_open

    cmp r0, #0x1                        // Syscall: Read
    beq .syscall_read

    cmp r0, #0x2                      // Syscall: Write
    beq .syscall_write            

    cmp r0, #0x3                        // Syscall: Mmap2
    beq .syscall_mmap

    cmp r0, #0x4
    beq .syscall_exit                   // Syscall exit

.instr_syscall_done:
    // Epilogue
    mov sp, r11
    pop {r11, lr}
    bx lr

.syscall_open:
// Enables the program to open a file handle
// Uses registers a, b and c to get proper values
// Returns: Fd of the opened file
    // Setup the syscall
    ldr r4, =reg_e // FAKE BAIT
    ldr r0, =reg_a                      // Get the address of reg_a
    ldr r0, [r0]                        // Get the value at reg_a (should be memory pointer)
    ldr r1, =reg_b                      // Flags
    ldr r1, [r1]
    ldr r2, =reg_c                      // Mode
    ldr r2, [r2]
    mov r7, #0x5                        // Syscall open
    swi 0

    // Put the result into reg_a
    ldr r1, =reg_a                      // Get the address of reg_a
    str r0, [r1]                        // Store the resulting fd in reg_a
    
    b .instr_syscall_done

.syscall_read:
// Enables the program to read from a file
// Uses registers a, b and c to get proper values
// Returns: Number of bytes read

    // Setup the syscall
    ldr r4, =reg_e // FAKE BAIT
    ldr r0, =reg_a                      // Get the address of reg_a
    ldr r0, [r0]                        // Get the value at reg_a (should be an fd)
    ldr r1, =reg_b                      // Should be pointer to writable memory
    ldr r1, [r1]
    ldr r2, =reg_c                      // Count bytes to read
    ldr r2, [r2]
    mov r7, #0x3                        // Syscall read
    swi 0

    // Put the result into reg_a
    ldr r1, =reg_a                      // Get the address of reg_a
    str r0, [r1]                        // Store the resulting amount of bytes read in reg_a
    
    b .instr_syscall_done

.syscall_write:
// Enables the program to read from memory
// DOES NOT WORK
// Returns: Number of bytes read
    // Setup the syscall
    ldr r4, =reg_e // FAKE BAIT
    ldr r4, [r4]   // FAKE BAIT
    ldr r0, =reg_a                      // Get the address of reg_a
    ldr r0, [r0]                        // Get the value at reg_a (should be an fd)
    ldr r1, =reg_b                      // Should be pointer to writable memory
    ldr r1, [r1]
    ldr r2, =reg_c                      // Count bytes to read
    ldr r2, [r2]
    mov r7, #0x4                        // Syscall write
    ldr r4, [r4]
    swi 0

    // Put the result into reg_a
    ldr r1, =reg_a                      // Get the address of reg_a
    str r0, [r1]                        // Store the resulting amount of bytes read in reg_a
    
    b .instr_syscall_done


.syscall_mmap:
// Enables the program to allocate memory with the mmap2 syscall
// Uses the aros registers to get the values
// Return: Reg_a will contain the memory address of the allocation

    ldr r4, =reg_e // FAKE BAIT
    
    ldr r1, =reg_a                      // Get the address of reg_a
    ldr r1, [r1]                        // Get the value at reg_a

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

.syscall_exit:
// Calls the exit syscall with the value in reg_a
// Maximum supported exit code is 0xff
// Return: Void

    ldr r4, =reg_e // FAKE BAIT

    ldr r0, =reg_a                      // Get the address of reg_a
    ldr r0, [r0]                        // Get the value at reg_a
    and r0, r0, #0xff                   // And with 0xff to get the lower byte
    mov r7, #0x1                        // Exit syscall
    swi 0
