with Interfaces; use Interfaces;
with System; use System;

package CPU.ProtectedMode.IDT is

   type InterruptDescriptorType is
     (Reserved1,
      TSS286,
      LDT,
      TSS286Busy,
      CallGate,
      TaskGate,				--  <- These
      InterruptGate286,			--  <- are
      TrapGate286,			--  <- the
      Reserved2,
      TSS386Available,
      Reserved3,
      TSS386Busy,
      CallGate386,
      Reserved4,
      InterruptGate386,			--  <- only valid
      TrapGate386);			--  <- types.

--
-- Need to define this as a subtype of SystemDescriptorType???
-- Use range to specify the allowed ranges of the subtype as 5-7 and E-F
--
   for InterruptDescriptorType use
     (Reserved1        => 16#0#,
      TSS286           => 16#1#,
      LDT              => 16#2#,
      TSS286Busy       => 16#3#,
      CallGate         => 16#4#,
      TaskGate         => 16#5#,	--  <- These
      InterruptGate286 => 16#6#,	--  <- are
      TrapGate286      => 16#7#,	--  <- the
      Reserved2        => 16#8#,
      TSS386Available  => 16#9#,
      Reserved3        => 16#A#,
      TSS386Busy       => 16#B#,
      CallGate386      => 16#C#,
      Reserved4        => 16#D#,
      InterruptGate386 => 16#E#,	--  <- only valid
      TrapGate386      => 16#F#);	--  <- types.

   for InterruptDescriptorType'Size use 4;

   type TypeAttributesByte is
      record
         DescriptorType : InterruptDescriptorType;
         StorageSegment : Boolean;
         Privilege      : DescriptorPrivilege;
         Present        : Boolean;
      end record;

   for TypeAttributesByte'Size use 8;
   pragma Pack (TypeAttributesByte);

   type InterruptDescriptor is
      record
         OffsetLow      : Word;
         Selector       : Word;
         Zero           : Byte;
         TypeAttributes : TypeAttributesByte;
         OffsetHigh     : Word;
       end record;

   for InterruptDescriptor'Size use 64;

   pragma Pack (InterruptDescriptor);

   type InterruptDescriptorTable is array (Word range 1 .. 256) of InterruptDescriptor;

   IDT : InterruptDescriptorTable;

   type IDTR_Record is
      record
         Length     : Word;
         Address    : System.Address;
      end record;

   for IDTR_Record'Size use 48;

   pragma Pack (IDTR_Record);

   IDTR : IDTR_Record;

   procedure AddInterruptDescriptor (Offset         : System.Address;
                                     Selector       : Word;
                                     Present        : Boolean := True;
                                     Privilege      : DescriptorPrivilege := Ring0;
                                     StorageSegment : Boolean := False;
                                     DescriptorType : InterruptDescriptorType);

   procedure Init;

   procedure Load (Address : System.Address);
   pragma Import (C, Load, "load_idt");
end CPU.ProtectedMode.IDT;
