--  with Interfaces; use Interfaces;
with System.Storage_Elements; use System.Storage_Elements;

package body CPU.ProtectedMode.IDT is

   procedure Init is
   begin
--      IDTR.Length := (256 * 8) - 1;
      IDTR.Length := -1;
      IDTR.Address := IDT'Address;

-- The first 32 Descriptors are reserved for Exceptions
--      AddInterruptDescriptor (xxx'Address, Selector???, True, CPU.ProtectedMode.Ring0, False, InterruptGate386);

-- The next 16 Descriptors are reserved for Hardware IRQs
--      AddInterruptDescriptor (xxx'Address, Selector???, True, CPU.ProtectedMode.Ring0, False, InterruptGate386);

-- Finally the rest of the Descriptors are for Software Interrupts
-- They are all set to unhandled interrupt routine, not present, privilege 0
--      for each Descriptor
--         Set Default Values
--      endforeach
   end Init;

   procedure AddInterruptDescriptor (Offset         : System.Address;
                                     Selector       : Word;
                                     Present        : Boolean := True;
                                     Privilege      : DescriptorPrivilege := Ring0;
                                     StorageSegment : Boolean := False;
                                     DescriptorType : InterruptDescriptorType) is
      Index : Word;
   begin
--  Increment GDTR Length by 8 Bytes;
      IDTR.Length := IDTR.Length + 8;
--  Divide by 8 to get position in GDT array
      Index := (IDTR.Length + 1) / 8;

      IDT (Index).OffsetLow                     := Word (Unsigned_32 (To_Integer (Offset)) and 16#FFFF#);
      IDT (Index).OffsetHigh                    := Word (Shift_Right (Unsigned_32 (To_Integer (Offset)), 16));

      IDT (Index).Selector                      := Selector;
      IDT (Index).Zero                          := 0;

      IDT (Index).TypeAttributes.Present        := Present;
      IDT (Index).TypeAttributes.Privilege      := Privilege;
      IDT (Index).TypeAttributes.StorageSegment := StorageSegment;
      IDT (Index).TypeAttributes.DescriptorType := DescriptorType;

   end AddInterruptDescriptor;

end CPU.ProtectedMode.IDT;
