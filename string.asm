// string.asm : Different string related functions
.section .data
newline_char: .asciz "\n"

.section .text

.extern error

.global print
.global print_newline
.global strlen


print:
    // Prints a string to the terminal
    // r0: string pointer
    // r1: string length

    // Setup write syscall
    mov r7, #0x4
    mov r2, r1
    mov r1, r0
    mov r0, #0x1
    swi 0
    bx lr

print_newline:
    mov r0, #0x1
    ldr r1, =newline_char
    mov r2, #0x1
    mov r7, #0x4
    swi 0
    bx lr

strlen:
    // Returns the length of a string in r0, not couting null byte
    // Supports strings up to 0x100 characters
    // r0 : string pointer
    
    // Iterate through the string until null byte
    eor r2, r2
    mov r3, #0x101 // String size boundary
loop:
    ldrb r1, [r0]
    cmp r1, #0x0
    beq done
    add r2, r2, #0x1
    add r0, r0, #0x1
    // Check string is not larger than 0x100 bytes
    cmp r2, r3 
    beq error
    b loop

done:
    mov r0, r2
    bx lr

