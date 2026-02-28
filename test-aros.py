#!/usr/bin/python3
from pwn import *
elf = context.binary = ELF("build/Aros-25-cpu", checksec=False)

gs = '''
b instr_store
b instr_load
b instr_mov_val
'''

context.arch = 'arm'

def start():
    if args.GDB:
        return gdb.debug([elf.path, "build/test.aros"], gdbscript=gs, aslr=False)
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

def store(reg_from: bytes, reg_to: bytes) -> bytes:
    return b"\x07" + reg_from + reg_to

def load(reg_to: bytes, reg_from: bytes) -> bytes:
    return b"\x08" + reg_to + reg_from

def syscall() -> bytes:
    return b"\x06"

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

with open("build/test.aros", 'wb') as file:
    file.write(p)

io = start()


io.interactive()
