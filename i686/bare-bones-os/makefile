PATH_CROSS_COMPILER = $$HOME/opt/cross/bin

all: create_iso clean_obj_files

create_iso: clean
	@ $(PATH_CROSS_COMPILER)/i686-elf-as boot.s -o boot.o
	@ $(PATH_CROSS_COMPILER)/i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	@ $(PATH_CROSS_COMPILER)/i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
	@ mkdir -p isodir/boot/grub
	@ cp myos.bin isodir/boot/myos.bin
	@ cp grub.cfg isodir/boot/grub/grub.cfg
	@ grub-mkrescue -o myos.iso isodir

clean_obj_files:
	@ rm -rf *.o *.bin isodir

clean:
	@ rm -rf *.o *.bin isodir
	@ rm -rf *.iso
