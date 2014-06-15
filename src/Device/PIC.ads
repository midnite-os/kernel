with Types; use Types;
with CPU; use CPU;

package Device.PIC is
   PIC1_CommandPort : constant Word := 16#0020#;
   PIC1_DataPort : constant Word := 16#0021#;

   PIC2_CommandPort : constant Word := 16#00A0#;
   PIC2_DataPort : constant Word := 16#00A1#;

   type InitialisationCommandWord1 is
      record
-- The last three bits are only used on the 8080 and 8085
         Unused3              : Boolean;
         Unused2              : Boolean;
         Unused1              : Boolean;
-- This should always be set to true when issuing ICW1
         ICW1BeingIssued      : Boolean;
-- Sets all IR lines to Level triggered mode, ISA bus only supports Edge
         LevelTriggeredMode   : Boolean;
-- Used only in 8085, sets ISRs to be 4 bytes apart if true
         InterruptVector4Byte : Boolean;
-- This enables or disables the second 8259
-- Set to true to only use the first (Single Mode)
-- Leave false to use both 8259's (Cascaded Mode)
         SingleMode           : Boolean;
         ICW4Required         : Boolean;
      end record;

   for InitialisationCommandWord1'Size use 8;
--   for InitialisationCommandWord1'Component_Size use 1;
   pragma Pack (InitialisationCommandWord1);
   pragma Convention (C, InitialisationCommandWord1);

   subtype InitialisationCommandWord2 is Byte;

   type InitialisationCommandWord3 is
      record
         IRPin7               : Boolean;
         IRPin6               : Boolean;
         IRPin5               : Boolean;
         IRPin4               : Boolean;
         IRPin3               : Boolean;
         IRPin2               : Boolean;
         IRPin1               : Boolean;
         IRPin0               : Boolean;
      end record;

   for InitialisationCommandWord3'Size use 8;
   pragma Pack (InitialisationCommandWord3);

   type InitialisationCommandWord4 is
      record
         Reserved3              : Boolean;
         Reserved2              : Boolean;
         Reserved1              : Boolean;
--  Set to True to enable Special Fully Nested Mode
--  False enables Fully Nested Mode
         SpecialFullyNestedMode : Boolean;
--  This is going to be moved to using a 2 bit record type.
--  The next two are used together
--  Turns on Buffered Mode (used in conjunction with MasterSlave bit)
         Buffered               : Boolean;
--  False indicates Slave, True indicates Master (used in conjunction with Buffered bit)
         MasterSlave            : Boolean;
--  Set to True to enable Automatic End-Of-Interrupt Command, False for Normal EOI
         AutoEOI                : Boolean;
--  Set to True to enable 8086 mode, False for 8085
         Mode8086               : Boolean;
      end record;

   for InitialisationCommandWord4'Size use 8;
   pragma Pack (InitialisationCommandWord4);

   type OperationalCommandWord1 is
      record
         Pin7Mask               : Boolean;
         Pin6Mask               : Boolean;
         Pin5Mask               : Boolean;
         Pin4Mask               : Boolean;
         Pin3Mask               : Boolean;
         Pin2Mask               : Boolean;
         Pin1Mask               : Boolean;
         Pin0Mask               : Boolean;
      end record;

   for OperationalCommandWord1'Size use 8;
   pragma Pack (OperationalCommandWord1);

   type OperationalCommandWord2 is
      record
         RotatePriority         : Boolean;
         SpecificEndOfInterrupt : Boolean;
         EndOfInterrupt         : Boolean;
         Unused1                : Boolean;
         Unused2                : Boolean;
--         Interrupt              : ThreeBits;
         InterruptBit1          : Boolean;
         InterruptBit2          : Boolean;
         InterruptBit3          : Boolean;
      end record;

   for OperationalCommandWord2'Size use 8;
   pragma Pack (OperationalCommandWord2);

   procedure Disable;
   procedure Enable;

   procedure Initialise;
   procedure Mask;

   procedure Remap (Offset1 : Byte; Offset2 : Byte);

   procedure IRQ0;
   procedure IRQ1;
   procedure IRQ2;
   procedure IRQ3;
   procedure IRQ4;
   procedure IRQ5;
   procedure IRQ6;
   procedure IRQ7;
   procedure IRQ8;
   procedure IRQ9;
   procedure IRQ10;
   procedure IRQ11;
   procedure IRQ12;
   procedure IRQ13;
   procedure IRQ14;
   procedure IRQ15;
end Device.PIC;
