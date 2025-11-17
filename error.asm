.section .text

.global error

// Return error code 1
error:
    mov r7, #0x1
    mov r0, #0x1
    swi 0
