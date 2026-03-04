FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install QEMU user-mode emulator for ARM and ARM libc
RUN apt-get update && apt-get install -y \
    qemu-user \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your ARM binary and input file
COPY Aros-25-cpu .

# Make binary executable
RUN chmod +x Aros-25-cpu

# Run the ARM binary via qemu-arm
CMD ["qemu-arm", "./Aros-25-cpu"]