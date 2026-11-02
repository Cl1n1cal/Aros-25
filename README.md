Read me
# Aros-25: A CPU emulator
This is my arm32 CPU emulator, written by hand (everything including comments). It featured in the [Kalmar CTF 2026](https://ctftime.org/event/2983), hosted by [Kalmarunionen](https://www.kalmarunionen.dk/). <br>
Hint: Some of the assembly instructions around syscalls might be confusing ;-)
# Requirements for assembling and linking
```
sudo apt install binutils-arm-linux-gnueabi
sudo apt install gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi
```

# Supported instructions
1. Mov value to register: mov a, 0x30
2. Mov register to register (right reg written to left reg: mov a, b)
3. Add two registers and store in a third: add a, b, c (add b and c, store the result in a)
4. Load and store
5. Push from register to the stack
6. Pop from the stack
7. Push from the stack
8. Different types of syscalls
