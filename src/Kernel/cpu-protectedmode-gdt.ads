with System; use System;
with CPU.ProtectedMode; use CPU.ProtectedMode;
with Types; use Types;

package CPU.ProtectedMode.GDT is

   type SystemDescriptorType is
     (Reserved1,
      TSS286,
      LDT,
      TSS286Busy,
      CallGate,
      TaskGate,
      InterruptGate286,
      TrapGate286,
      Reserved2,
      TSS386Available,
      Reserved3,
      TSS386Busy,
      CallGate386,
      Reserved4,
      InterruptGate386,
      TrapGate386);

   for SystemDescriptorType use
     (Reserved1        => 16#0#,
      TSS286           => 16#1#,
      LDT              => 16#2#,
      TSS286Busy       => 16#3#,
      CallGate         => 16#4#,
      TaskGate         => 16#5#,
      InterruptGate286 => 16#6#,
      TrapGate286      => 16#7#,
      Reserved2        => 16#8#,
      TSS386Available  => 16#9#,
      Reserved3        => 16#A#,
      TSS386Busy       => 16#B#,
      CallGate386      => 16#C#,
      Reserved4        => 16#D#,
      InterruptGate386 => 16#E#,
      TrapGate386      => 16#F#);

   for SystemDescriptorType'Size use 4;

   type CodeDescriptorAccessByte is
      record
         Accessed   : Boolean;                  -- Set to 0 (default)
         Readable   : Boolean;
         Conforming : Boolean;
         Executable : Boolean;                  -- Always 1
         CodeData   : Boolean;                  -- Always 1
         Privilege  : DescriptorPrivilege;
         Present    : Boolean;
      end record;

   for CodeDescriptorAccessByte'Size use 8;
   pragma Pack (CodeDescriptorAccessByte);

   type DataDescriptorAccessByte is
      record
         Accessed   : Boolean;                  -- Set to 0 (default)
         Writeable  : Boolean;
         ExpandDown : Boolean;
         Executable : Boolean;                  -- Always 0
         CodeData   : Boolean;                  -- Always 1
         Privilege  : DescriptorPrivilege;
         Present    : Boolean;
      end record;

   for DataDescriptorAccessByte'Size use 8;
   pragma Pack (DataDescriptorAccessByte);

   type SystemDescriptorAccessByte is
      record
         DescriptorType : SystemDescriptorType;
         CodeData       : Boolean;               -- Always 0
         Privilege      : DescriptorPrivilege;
         Present        : Boolean;
      end record;

   for SystemDescriptorAccessByte'Size use 8;
   pragma Pack (SystemDescriptorAccessByte);

   type CodeDescriptorFlags is
      record
         UserDefined : Boolean;
         Reserved    : Boolean;                   -- 0
         Size        : Boolean;
         Granularity : Boolean;
      end record;

   for CodeDescriptorFlags'Size use 4;
   pragma Pack (CodeDescriptorFlags);

   type DataDescriptorFlags is
      record
         UserDefined : Boolean;
         Reserved    : Boolean;                   -- 0
         Size        : Boolean;
         Granularity : Boolean;
      end record;

   for DataDescriptorFlags'Size use 4;
   pragma Pack (DataDescriptorFlags);

   type SystemDescriptorFlags is
      record
         UserDefined : Boolean;
         Reserved    : Boolean;                   -- 0
         Size        : Boolean;
         Granularity : Boolean;
      end record;

   for SystemDescriptorFlags'Size use 4;
   pragma Pack (SystemDescriptorFlags);

   type Descriptor (Descriptor_Type : DescriptorType := CodeDescriptor) is
      record
         case Descriptor_Type is
            when CodeDescriptor =>
               Code_LimitLow     : Word;
               Code_BaseLow      : Word;
               Code_BaseMiddle   : Byte;
               Code_AccessByte   : CodeDescriptorAccessByte;
               Code_LimitHigh    : Nibble;
               Code_Flags        : CodeDescriptorFlags;
               Code_BaseHigh     : Byte;
            when DataDescriptor =>
               Data_LimitLow     : Word;
               Data_BaseLow      : Word;
               Data_BaseMiddle   : Byte;
               Data_AccessByte   : DataDescriptorAccessByte;
               Data_LimitHigh    : Nibble;
               Data_Flags        : DataDescriptorFlags;
               Data_BaseHigh     : Byte;
            when SystemDescriptor =>
               System_LimitLow   : Word;
               System_BaseLow    : Word;
               System_BaseMiddle : Byte;
               System_AccessByte : SystemDescriptorAccessByte;
               System_LimitHigh  : Nibble;
               System_Flags      : SystemDescriptorFlags;
               System_BaseHigh   : Byte;
         end case;
      end record;

   for Descriptor'Size use 64;

   pragma Pack (Descriptor);
   pragma Unchecked_Union (Descriptor);

   type GlobalDescriptorTable is array (Word range 1 .. 32) of Descriptor;

   GDT : GlobalDescriptorTable;

   type GDTR_Record is
      record
         Length     : Word;
         Address    : System.Address;
      end record;

   for GDTR_Record'Size use 48;

   pragma Pack (GDTR_Record);

   GDTR : GDTR_Record;

   procedure AddNullDescriptor;

   function AddCodeDescriptor (Base           : Double;
                               Limit          : TwentyBits;
                               Present        : Boolean := True;
                               Conforming     : Boolean := False;
                               Privilege      : DescriptorPrivilege := Ring0;
--                               Readable       : Boolean := False;
                               Readable       : Boolean := True;
                               Granularity    : Boolean := True;
                               Size           : Boolean := True) return Word;

   function AddDataDescriptor   (Base           : Double;
                                 Limit          : TwentyBits;
                                 Present        : Boolean := True;
                                 ExpandDown     : Boolean := False;
                                 Privilege      : DescriptorPrivilege := Ring0;
                                 Writeable      : Boolean := True;
                                 Granularity    : Boolean := True;
                                 Size           : Boolean := True) return Word;

   function AddSystemDescriptor (Base           : Double;
                                 Limit          : TwentyBits;
                                 DescriptorType : SystemDescriptorType) return Word;

   procedure Init;

   procedure Load (Address : System.Address);
   pragma Import (C, Load, "load_gdt");
end CPU.ProtectedMode.GDT;
