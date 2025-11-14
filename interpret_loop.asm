.section .text

.extern interpret_instr
.extern pc

.global interpret_loop
.type interpret_loop, @function

interpret_loop:
    
    // TODO: Continue here

    bx

error:
    // Exit with error 0xff
    mov r0, #0xff
    mov r7, #1
    swi 0

