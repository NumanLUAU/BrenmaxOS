all: BrenmaxOS.img

BrenmaxOS.img: kernel.c BrenmaxOS.asm Others/linker.ld
    i686-elf-gcc -ffreestanding -O2 -nostdlib kernel.c -o kernel.bin -T Others/linker.ld
    nasm -f bin "BrenmaxOS.asm" -o "BrenmaxOS.img"
clean:
    rm -rf BrenmaxOS.img kernel.bin
run: all
    qemu-system-x86_64 -drive format=raw,file="BrenmaxOS.img" -display sdl

.PHONY: all clean run