with Interfaces; use Interfaces;

--
-- TODO:
-- 1. Define a constant that relates to the size in bytes occupied by a descriptor
--    e.g 8 for a 32 bit Protected Mode descriptor.
--    Use this constant throughout so that we don't use 8, it is more descriptive.
-- 2. Change GDT index range from 0 to ... to simplify code here.
--    This will mean that the Null descriptor is at Index 0, then the real descriptors start
--    at 1. This makes more sense.
-- 3. Think of a solution to the GDTR incrementation. It is a little messy to start at 7 then add 8 each
--    time. Perhaps we could start at -1. It would cause a triple fault if the GDT was loaded, but it would
--    be exactly the same if it was loaded with only a Null Descriptor.

package body CPU.ProtectedMode.GDT is

   procedure Init is
   begin
      GDTR.Length := -1;
      GDTR.Address := GDT'Address;
   end Init;

   procedure AddNullDescriptor is
      Index : Word;
   begin
--  Increment GDTR Length by 8 Bytes;
      GDTR.Length := GDTR.Length + 8;
--  Divide by 8 to get position in GDT array
      Index := (GDTR.Length + 1) / 8;

      GDT (Index).Code_LimitLow              := 0;
      GDT (Index).Code_LimitHigh             := 0;

      GDT (Index).Code_BaseLow               := 0;
      GDT (Index).Code_BaseMiddle            := 0;
      GDT (Index).Code_BaseHigh              := 0;

      GDT (Index).Code_AccessByte.Present    := False;
      GDT (Index).Code_AccessByte.Privilege  := CPU.ProtectedMode.Ring0;
      GDT (Index).Code_AccessByte.CodeData   := False;
      GDT (Index).Code_AccessByte.Executable := False;
      GDT (Index).Code_AccessByte.Conforming := False;

      GDT (Index).Code_Flags.Granularity     := False;
      GDT (Index).Code_Flags.Size            := False;
   end AddNullDescriptor;

   function  AddCodeDescriptor   (Base           : Double;
                                  Limit          : TwentyBits;
                                  Present        : Boolean := True;
                                  Conforming     : Boolean := False;
--  Perhaps default should be Ring3 for security purposes
                                  Privilege      : DescriptorPrivilege :=
                                     CPU.ProtectedMode.Ring0;
--                                  Readable       : Boolean := False;
                                  Readable       : Boolean := True;
--  Needs changing to a word that makes more sense
                                  Granularity    : Boolean := True;
--  Same for Size := True
                                  Size           : Boolean := True) return Word is
      Index : Word;
   begin
--  Increment GDTR Length by 8 Bytes;
      GDTR.Length := GDTR.Length + 8;
--  Divide by 8 to get position in GDT array
      Index := (GDTR.Length + 1) / 8;

      GDT (Index).Code_LimitLow    := Word (Limit and 16#FFFF#);
      GDT (Index).Code_LimitHigh   :=
         Nibble (Shift_Right (Unsigned_32 (Limit), 16));

      GDT (Index).Code_BaseLow     := Word (Base and 16#FFFF#);
      GDT (Index).Code_BaseMiddle  :=
         Byte (Shift_Right (Unsigned_32 (Base and 16#00FF0000#), 16));

      GDT (Index).Code_BaseHigh    := Byte (Shift_Right (Unsigned_32 (Base), 24));

      GDT (Index).Code_AccessByte.Present    := Present;
      GDT (Index).Code_AccessByte.Privilege  := Privilege;
      GDT (Index).Code_AccessByte.CodeData   := True;
      GDT (Index).Code_AccessByte.Executable := True;
      GDT (Index).Code_AccessByte.Conforming := Conforming;
      GDT (Index).Code_AccessByte.Readable   := Readable;

      GDT (Index).Code_Flags.Granularity     := Granularity;
      GDT (Index).Code_Flags.Size            := Size;
      return ((Index - 1) * 8);
   end AddCodeDescriptor;

   function  AddDataDescriptor   (Base           : Double;
                                  Limit          : TwentyBits;
                                  Present        : Boolean := True;
                                  ExpandDown     : Boolean := False;
--  Perhaps default should be Ring3 for security purposes
                                  Privilege      : DescriptorPrivilege :=
                                     CPU.ProtectedMode.Ring0;
                                  Writeable      : Boolean := True;
--  Needs changing to a word that makes more sense
                                  Granularity    : Boolean := True;
--  Same for Size := True
                                  Size           : Boolean := True) return Word is
      Index : Word;
   begin
--  Increment GDTR Length by 8 Bytes;
      GDTR.Length := GDTR.Length + 8;
--  Divide by 8 to get position in GDT array
      Index := (GDTR.Length + 1) / 8;

      GDT (Index).Data_LimitLow    := Word (Limit and 16#FFFF#);
      GDT (Index).Data_LimitHigh   :=
         Nibble (Shift_Right (Unsigned_32 (Limit), 16));

      GDT (Index).Data_BaseLow     := Word (Base and 16#FFFF#);
      GDT (Index).Data_BaseMiddle  :=
         Byte (Shift_Right (Unsigned_32 (Base and 16#00FF0000#), 16));

      GDT (Index).Data_BaseHigh    := Byte (Shift_Right (Unsigned_32 (Base), 24));

      GDT (Index).Data_AccessByte.Present    := Present;
      GDT (Index).Data_AccessByte.Privilege  := Privilege;
      GDT (Index).Data_AccessByte.CodeData   := True;
      GDT (Index).Data_AccessByte.Executable := False;
      GDT (Index).Data_AccessByte.ExpandDown := ExpandDown;
      GDT (Index).Data_AccessByte.Writeable  := Writeable;

      GDT (Index).Data_Flags.Granularity     := Granularity;
      GDT (Index).Data_Flags.Size            := Size;
      return ((Index - 1) * 8);
   end AddDataDescriptor;

   function AddSystemDescriptor (Base           : Double;
                                 Limit          : TwentyBits;
                                 DescriptorType : SystemDescriptorType) return Word is
      Index : Word;
   begin
--  Increment GDTR Length by 8 Bytes;
      GDTR.Length := GDTR.Length + 8;
--  Divide by 8 to get position in GDT array
      Index := (GDTR.Length + 1) / 8;

      GDT (Index).System_LimitLow    := Word (Limit and 16#FFFF#);
      GDT (Index).System_LimitHigh   :=
         Nibble (Shift_Right (Unsigned_32 (Limit), 16));

      GDT (Index).System_BaseLow     := Word (Base and 16#FFFF#);
      GDT (Index).System_BaseMiddle  :=
         Byte (Shift_Right (Unsigned_32 (Base and 16#00FF0000#), 16));

      GDT (Index).System_AccessByte.DescriptorType := DescriptorType;
      GDT (Index).System_AccessByte.Present    := True;
      GDT (Index).System_AccessByte.Privilege  := Ring0;
      return ((Index - 1) * 8);
   end AddSystemDescriptor;

end CPU.ProtectedMode.GDT;
