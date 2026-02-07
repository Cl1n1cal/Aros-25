Read me

# Requirements for assembling and linking
```
sudo apt install binutils-arm-linux-gnueabi
sudo apt install gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi
```

# Supported instructions
1. Mov value to register: mov a, 0x30
2. Mov register to register (right reg written to left reg: mov a, b
3. Add to registers and store in a third: add a, b, c
