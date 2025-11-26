/*
* The goal of the lexer is to return a memory region with token value pairs
* The lexer will be called with a memory region with the original program written in assembly.
* From now on this memory region will be referred to as the program buffer.
* 
* The overall algorithm of the lexer is as follows:
* 1. Copy chars from the program buffer to the IB
*       - Copy no more than 8 chars. 8< chars will lead to error
*       - Stop if hitting a newline, comma, colon or space character
*
* 2. Switch on the IB to determine what token to emit 
*       - If first character is for example '#' it will emit a number token. If 'm' it will emit an identifier token.
*
* 3. 
*/

.section .text

.extern error

// Imagine that this is the function: lexer()
.global _start

_start:
    // Lexer that emmits tokens and values in pairs
    // r0 _IN_: Address of the mmapped region that contains the program data from the .asm file
    // r1 _IN_: Size of the mmapped region

    // Function prologue
    push {lr}
    sub sp, sp, #0x10

    // Copy chars one by one to the IB
    mov r0, #1
    ldr r1, =IB
    str r0, [r1]
    mov r0, #0

    // Function epilogue
    add sp, sp, #0x10

copy_byte_to_IB:
    // r0: The byte to copy
    // r1: Index 0-7

    // Check index is valid
    cmp r1, #0x0
    blt error
    cmp r1, #0x7
    bgt error

    // Copy the byte to the index in the IB
    ldr r2, =IB
    str r0, [r2, r1]
    bx lr

.section .data

// Intermediate buffer to store char arrays.
// The buffer will be analyzed before emmiting a token
IB: .zero 16

.equ IDENTIFIER, 0x1
