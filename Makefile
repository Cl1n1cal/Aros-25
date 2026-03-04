# Assembler and linker
AS = arm-linux-gnueabi-as
LD = arm-linux-gnueabi-gcc-13
LD_FLAGS = -nostdlib -z noexecstack -Wl,-z,relro -Wl,--no-relax

# Directories
LIBS_DIR := libs
BUILD_DIR := build
DEPLOY_DIR := deployment
CPU_DIR := cpu
ASSEMBLER_DIR := assembler

# .o directories
CPU_BUILD_DIR := build/cpu_obj
ASSEMBLER_BUILD_DIR := build/assembler_obj
LIBS_BUILD_DIR := build/libs_obj

# Source files
CPU_SRCS = $(wildcard $(CPU_DIR)/*.asm)
ASSEMBLER_SRCS = $(wildcard $(ASSEMBLER_DIR)/*.asm)
LIBS_SRCS = $(wildcard $(LIBS_DIR)/*.asm)

# Object files
CPU_OBJS = $(patsubst $(CPU_DIR)/%.asm, $(CPU_BUILD_DIR)/%.o, $(CPU_SRCS))
ASSEMBLER_OBJS = $(patsubst $(ASSEMBLER_DIR)/%.asm, $(ASSEMBLER_BUILD_DIR)/%.o, $(ASSEMBLER_SRCS))
LIBS_OBJS = $(patsubst $(LIBS_DIR)/%.asm, $(LIBS_BUILD_DIR)/%.o, $(LIBS_SRCS))

# Default target
all: Aros-25-cpu

# Linking
Aros-25-cpu: $(CPU_OBJS) $(LIBS_OBJS) | $(DEPLOY_DIR)
	$(LD) $^ -o $(BUILD_DIR)/Aros-25-cpu $(LD_FLAGS)
	cp $(BUILD_DIR)/Aros-25-cpu $(DEPLOY_DIR)/

Aros-25-as: $(ASSEMBLER_OBJS) $(LIBS_OBJS) | $(DEPLOY_DIR)
	$(LD) $^ -o $(BUILD_DIR)/Aros-25-as $(LD_FLAGS)
	cp $(BUILD_DIR)/Aros-25-as $(DEPLOY_DIR)/

# Assembling
cpu: $(CPU_BUILD_DIR) $(CPU_OBJS)
assembler: $(ASSEMBLER_BUILD_DIR) $(ASSEMBLER_OBJS)
libs: $(LIBS_BUILD_DIR) $(LIBS_OBJS)

$(CPU_BUILD_DIR)/%.o: $(CPU_DIR)/%.asm | $(CPU_BUILD_DIR)
	$(AS) $< -o $@

$(ASSEMBLER_BUILD_DIR)/%.o: $(ASSEMBLER_DIR)/%.asm | $(ASSEMBLER_BUILD_DIR)
	$(AS) $< -o $@

$(LIBS_BUILD_DIR)/%.o: $(LIBS_DIR)/%.asm | $(LIBS_BUILD_DIR)
	$(AS) $< -o $@

# Directory creation
$(CPU_BUILD_DIR):
	mkdir -p $(CPU_BUILD_DIR)

$(ASSEMBLER_BUILD_DIR):
	mkdir -p $(ASSEMBLER_BUILD_DIR)

$(LIBS_BUILD_DIR):
	mkdir -p $(LIBS_BUILD_DIR)

$(DEPLOY_DIR):
	mkdir -p $(DEPLOY_DIR)

clean:
	rm -rf build deployment