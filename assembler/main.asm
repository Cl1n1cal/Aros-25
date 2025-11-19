.section .text

.global hello

hello:
	mov r0, #0x1

.section .data
error_msg: .asciz "Usage: ./Aros-25-as test.aros"
