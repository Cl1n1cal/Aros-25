# Assembler and linker
AS = arm-linux-gnueabi-as

LD = arm-linux-gnueabi-gcc-13
LD_FLAGS = -nostdlib

# .asm directories
LIBS_DIR := libs
BUILD_DIR := build
CPU_DIR := cpu
ASSEMBLER_DIR := assembler

# .o directories
CPU_BUILD_DIR := build/cpu_obj
ASSEMBLER_BUILD_DIR := build/assembler_obj
LIBS_BUILD_DIR := build/libs_obj

# Find-all-files patterns .asm
CPU_SRCS = $(wildcard $(CPU_DIR)/*.asm)
ASSEMBLER_SRCS = $(wildcard $(ASSEMBLER_DIR)/*.asm)
LIBS_SRCS = $(wildcard $(LIBS_DIR)/*.asm)

# Conversion pattern
CPU_OBJS = $(patsubst $(CPU_DIR)/%.asm, $(CPU_BUILD_DIR)/%.o, $(CPU_SRCS))
ASSEMBLER_OBJS = $(patsubst $(ASSEMBLER_DIR)/%.asm, $(ASSEMBLER_BUILD_DIR)/%.o, $(ASSEMBLER_SRCS))
LIBS_OBJS = $(patsubst $(LIBS_DIR)/%.asm, $(LIBS_BUILD_DIR)/%.o, $(LIBS_SRCS))

# Object directories
CPU_ASSEMBLED_OBJS = $(wildcard $(CPU_BUILD_DIR)/*.o)
ASSEMBLER_ASSEMBLED_OBJS = $(wildcard $(ASSEMBLER_BUILD_DIR)/*.o)
LIBS_ASSEMBLED_OBJS = $(wildcard $(LIBS_BUILD_DIR)/*.o)

all : Aros-25-cpu Aros-25-as

# Linking
Aros-25-cpu: $(CPU_OBJS) $(LIBS_OBJS)
	$(LD) $^ -o $(BUILD_DIR)/Aros-25-cpu $(LD_FLAGS)

Aros-25-as: $(ASSEMBLER_OBJS) $(LIBS_OBJS)
	$(LD) $^ -o $(BUILD_DIR)/Aros-25-as $(LD_FLAGS)

# Assembling
cpu : $(CPU_BUILD_DIR) $(CPU_OBJS)
assembler : $(ASSEMBLER_BUILD_DIR) $(ASSEMBLER_OBJS)
libs : $(LIBS_BUILD_DIR) $(LIBS_OBJS)

$(CPU_BUILD_DIR)/%.o : $(CPU_DIR)/%.asm | $(CPU_BUILD_DIR)
	$(AS) $< -o $@

$(ASSEMBLER_BUILD_DIR)/%.o : $(ASSEMBLER_DIR)/%.asm | $(ASSEMBLER_BUILD_DIR)
	$(AS) $< -o $@

$(LIBS_BUILD_DIR)/%.o : $(LIBS_DIR)/%.asm | $(LIBS_BUILD_DIR)
	$(AS) $< -o $@

$(CPU_BUILD_DIR):
	mkdir -p $(CPU_BUILD_DIR)

$(ASSEMBLER_BUILD_DIR):
	mkdir -p $(ASSEMBLER_BUILD_DIR)

$(LIBS_BUILD_DIR):
	mkdir -p $(LIBS_BUILD_DIR)

clean:
	rm -rf build
