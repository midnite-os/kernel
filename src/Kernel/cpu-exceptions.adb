with CPU.Interrupts; use CPU.Interrupts;
with Console; use Console;
with Device.Uart; use Device.Uart;

with Debug; use Debug;

with System.Machine_Code; use System.Machine_Code;

package body CPU.Exceptions is
-- 0x00	Division by zero
   procedure DivideByZero is
   begin
      Console.Put ("Divide By Zero Exception", 1, 24);
      CPU.Interrupts.Ret;
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end DivideByZero;
-- 0x01	Debugger
   procedure Debugger is
   begin
Debug.DumpRegisters;
--      Console.Put ("Debugger Triggered", 1, 20);
--      Device.Uart.Put ("Debugger Triggered");

Asm ("LEAVE");
Asm ("IRET");
      CPU.Interrupts.Ret;
   end Debugger;
-- 0x02	NMI
   procedure NonMaskableInterrupt is
   begin
      Console.Put ("Non Maskable Interrupt", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end NonMaskableInterrupt;
-- 0x03	Breakpoint
   procedure Breakpoint is
   begin
Debug.DumpRegisters;
      Console.Put ("Breakpoint Encountered", 1, 20);
      CPU.Interrupts.Ret;
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end Breakpoint;
-- 0x04	Overflow
   procedure Overflow is
   begin
      Console.Put ("CPU Overflow", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end Overflow;
-- 0x05	Bounds
   procedure Bounds is
   begin
      Console.Put ("Bounds Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end Bounds;
-- 0x06	Invalid Opcode
   procedure InvalidOpcode is
   begin
--      Debug.DumpRegisters;
      Console.Put ("Invalid Opcode", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end InvalidOpcode;
-- 0x07	Coprocessor not available
   procedure CoprocessorNotAvailable is
   begin
      Console.Put ("Coprocessor Not Available", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end CoprocessorNotAvailable;
-- 0x08	Double fault
   procedure DoubleFault is
   begin
      Console.Put ("Double Fault", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end DoubleFault;
-- 0x09	Coprocessor Segment Overrun (386 or earlier only)
   procedure CoprocessorSegmentOverrun is
   begin
      Console.Put ("Coprocessor Segment Overrun", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end CoprocessorSegmentOverrun;
-- 0x0A	Invalid Task State Segment
   procedure InvalidTSS is
   begin
      Console.Put ("Invalid TSS", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end InvalidTSS;
-- 0x0B	Segment not present
   procedure SegmentNotPresent is
   begin
      Console.Put ("Segment Not Present Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end SegmentNotPresent;
-- 0x0C	Stack Fault
   procedure StackFault is
   begin
      Console.Put ("Stack Fault", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end StackFault;
-- 0x0D	General protection fault
   procedure GeneralProtectionFault is
   begin
Asm ("CLI");
Asm ("HLT");
      Console.Put ("General Protection Fault", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end GeneralProtectionFault;
-- 0x0E	Page fault
   procedure PageFault is
      PageFaultCode : Double;
   begin
-- Debug.DumpRegisters;
      PageFaultCode := Debug.GetPageFaultCode;
      Put_Line ("Code: " & Double_To_Hex (PageFaultCode) );
--      Debug.DumpPageFaultCode;
--      Console.Clear;
      Console.Put_Line ("Page Fault Exception");
      Put_Line ("Address: " & Double_To_Hex (CPU.ReadCR2) );
--      Console.Put ("Page Fault Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end PageFault;
-- 0x10	Math Fault
   procedure MathFault is
   begin
      Console.Put ("Math Fault Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end MathFault;
-- 0x11	Alignment Check
   procedure AlignmentCheck is
   begin
      Console.Put ("Alignment Check Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end AlignmentCheck;
-- 0x12	Machine Check
   procedure MachineCheck is
   begin
      Console.Put ("Machine Check Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end MachineCheck;
-- 0x13	SIMD Floating-Point Exception
   procedure SIMDFloatingPointException is
   begin
      Console.Put ("SIMD Floating-Point Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end SIMDFloatingPointException;
-- 0x0F and 0x14 - 0x20 are all Reserved
   procedure UndocumentedException is
   begin
      Console.Put ("Undocumented Exception", 1, 24);
      CPU.Interrupts.Disable;
      CPU.Halt;
   end UndocumentedException;
end CPU.Exceptions;
