--
-- TODO:
--
-- 1.  Convert VGA stuff into Pure Ada
-- 2.  Create a Put_Line _Line function (TextIO??), using VGA driver to read  -- Preliminary function created inside Console
--     cursor position and write it back after text has been outPut_Line .    -- Perhaps it should be moved to TextIO
--
-- 3.  Memory Allocation routines, bitmap, ada malloc() equiv                 -- Needs serious work as it is a mess
-- --  Better, but Allocation routine needs to find address and assign to access variable.
-- --  Need to add support for Free routine
-- 4.  Add support for Paging                                                 -- Done, needs cleaning up.
-- --  Page Directory Tables should be in known virtual memory location to facilitate loading of processes.
-- 5.  Add support for TSS, create Ring 3 TSS
-- 6.  Create a couple of test programs that run in userland.
-- 7.  Add Multitasking support.
-- 8.  Write driver for PIT                                                   -- Done, needs cleaning up.
-- 9.  Write driver for PIC (APIC later on)                                   -- Done, needs cleaning up.
-- 10. Write scheduler and hook IRQ 8
-- 11. Write loader for ELF file
-- 12. Write something that will allow storage of a program to execute and test
--     Userland/Multitasking/Scheduler  e.g RAMdisk or FAT driver

pragma Restrictions (No_Obsolescent_Features);

with Console; use Console;
with Types; use Types;
with System; use System;

with CPU; use CPU;
with CPU.Interrupts; use CPU.Interrupts;
with CPU.Exceptions; use CPU.Exceptions;
with CPU.ProtectedMode; use CPU.ProtectedMode;
with CPU.ProtectedMode.GDT; use CPU.ProtectedMode.GDT;
with CPU.ProtectedMode.IDT; use CPU.ProtectedMode.IDT;
with CPU.MMU; use CPU.MMU;
with CPU.MMU.Paging; use CPU.MMU.Paging;

with Memory; use Memory;
with Memory.A20; use Memory.A20;

with Debug; use Debug;

with Device; use Device;
with Device.Keyboard; use Device.Keyboard;
with Device.Timer.RTC; use Device.Timer.RTC;
with Device.PIC; use Device.PIC;
with Device.PCI; use Device.PCI;
with Device.VGA; use Device.VGA;
with Device.Uart; -- use Device.Uart;

with Interfaces; use Interfaces;

with Scheduler; use Scheduler;
-- with Scheduler.Process; use Scheduler.Process;

--  with Multiboot; use Multiboot;
--  use type Multiboot.Magic_Values;

with System.Machine_Code; use System.Machine_Code;

with System.Address_To_Access_Conversions;
with System.Storage_Elements; use System.Storage_Elements;
package body Midnite is
   procedure TestSysCall is
   begin

      Put_Line ("Test System Call");
      CPU.Interrupts.Disable;
      Asm ("HLT");
      Asm ("IRET");
   end;

   procedure kstart is
      Ring0CodeSelector  : Word;
      Ring0DataSelector  : Word;
      Ring3CodeSelector  : Word;
      Ring3DataSelector  : Word;
      TSSSelector        : Word;

      TSS                : System.Address;

      PageDirectoryTable : System.Address;

      CPUFeatures        : CPU.Features_Ptr;

   begin

--  This needs to be converted to Pure Ada
--      Device.VGA.Init;
--      Device.VGA.SetMode;

--  Display Main Logo                                                                                
--      Put_Line ("                                       0                                       ");
--      Put_Line ("                                      00                        00000          ");
--      Put_Line ("                                      000                      00000           ");
--      Put_Line ("                                     0000                      0000000         ");
--      Put_Line ("                                    00000                     00000            ");
--      Put_Line ("    000000000000000000 00000 100000000000 00000000000  00000  0000  00000000000");
--      Put_Line ("    00001 00000 00000 00000  00000 00000  00001 00000  00001 00000 10000  00000");
--      Put_Line ("   00000 00000  0000  00000 00000  00001 00000 00000  00000 00000  00000 00000 ");
--      Put_Line ("  00000  00000 00000 00000  00000 00000 00000  00000 00000  00000 000000000001 ");
--      Put_Line ("  00000 00000 00000  00001 00000 00000  00000 00000  00000 00000  00000        ");
--      Put_Line (" 00000 10000  00000 00000 10000  00000 00000  0000  00000  00001 00000 10000   ");
--      Put_Line (" 00001 00000 00000 00000  00000 00000  00000 00000  00000 00000  00000 00000   ");
--      Put_Line (" 0001  0000  00000 0000   0000000000  10000  0000  10000 00000  00000000000    ");
--      Put_Line ("            00000                                        00000                 ");
--      Put_Line ("            0000                                         0000                  ");
--      Put_Line ("             000                                          000                  ");
--      Put_Line ("             10                                           00                   ");
--      Put_Line ("              0                                                                ");

