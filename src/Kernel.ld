OUTPUT("iso/boot/kernel.elf")
OUTPUT_FORMAT(elf32-i386)
STARTUP(start.o)
ENTRY (start)

SECTIONS
{
    . = 0x00100000;

    .text : {
	code = .;
        *(.text)
	. = ALIGN(4096);
    }

    .rodata ALIGN (0x1000) : {
        *(.rodata)
    }

    .data ALIGN (0x1000) : {
	data = .;
        *(.data)
	. = ALIGN(4096);
    }

    .bss : {
	bss = .;
        *(COMMON)
        *(.bss)
	. = ALIGN(4096);
    }

    .note : {
    	  *(.note)
    }

    .debug : {
    	  *(.debug)
    }
    end = .;
}
