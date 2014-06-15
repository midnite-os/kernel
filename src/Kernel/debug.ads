with Types; use Types;
with System; use System;

package Debug is

-- MOVE INTO TYPES.ADS
--   type Double is mod 2**32;
   subtype Nibble_Hex_String is String (1 .. 1);
   subtype Byte_Hex_String   is String (1 .. 2);
   subtype Double_Hex_String is String (1 .. 8);

-- MOVE INTO TYPES.ADS

   type Registers is
      record
-- TR
-- LDTR
-- GDTR
-- IDTR
-- CR0
-- CR2
-- CR3
-- CR4
-- DR0
-- DR1
         GS     : Double;
         FS     : Double;
         ES     : Double;
         DS     : Double;
         CS     : Double;
         SS	: Double;
         EIP    : Double;
         EFlags : Double;
         EDI    : Double;
         ESI    : Double;
         EBP    : Double;
         ESP    : Double;
         EBX    : Double;
         EDX    : Double;
         ECX    : Double;
         EAX    : Double;
      end record;

   type Registers_Ptr is access Registers;

   function Nibble_To_Hex (Input : Nibble) return Nibble_Hex_String;
   function Byte_To_Hex   (Input : Byte)   return Byte_Hex_String;
   function Double_To_Hex (Input : Double) return Double_Hex_String;

   function GetRegisters return Registers_Ptr;
   function GetPageFaultCode return Double;

   procedure DumpPageFaultCode;
   procedure DumpRegisters;



   pragma Import (C, GetRegisters, "registers");

   pragma Import (C, GetPageFaultCode, "get_page_fault_code");

end Debug;
