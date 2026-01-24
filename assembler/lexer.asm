/*
* The goal of the lexer is to return a memory region with token value pairs
* The lexer will be called with a memory region with the original program written in assembly.
* From now on this memory region will be referred to as the program buffer.
* 
* The overall algorithm of the lexer is as follows:
* 1. Allocate memory for tokens and values, from now on referred to as token buffer
*
* 2. Copy a line from the program buffer to the IB
*       - Copy no more than 64 chars. 64< chars will lead to error
*       - Stop if hitting a newline
*
* 3. Switch on the IB to determine what tokens to emit 
*       - If first character is for example '#' it will emit a number token. If 'm' it will emit an identifier token.
*       - The token will be written to the token buffer. If the token is a label it will have more space.
*       - When a newline is hit the IB will be reset.
*
* 4. Repeat step 2 and 3 until the program buffer is empty
*/

.section .text

.extern error
.extern alloc_mem
.extern mslot1
.extern mslot1_s

// Imagine that this is the function: lexer()
.global _start

_start:
    // Lexer that emmits tokens and values in pairs
    // r0 _IN_: Address of the mmapped region that contains the program data from the .asm file
    // r1 _IN_: Size of the mmapped region

    // Function prologue
    push {lr}
    mov r11, sp
    sub sp, sp, #0x10

    str r0, [r11, #-0x4]
    str r1, [r11, #-0x8]

    // Allocate the token buffer
    ldr r0, =mslot1
    ldr r1, =mslot1_s
    mov r2, 0x1000
    str r2, [r1]
    bl alloc_mem

    /* While loop that copies bytes 1 by 1 from the program data to the IB
    If the char is a space, comma, colon or newline, stop copying and parse IB */

    // Load program buffer into r5
    // Use r6 as the total program buffer counter
    // Use r1 as the IB index counter
    ldr r5, [r11, #-0x4]
    eor r6, r6

.lexer_copy_line:
    // Copy line to IB. Then increment the program buffer counter and update program buffer pointer.
    mov r0, r5
    bl .copy_line_to_IB // Returns amount of bytes copied
    // Update the global ptr and counter
    add r6, r6, r0
    add r5, r5, r0

    // TODO: Continue from here
    // Make a function that can parse the IB from start to newline character
    bl .parse_IB









    // Function epilogue
    eor r0, r0
    str r0, [r11, #-0x4] // set ptr 0
    str r0, [r11, #-0x8] // set ptr 0
    add sp, sp, #0x10
    // Return to caller
    pop {pc}

.copy_byte_to_IB:
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

// Copy bytes to the IB including newline. Then it will stop.
// Will write from the beginning of the IB
.copy_line_to_IB:
    // r0: Address to copy from
    // return: Amount of bytes read (including newline)

    // Use r1 as counter and r3 to hold address of IB
    eor r1, r1
    ldr r3, =IB

.copy_line_to_IB_loop:
    // Check amount characters (index counter) to prevent overflow 
    cmp r1, #0x40
    je error

    // Load value from r0 and compare to newline
    ldr r2, [r0, r1]
    cmp r2, #0x0a
    je .copy_line_to_IB_done
    str r2, [r3, r1]

    // Increment index counter and return to loop
    add r1, r1, #0x1
    jmp .copy_line_to_IB_loop 

.copy_line_to_IB_done:
    // Copy the final newline character and return
    str r2, [r3, r1]
    add r1, r1, #0x1
    mov r0, r1
    bx lr

.section .data

// Intermediate buffer to store char arrays.
// The buffer will be analyzed before emmiting a token
IB: .zero 0x50

.equ IDENTIFIER, 0x1
