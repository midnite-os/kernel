-- Make the IRQ handlers use Inline functions.
-- Otherwise we are leaving dead code with leave and ret instructions
-- hanging after the IRET
-- pragma Inline


with Console; use Console;
with CPU.Interrupts; use CPU.Interrupts;
with Interfaces; use Interfaces;

with System.Machine_Code; use System.Machine_Code;

package body Device.PIC is
   Sequence1 : Integer := 1;
   Sequence2 : Integer := 1;

   procedure Disable is
   begin
      CPU.OutputByte (PIC1_DataPort, 16#FF#);
      CPU.OutputByte (PIC2_DataPort, 16#FF#);
   end;

   procedure Enable is
   begin
      CPU.OutputByte (PIC1_DataPort, 16#00#);
      CPU.OutputByte (PIC2_DataPort, 16#00#);
   end;

   procedure Initialise  is
      ICW1          : InitialisationCommandWord1;
      MasterICW2    : InitialisationCommandWord2;
      SlaveICW2     : InitialisationCommandWord2;
      MasterICW3    : InitialisationCommandWord3;
      SlaveICW3     : InitialisationCommandWord3;
      ICW4          : InitialisationCommandWord4;

      MasterOCW1    : OperationalCommandWord1;
      SlaveOCW1     : OperationalCommandWord1;
--  These two variables store the former Interrupt Masks for the chips.
      OldMasterOCW1 : OperationalCommandWord1;
      OldSlaveOCW1  : OperationalCommandWord1;
   begin
      ICW1.ICW4Required := True;
      ICW1.SingleMode := False;
      ICW1.InterruptVector4Byte := False;
      ICW1.LevelTriggeredMode := False;
      ICW1.ICW1BeingIssued := True;
      ICW1.Unused1 := False;
      ICW1.Unused2 := False;
      ICW1.Unused3 := False;

--  Set IRQ 0 to be at Interrupt 20 hex (32 decimal)
      MasterICW2 := 16#20#;
--  Set IRQ 8 to be at Interrupt 28 hex (40 decimal)
      SlaveICW2  := 16#28#;

--  Make sure that both Command Words start with nothing set
      MasterICW3.IRPin0 := False;
      MasterICW3.IRPin1 := False;
      MasterICW3.IRPin2 := False;
      MasterICW3.IRPin3 := False;
      MasterICW3.IRPin4 := False;
      MasterICW3.IRPin5 := False;
      MasterICW3.IRPin6 := False;
      MasterICW3.IRPin7 := False;
      SlaveICW3 := MasterICW3;
--  Slave is Cascaded through Pin2 (IRQ 2) of Master PIC
--  Master handles IRQs 0-7
      MasterICW3.IRPin2 := True;
--  Slave is Cascaded to Pin 1 (IRQ 9) of Slave PIC
--  Slave handles IRQs 8-15
      SlaveICW3.IRPin1 := True;

      ICW4.Reserved3 := False;
      ICW4.Reserved2 := False;
      ICW4.Reserved1 := False;
      ICW4.SpecialFullyNestedMode := False;
      ICW4.Buffered := False;
      ICW4.MasterSlave := False;
      ICW4.AutoEOI := False;
      ICW4.Mode8086 := True;

      MasterOCW1.Pin0Mask := True;
      MasterOCW1.Pin1Mask := True;
--  This enables IRQ 2 which is necessary for the Slave PIC to function
      MasterOCW1.Pin2Mask := False;
      MasterOCW1.Pin3Mask := True;
      MasterOCW1.Pin4Mask := True;
      MasterOCW1.Pin5Mask := True;
      MasterOCW1.Pin6Mask := True;
      MasterOCW1.Pin7Mask := True;

--  This enables IRQ 9 which is necessary for the Slave PIC to function
      SlaveOCW1.Pin0Mask := False;
      SlaveOCW1.Pin1Mask := False;
      SlaveOCW1.Pin2Mask := True;
      SlaveOCW1.Pin3Mask := True;
      SlaveOCW1.Pin4Mask := True;
      SlaveOCW1.Pin5Mask := True;
      SlaveOCW1.Pin6Mask := True;
      SlaveOCW1.Pin7Mask := True;

--      OldMasterOCW1 := Byte (CPU.InputByte (PIC1_DataPort));
--      OldSlaveOCW1 := Byte (CPU.InputByte (PIC2_DataPort));

--  Send data out to the PIC Ports

--  These are not using the structures that are defined above as we need to get this working quickly
--  Either figure out how to convert a record to an integer or make a function to do it for us.
      CPU.OutputByte (PIC1_CommandPort, 16#11#);
      CPU.OutputByte (PIC2_CommandPort, 16#11#);
      CPU.OutputByte (PIC1_DataPort, MasterICW2);
      CPU.OutputByte (PIC2_DataPort, SlaveICW2);
      CPU.OutputByte (PIC1_DataPort, 16#04#);
      CPU.OutputByte (PIC2_DataPort, 16#02#);
      CPU.OutputByte (PIC1_DataPort, 16#01#);
      CPU.OutputByte (PIC2_DataPort, 16#01#);

      CPU.OutputByte (PIC1_DataPort, 16#00#);
      CPU.OutputByte (PIC2_DataPort, 16#00#);

--      CPU.OutputByte (PIC1_CommandPort, ICW1);
--      CPU.OutputByte (PIC2_CommandPort, ICW1);
--      CPU.OutputByte (PIC1_DataPort, MasterICW2);
--      CPU.OutputByte (PIC2_DataPort, SlaveICW2);
--      CPU.OutputByte (PIC1_DataPort, MasterICW3);
--      CPU.OutputByte (PIC2_DataPort, SlaveICW3);
--      CPU.OutputByte (PIC1_DataPort, ICW4);
--      CPU.OutputByte (PIC2_DataPort, ICW4);

--      CPU.OutputByte (PIC1_DataPort, MasterOCW1);
--      CPU.OutputByte (PIC2_DataPort, SlaveOCW1);
   end Initialise;

   procedure Mask is
   begin
      null;
   end Mask;

   procedure Remap (Offset1 : Byte; Offset2 : Byte) is
   begin
      null;
   end;

   procedure IRQ0 is
   begin
--CPU.Interrupts.Disable;
Asm ("PUSHA");
      if (Sequence1 = 1) then
         Console.Put ("/", 1, 1);
         Sequence1 := Sequence1 + 1;
      elsif (Sequence1 = 2) then
         Console.Put ("-", 1, 1);
         Sequence1 := Sequence1 + 1;
      elsif (Sequence1 = 3) then
         Console.Put ("\", 1, 1);
         Sequence1 := Sequence1 + 1;
      elsif (Sequence1 = 4) then
         Console.Put ("|", 1, 1);
         Sequence1 := 1;
      end if;

--CPU.Interrupts.Ret;
      CPU.OutputByte (16#20#, 16#20#);
Asm ("POPA");
Asm ("LEAVE");
Asm ("IRET");
--Asm("IRET");
--      CPU.Interrupts.Disable;
--CPU.Halt;

   end IRQ0;

   procedure IRQ1 is
   begin
Asm ("PUSHA");
      Put_Line ("IRQ1");
      CPU.OutputByte (16#20#, 16#20#);
Asm ("POPA");
Asm ("LEAVE");
Asm ("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ1;

-- We should never execute this code as this IRQ is cascaded to IRQ 9
   procedure IRQ2 is
   begin
      Put_Line ("IRQ2");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ2;

   procedure IRQ3 is
   begin
      Put_Line ("IRQ3");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ3;

   procedure IRQ4 is
   begin
      Put_Line ("IRQ4");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ4;

   procedure IRQ5 is
   begin
      Put_Line ("IRQ5");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ5;

   procedure IRQ6 is
   begin
      Put_Line ("IRQ6");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ6;

   procedure IRQ7 is
   begin
      Put_Line ("IRQ7");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ7;

   procedure IRQ8 is
      RegisterC : Byte;
   begin
Asm ("PUSHA");
      if (Sequence2 = 1) then
         Console.Put ("\", 80, 1);
         Sequence2 := Sequence2 + 1;
      elsif (Sequence2 = 2) then
         Console.Put ("-", 80, 1);
         Sequence2 := Sequence2 + 1;
      elsif (Sequence2 = 3) then
         Console.Put ("/", 80, 1);
         Sequence2 := Sequence2 + 1;
      elsif (Sequence2 = 4) then
         Console.Put ("|", 80, 1);
         Sequence2 := 1;
      end if;

CPU.OutputByte (16#70#, 16#0C#);
RegisterC := CPU.InputByte (16#71#);

      CPU.OutputByte (16#A0#, 16#20#);
      CPU.OutputByte (16#20#, 16#20#);
Asm ("POPA");
Asm ("LEAVE");
Asm ("IRET");
   end IRQ8;

   procedure IRQ9 is
   begin
      Put_Line ("IRQ9");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ9;

   procedure IRQ10 is
   begin
      Put_Line ("IRQ10");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ10;

   procedure IRQ11 is
   begin
      Put_Line ("IRQ11");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ11;

   procedure IRQ12 is
   begin
      Put_Line ("IRQ12");
 Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ12;

   procedure IRQ13 is
   begin
      Put_Line ("IRQ13");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ13;

   procedure IRQ14 is
   begin
      Put_Line ("IRQ14");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ14;

   procedure IRQ15 is
   begin
      Put_Line ("IRQ15");
Asm("IRET");
--      CPU.Interrupts.Disable;
--      CPU.Halt;
   end IRQ15;

end Device.PIC;
