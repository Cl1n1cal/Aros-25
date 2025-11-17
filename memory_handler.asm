.section .text

// External functions
.extern error

// Global functions
.global alloc_mem
.global free_mem

// Global variables
.global mslot0

alloc_mem:
    // Allocate memory - will always have read and write permissions
    // r0 : Address of the memory slot where the result will be stored
    // r1 : Size of the memory
    push {r11}
    mov r11, sp
    sub sp, sp, #0x10
    
    // Save r0
    str r0, [r11, #-0x4]

    // Setup mmap2 arguments
    // r1 already contains size
    eor r0, r0      // Addr: NULL
    mov r2, #0x3    // PROT_READ | PROT_WRITE
    mov r3, #0x22   // MAP_PRIVATE | MAP_ANONYMOUS
    mov r4, #-0x1   // Fd: NULL
    str r0, [sp]    // Offset: 0 (Given in 4096 byte blocks on arm 32)
    mov r7, #0xc0   // Mmap2 : Syscall number 192
    swi 0

    // Put the result into the address specified in r0 
    // Check if the addr in r0 was NULL before dereferencing it
    mov r1, r0
    ldr r0, [r11, #-0x4]
    cmp r0, #0x0 
    beq error

    // Store value and return with status 0
    str r1, [r0]
    mov r0, #0x0
    mov sp, r11
    pop {r11}
    bx lr

.section .data

mslot0: .word 0
