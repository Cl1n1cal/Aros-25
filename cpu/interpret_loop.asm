.section .text

.extern interpret_instr
.extern pc

.global interpret_loop
//.type interpret_loop, @function

interpret_loop:
    // Set the pc to 0 and start executing instructions from there
    eor r0, r0
    //str ro, [pc]
    
    // TODO: Continue here
    //bx interpret_instr

error:
    // Exit with error 0xff
    mov r0, #0xff
    mov r7, #1
    swi 0

