ADAFLAGS	=	-march=i386 -m32 -gnat05 -O0 -g3 -x -a -gnatd.n -D ${CURDIR}/../$(BUILDDIR) --RTS=${CURDIR}/../RTS -gnatec=${CURDIR}/midnite.adc
ADAINCFLAGS	=	-aI${CURDIR} -aI${CURDIR}/CPU -aI${CURDIR}/CPU/ProtectedMode -aI${CURDIR}/CPU/MMU -aI${CURDIR}/Memory -aI${CURDIR}/Device -aI${CURDIR}/Device/Timer -aI${CURDIR}/Device/PCI -aI${CURDIR}/Device/VGA 

#-aI${CURDIR}/../Werewolf

ADACOMPILE	=	@echo '[COMPILE]' $< && gnat compile

#BUILDLOG	=	>/dev/null 2>/dev/null

MKDIR		=	@echo "[MKDIR]  " $< && mkdir $<
RMDIR		=	@echo "[RM] -rf " $< && rm -rf $<
MAKE		=	@echo "[MAKE]   " $< && ADACOMPILE="$(ADACOMPILE)" ADAFLAGS="$(ADAFLAGS)" ADAINCFLAGS="$(ADAINCFLAGS)" BUILDLOG="$(BUILDLOG)" ISODIR="$(ISODIR)" BUILDDIR="$(BUILDDIR)" make -s -C $<

SOURCES		=	cpu.adb cpu-cpuid.asm cpu-exceptions.adb cpu-halt.asm cpu-interrupts.adb cpu-interrupts-asm.asm cpu-io.asm cpu-mmu.ads cpu-mmu-paging.adb cpu-protectedmode.adb cpu-protectedmode-asm.asm cpu-protectedmode-gdt.adb cpu-protectedmode-idt.adb debug.adb debug-instruction.adb debug-registers.asm device.ads device-keyboard.adb device-pci.adb device-pic.adb device-timer-rtc.adb device-uart.adb memory.adb memory-a20.adb memory-memcmp.asm midnite.adb scheduler.adb scheduler-contextswitch.asm process.ads queue.adb vga.asm vga-font.asm 
OBJECTSASM	=	$(SOURCES:.asm=.o)
OBJECTSADS	=	$(OBJECTSASM:.ads=.o)
OBJECTS		=	$(OBJECTSADS:.adb=.o)

EXECUTABLE	=	../$(ISODIR)/midnite.elf

all: $(SOURCES) start.o $(EXECUTABLE)

start.o: start.asm
	@echo "[NASM]   " $< && nasm -felf32 $< -o ${CURDIR}/../${BUILDDIR}/$@

$(EXECUTABLE): $(OBJECTS)
	@echo "[LD]      boot/kernel.elf" ; cd ${CURDIR}/../$(BUILDDIR);  gcc $(OBJECTS) ../RTS/adalib/*.o -nodefaultlibs -nostartfiles -static -T ../Midnite/midnite.ld

%.o: %.adb
	$(ADACOMPILE) -c $(ADAFLAGS) $(ADAINCFLAGS) $< -o $@ $(BUILDLOG)
%.o: %.ads
	$(ADACOMPILE) -c $(ADAFLAGS) $(ADAINCFLAGS) $< -o $@ $(BUILDLOG)
%.o: %.asm
	@echo "[NASM]   " $< && nasm -felf32 $< -o ${CURDIR}/../${BUILDDIR}/$@
