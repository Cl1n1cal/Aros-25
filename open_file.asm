.section .text

.extern error

.global open_file


open_file:
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



