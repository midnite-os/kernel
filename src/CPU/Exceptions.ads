package CPU.Exceptions is
-- 0x00	Division by zero
   procedure DivideByZero;
-- 0x01	Debugger
   procedure Debugger;
-- 0x02	NMI
   procedure NonMaskableInterrupt;
-- 0x03	Breakpoint
   procedure Breakpoint;
-- 0x04	Overflow
   procedure Overflow;
-- 0x05	Bounds
   procedure Bounds;
-- 0x06	Invalid Opcode
   procedure InvalidOpcode;
-- 0x07	Coprocessor not available
   procedure CoprocessorNotAvailable;
-- 0x08	Double fault
   procedure DoubleFault;
-- 0x09	Coprocessor Segment Overrun (386 or earlier only)
   procedure CoprocessorSegmentOverrun;
-- 0x0A	Invalid Task State Segment
   procedure InvalidTSS;
-- 0x0B	Segment not present
   procedure SegmentNotPresent;
-- 0x0C	Stack Fault
   procedure StackFault;
-- 0x0D	General protection fault
   procedure GeneralProtectionFault;
-- 0x0E	Page fault
   procedure PageFault;
-- 0x10	Math Fault
   procedure MathFault;
-- 0x11	Alignment Check
   procedure AlignmentCheck;
-- 0x12	Machine Check
   procedure MachineCheck;
-- 0x13	SIMD Floating-Point Exception
   procedure SIMDFloatingPointException;
-- 0x0F and 0x14 - 0x20 are all Reserved
   procedure UndocumentedException;
end CPU.Exceptions;
