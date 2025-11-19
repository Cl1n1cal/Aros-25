LIB_DIR := libs
BUILD_DIR := build
ASSEMBLER_OBJECTS := build/assembler_obj/$(wildcard *.o)
CPU_OBJECTS := build/cpu_obj/$(wildcard *.o)

CC = arm-linux-gnueabi-as
LD = arm-linux-gnueabi-gcc-13
FLAGS = -nostdlib

%.o : %.asm
	$(CC) $< -o $@

all: $(wildcard %.o)


