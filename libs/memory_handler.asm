.section .data

mslot0: .word 0
mslot0_s: .word 0

.section .text

// External functions
.extern error

// Global functions
.global alloc_mem
.global free_mem

// Global variables - memory slots and sizes
.global mslot0
.global mslot0_s

.global mslot1
.global mslot1_s

alloc_mem:
    // Allocate memory - will always have read and write permissions
    // r0 : Address of the mslot where the result will be stored
    // r1 : Address of mslot size of the memory
    push {r11}
    mov r11, sp
    sub sp, sp, #0x10

    // Check if the addr in r0 is NULL before dereferencing it
    cmp r0, #0x0 
    beq error

    // Check if the addr of r1 is NULL before dereferencing it
    cmp r1, #0x0
    beq error
    
    // Save r0
    str r0, [r11, #-0x4]

    // Setup mmap2 arguments
    // r1 already contains size
    eor r0, r0      // Addr: NULL
    ldr r1, [r1]    // Size of allocation
    mov r2, #0x3    // PROT_READ | PROT_WRITE
    mov r3, #0x22   // MAP_PRIVATE | MAP_ANONYMOUS
    mov r4, #-0x1   // Fd: NULL
    str r0, [sp]    // Offset: 0 (Given in 4096 byte blocks on arm 32)
    mov r7, #0xc0   // Mmap2 : Syscall number 192
    swi 0

    // Check result - mmap2 returns -1 on failure
    cmp r0, #0x0
    bleq error

    // Store value and return with status 0
    mov r1, r0
    ldr r0, [r11, #-0x4]
    str r1, [r0]
    mov r0, #0x0
    mov sp, r11
    pop {r11}
    bx lr

