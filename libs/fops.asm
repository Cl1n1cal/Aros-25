.section .data

.section .text

.extern error

.global fread
.global fopen

fread:
    // Read an amount of bytes from a file desc. into memory
    // r0 : Fd
    // r1 : Buffer address
    // r2 : Count (bytes)
    
    // Read from the fd
    mov r7, #0x3
    swi 0
    
    // Check if the return value is 0 (error)
    cmp r0, #0
    beq error

    bx lr

fopen:
    // Open the file
    // r0 : should contain ptr to name of the file

    // Open syscall with O_RDNLY
    mov r7, #0x5
    mov r1, #0x0
    swi 0

    // Check if the return value is negative
    cmp r0, #0
    blle error

    bx lr
