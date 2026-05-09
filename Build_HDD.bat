@echo off
echo -- Brenmax is compiling...

i686-elf-gcc -ffreestanding -O2 -nostdlib kernel.c -o kernel.bin -T Others/linker.ld
nasm -f bin "BrenmaxOS.asm" -o "BrenmaxOS.img"

echo :) WE GOT C WORKING!!!
echo :) r u inside 32 bit mode yet?
echo :) or got some sort of GUI?
echo :) got text showin??
echo :) FDS DC?
echo :) Console?
echo :) Start menu?
echo :) I WANNA IDE??
echo XX or if lucky have u gotten fs yet any??
echo XX SRDTFDSSCLS

qemu-system-x86_64.exe  -drive format=raw,file="BrenmaxOS.img" -display sdl  -machine pcspk-audiodev=speaker -audiodev sdl,id=speaker
pause