--  Add further code to disable all IRQs and NMIs (Watchdog, RTC??, etc)
--  This will disable Hardware Interrupts (IRQs), NMIs and Software Interrupts.
--  We can't really disable Exceptions.
      CPU.Interrupts.Disable;

--  Detect PCI??
      Device.PCI.Detect;

--  Detect Memory using SPD I2C Interface??
--      Memory.Detect (Device.PCI.I2C);

--  Ensure memory is enabled??
--      foreach Bank
--         Memory.Enable (Bank);
--      endforeach

--  Map out Memory here
      Memory.Reserve (16#00000000#, 16#00000500#); -- 0 - 4K - 16 Bit Interrupt Vector Table
      Memory.Reserve (16#00007000#, 16#00000FFF#); -- Bootsector 7C00 - 7CFF
      Memory.Reserve (16#0009F000#, 16#00000FFF#); -- SMM
      Memory.Reserve (16#000A0000#, 16#0001FFFF#); -- Video RAM
      Memory.Reserve (16#000C0000#, 16#00007FFF#); -- Video BIOS
      Memory.Reserve (16#000C8000#, 16#00027FFF#); -- Extension ROMs
      Memory.Reserve (16#000F0000#, 16#0000FFFF#); -- BIOS

--  Figure out where the Kernel is and what memory it is using then reserve it.
--      Memory.Reserve (KernelAddress, SizeOfKernel);  -- Kernel
      Memory.Reserve (16#00100000#, 16#0003FFFF#); -- 256K Reserved for Kernel

--  Enable A20 line so that processor can address all available memory.
      Memory.A20.Enable;

--  Create and Initialise the Global Descriptor Table
      CPU.ProtectedMode.GDT.Init;
--  The first descriptor is the null descriptor
      CPU.ProtectedMode.GDT.AddNullDescriptor;
--  Now create a Code Descriptor
      Ring0CodeSelector := CPU.ProtectedMode.GDT.AddCodeDescriptor
         (0,
          16#FFFFF#,
          True,
          False,
          Ring0,
          True,
          True,
          True);
      Ring0DataSelector := CPU.ProtectedMode.GDT.AddDataDescriptor
         (0,
          16#FFFFF#,
          True,
          False,
          Ring0,
          True,
          True,
          True);
      Ring3CodeSelector := CPU.ProtectedMode.GDT.AddCodeDescriptor
         (0,
          16#FFFFF#,
          True,
          False,
          Ring3,
          True,
          True,
          True);
      Ring3DataSelector := CPU.ProtectedMode.GDT.AddDataDescriptor
         (0,
          16#FFFFF#,
          True,
          False,
          Ring3,
          True,
          True,
          True);
--  Create a Task State Segment for switching to Ring 3
      CPU.ProtectedMode.CreateTSS;
      TSS := CPU.ProtectedMode.TSS'Address;


      CPU.ProtectedMode.TSS.prev_tss := 16#00000000#;

      CPU.ProtectedMode.TSS.eax := 16#00000000#;
      CPU.ProtectedMode.TSS.ebx := 16#00000000#;
      CPU.ProtectedMode.TSS.ecx := 16#00000000#;
      CPU.ProtectedMode.TSS.edx := 16#00000000#;

      CPU.ProtectedMode.TSS.cs  := 16#00000000#;
      CPU.ProtectedMode.TSS.ds  := 16#00000000#;
      CPU.ProtectedMode.TSS.es  := 16#00000000#;
      CPU.ProtectedMode.TSS.fs  := 16#00000000#;
      CPU.ProtectedMode.TSS.gs  := 16#00000000#;
      CPU.ProtectedMode.TSS.ss  := 16#00000000#;

      CPU.ProtectedMode.TSS.eip := 16#00000000#;
      CPU.ProtectedMode.TSS.eflags := 16#00000000#;
      CPU.ProtectedMode.TSS.esp := 16#00000000#;
      CPU.ProtectedMode.TSS.ebp := 16#00000000#;
      CPU.ProtectedMode.TSS.esi := 16#00000000#;
      CPU.ProtectedMode.TSS.edi := 16#00000000#;
      CPU.ProtectedMode.TSS.cr3 := 16#00000000#;
      CPU.ProtectedMode.TSS.ldt := 16#00000000#;
      CPU.ProtectedMode.TSS.trap := 16#0000#;
      CPU.ProtectedMode.TSS.iomap_base := 16#0000#;

      CPU.ProtectedMode.TSS.ss1 := 16#00000000#;
      CPU.ProtectedMode.TSS.esp1 := 16#00000000#;

      CPU.ProtectedMode.TSS.ss2 := 16#00000000#;
      CPU.ProtectedMode.TSS.esp2 := 16#00000000#;

      CPU.ProtectedMode.TSS.ss0 := Double (Ring0DataSelector);
      CPU.ProtectedMode.TSS.esp0 := 16#0003ffff#;

--  Create a TSS Descriptor
      TSSSelector := CPU.ProtectedMode.GDT.AddSystemDescriptor
         (Double (Unsigned_32 (To_Integer (TSS))),
          TwentyBits ( 104 ),
          TSS386Available);

      Put_Line (" Loading GDT");
      CPU.ProtectedMode.GDT.Load (CPU.ProtectedMode.GDT.GDTR'Address);
      Put_Line (" Enabling Protected Mode");
      CPU.ProtectedMode.Enable;

      Put (" (re)Loading Selectors");
      CPU.ProtectedMode.LoadCS (Ring0CodeSelector);
      Put (" - CS");
      CPU.ProtectedMode.LoadDS (Ring0DataSelector);
      Put (" DS");
      CPU.ProtectedMode.LoadES (Ring0DataSelector);
      Put (" ES");
      CPU.ProtectedMode.LoadFS (Ring0DataSelector);
      Put (" FS");
      CPU.ProtectedMode.LoadGS (Ring0DataSelector);
      Put (" GS");
      CPU.ProtectedMode.LoadSS (Ring0DataSelector);
      Put_Line (" SS");


      CPU.ProtectedMode.IDT.Init;
--  0x00	Division by zero
      CPU.ProtectedMode.IDT.AddInterruptDescriptor
         (CPU.Exceptions.DivideByZero'Address,
          Ring0CodeSelector,
          True,
          Ring0,
          False,
          TrapGate386);
--  0x01	Debugger
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.Debugger'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x02	NMI
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.NonMaskableInterrupt'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x03	Breakpoint
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.Breakpoint'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x04	Overflow
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.Overflow'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x05	Bounds
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.Bounds'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x06	Invalid Opcode
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.InvalidOpcode'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x07	Coprocessor not available
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.CoprocessorNotAvailable'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x08	Double fault
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.DoubleFault'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x09	Coprocessor Segment Overrun (386 or earlier only)
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.CoprocessorSegmentOverrun'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0A	Invalid Task State Segment
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.InvalidTSS'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0B	Segment not present
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.SegmentNotPresent'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0C	Stack Fault
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.StackFault'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0D	General protection fault
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.GeneralProtectionFault'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0E	Page fault
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.PageFault'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x0F	Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x10	Math Fault
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.MathFault'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x11	Alignment Check
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.AlignmentCheck'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x12	Machine Check
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.MachineCheck'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x13	SIMD Floating-Point Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.SIMDFloatingPointException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x14 Virtualization Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x15 Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x16 Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x17 Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x18 Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x19 Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1A Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1B Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1C Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1D Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1E Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  0x1F Reserved / Undocumented Exception
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (CPU.Exceptions.UndocumentedException'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);

--  IRQ Handlers
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ0'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 1
--      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ1'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.Keyboard.ReadScanCode'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 2
-- We should never execute this code as this IRQ is cascaded to IRQ 9
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ2'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 3
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ3'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 4
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ4'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 5
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ5'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 6
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ6'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 7
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ7'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 8
--      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ8'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Scheduler.MainLoop'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 9
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ9'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 10
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ10'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 11
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ11'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 12
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ12'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 13
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ13'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 14
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ14'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);
--  IRQ 15
      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Device.PIC.IRQ15'Address, Ring0CodeSelector, True, Ring0, False, TrapGate386);

      CPU.ProtectedMode.IDT.AddInterruptDescriptor (Midnite.TestSysCall'Address, Ring0CodeSelector, True, Ring3, False, TrapGate386);

--  Remap Programmable Interrupt Controller to use Interrupts 0x20 to 0x2F
--      Device.PIC.Remap (16#20#, 16#28#);

      Device.PIC.Initialise;

      Device.Keyboard.Init;

      Put_Line (" Loading IDT");
      CPU.ProtectedMode.IDT.Load (CPU.ProtectedMode.IDT.IDTR'Address);

--  Detect CPU(s) and Features
      CPUFeatures := CPU.ID (0);
      New_Line;
      Put_Line (" CPU0        : " & CPUFeatures.Vendor);
--      Put_Line (" Max ID      : " & Double_To_Hex (CPUFeatures.MaxID));

      CPUFeatures := CPU.ID (1);
--      Put_Line (" CPUID 1");
      Put_Line (" Family      : " & Nibble_To_Hex (CPUFeatures.Family));
      Put_Line (" Model       : " & Nibble_To_Hex (CPUFeatures.Model));
      Put_Line (" Stepping ID : " & Nibble_To_Hex (CPUFeatures.Stepping));
--      Put_Line (" EBX         : " & Double_To_Hex (CPUFeatures.EBX));
      Put      (" Features    : ");
      if (CPUFeatures.FPU = True) then
         Put ("FPU ");
      end if;
      if (CPUFeatures.VME = True) then
         Put ("VME ");
      end if;
      if (CPUFeatures.DE = True) then
         Put ("DE  ");
      end if;
      if (CPUFeatures.PSE = True) then
         Put ("PSE ");
      end if;
      if (CPUFeatures.TSC = True) then
         Put ("TSC ");
      end if;
      if (CPUFeatures.MSR = True) then
         Put ("MSR ");
      end if;
      if (CPUFeatures.PAE = True) then
         Put ("PAE ");
      end if;
      if (CPUFeatures.MCE = True) then
         Put ("MCE ");
      end if;
      if (CPUFeatures.CX8 = True) then
         Put ("CX8 ");
      end if;
      if (CPUFeatures.APIC = True) then
         Put ("APIC ");
      end if;
      if (CPUFeatures.SEP = True) then
         Put ("SEP ");
      end if;
      if (CPUFeatures.MTRR = True) then
         Put ("MTRR ");
      end if;
      if (CPUFeatures.PGE = True) then
         Put ("PGE ");
      end if;
      if (CPUFeatures.MCA = True) then
         Put ("MCA ");
      end if;
      if (CPUFeatures.CMOV = True) then
         Put ("CMOV ");
      end if;

      New_Line;
      Put (" ");

      if (CPUFeatures.PAT = True) then
         Put ("PAT ");
      end if;
      if (CPUFeatures.PSE36 = True) then
         Put ("PSE36 ");
      end if;
      if (CPUFeatures.PN = True) then
         Put ("PN ");
      end if;
      if (CPUFeatures.CLFLUSH = True) then
         Put ("CLFLUSH ");
      end if;
      if (CPUFeatures.DTS = True) then
         Put ("DTS ");
      end if;
      if (CPUFeatures.ACPI = True) then
         Put ("ACPI ");
      end if;
      if (CPUFeatures.MMX = True) then
         Put ("MMX ");
      end if;

      if (CPUFeatures.FXSR = True) then
         Put ("FXSR ");
      end if;
      if (CPUFeatures.SSE = True) then
         Put ("SSE ");
      end if;
      if (CPUFeatures.SSE2 = True) then
         Put ("SSE2 ");
      end if;
      if (CPUFeatures.SS = True) then
         Put ("SS ");
      end if;
      if (CPUFeatures.HT = True) then
         Put ("HT ");
      end if;
      if (CPUFeatures.TM = True) then
         Put ("TM ");
      end if;
      if (CPUFeatures.IA64 = True) then
         Put ("IA64 ");
      end if;
      if (CPUFeatures.PBE = True) then
         Put ("PBE ");
      end if;

      New_Line;
      Put (" ");

      if (CPUFeatures.PNI = True) then
         Put ("PNI ");
      end if;
      if (CPUFeatures.PCLMULQDQ = True) then
         Put ("PCLMULQDQ ");
      end if;
      if (CPUFeatures.DTES64 = True) then
         Put ("DTES64 ");
      end if;
      if (CPUFeatures.MONITOR = True) then
         Put ("MONITOR ");
      end if;
      if (CPUFeatures.DS_CPL = True) then
         Put ("DS_CPL ");
      end if;
      if (CPUFeatures.VMX = True) then
         Put ("VMX ");
      end if;
      if (CPUFeatures.SMX = True) then
         Put ("SMX ");
      end if;
      if (CPUFeatures.EST = True) then
         Put ("EST ");
      end if;

      if (CPUFeatures.TM2 = True) then
         Put ("TM2 ");
      end if;
      if (CPUFeatures.SSSE3 = True) then
         Put ("SSSE3 ");
      end if;
      if (CPUFeatures.CID = True) then
         Put ("CID ");
      end if;
      if (CPUFeatures.FMA = True) then
         Put ("FMA ");
      end if;
      if (CPUFeatures.CX16 = True) then
         Put ("CX16 ");
      end if;
      if (CPUFeatures.XTPR = True) then
         Put ("XTPR ");
      end if;
      if (CPUFeatures.PDCM = True) then
         Put ("PDCM ");
      end if;

      if (CPUFeatures.PCID = True) then
         Put ("PCID ");
      end if;
      if (CPUFeatures.DCA = True) then
         Put ("DCA ");
      end if;
      if (CPUFeatures.SSE4_1 = True) then
         Put ("SSE4_1 ");
      end if;
      if (CPUFeatures.SSE4_2 = True) then
         Put ("SSE4_2 ");
      end if;
      if (CPUFeatures.X2APIC = True) then
         Put ("X2APIC ");
      end if;
      if (CPUFeatures.MOVBE = True) then
         Put ("MOVBE ");
      end if;
      if (CPUFeatures.POPCNT = True) then
         Put ("POPCNT ");
      end if;

      if (CPUFeatures.TSCDEAD = True) then
         Put ("TSCDEAD ");
      end if;
      if (CPUFeatures.AES = True) then
         Put ("AES ");
      end if;
      if (CPUFeatures.XSAVE = True) then
         Put ("XSAVE ");
      end if;
      if (CPUFeatures.OSXSAVE = True) then
         Put ("OSXSAVE ");
      end if;
      if (CPUFeatures.AVX = True) then
         Put ("AVX ");
      end if;
      if (CPUFeatures.F16C = True) then
         Put ("F16C ");
      end if;
      if (CPUFeatures.RDRND = True) then
         Put ("RDRND ");
      end if;
      if (CPUFeatures.HYPERVISOR = True) then
         Put ("HYPERVISOR ");
      end if;

      New_Line;

      Put_Line (" Initialising Page Directory Table");
      PageDirectoryTable := CPU.MMU.Paging.InitPageDirectoryTable;


--  Perhaps call this Memory.Paging ??? instead of CPU.MMU ?
      if (CPUFeatures.PSE = True) then
         Put_Line (" Enabling Page Size Extensions");
         CPU.MMU.Paging.PageSizeExtensionEnable;
      end if;
      Put_Line (" Enabling Paging");
      CPU.MMU.Paging.Enable (PageDirectoryTable);

--  Set RTC Periodic Interrupt (IRQ 8) to 8192 Hz : 32768 >> (3 - 1) = 8192
      Put_Line (" Enabling IRQ8 (RTC) for Scheduler");
      Device.Timer.RTC.EnablePeriodicInterrupt (3);

--  Enable Debugging
--      CPU.SetTrapFlag;

--  Pass needed information to Scheduler (Code & Data Selectors and TSS for Context Switching)
      Put_Line (" Initialising Scheduler for Multitasking");
      Scheduler.Initialise (Ring3CodeSelector, Ring3DataSelector, CPU.ProtectedMode.TSS);
--      Scheduler.Initialise (Ring0CodeSelector, Ring0DataSelector, CPU.ProtectedMode.TSS);

--  Load Task State Segment Selector into Task Register
--      Put_Line (" Loading Task State Segment Selector into Task Register (Switch to Ring 3)");
--      CPU.ProtectedMode.LoadTR (TSSSelector, Ring3CodeSelector, Ring3DataSelector, Scheduler.TaskA'Address);
      Put_Line (" Re-enabling Interrupts");
--  Switch to Init Process
      CPU.Interrupts.Enable;

--  Add further code to disable all IRQs and NMIs (Watchdog, RTC??, etc)
      Put_Line (" Processor Halted");
      Device.Uart.Put ("Processor Halted");

      CPU.Interrupts.Disable;
      CPU.Halt;

   end kstart;
end Midnite;
