CC = arm-linux-gnueabi-as
LD = arm-linux-gnueabi-gcc-13
FLAGS = -nostdlib

main : main.o interpret_instr.o error.o open_file.o string.o memory_handler.o
	$(LD) main.o interpret_instr.o error.o open_file.o string.o memory_handler.o -o main $(FLAGS)

main.o : main.asm
	$(CC) main.asm -o main.o

interpret_instr.o : interpret_instr.asm
	$(CC) interpret_instr.asm -o interpret_instr.o

open_file.o : open_file.asm
	$(CC) open_file.asm -o open_file.o

string.o : string.asm
	$(CC) string.asm -o string.o

error.o : error.asm
	$(CC) error.asm -o error.o

memory_handler.o : memory_handler.asm
	$(CC) memory_handler.asm -o memory_handler.o

