with Types; use Types;
with System; use System;
with Interfaces; use Interfaces;

package Debug.Instruction is

--   type Byte is mod 2**8;

   Instructions : array (Double range 16#0000_0000# .. 16#FFFF_FFFF#) of aliased Byte;

--   Memory : array (Integer range 1 .. (1024 * 1024)) of aliased Page;
   for Instructions'Address use System'To_Address (16#00000000#);
   pragma Import (Ada, Instructions);





--   subtype InstructionSequence is String (1 .. 15);
   subtype Mnemonic            is String (1 .. 24);

--   subtype Opcode              is Character;
   subtype Opcode_Hex_String   is String (1 .. 2);
   subtype Double_Hex_String   is String (1 .. 8);

--   Instructions : aliased InstructionSequence;

--   type Instruction_Ptr is access all Byte;

--   MachineCode  : Instruction_Ptr := Instructions'Access;
-- := Instructions'Access;

   EIP : Double;

--   MachineCode := Instructions'Access;

--   function Decode (Instruction : Instruction_Ptr) return Mnemonic;
--   function Decode (Instruction : Byte) return Mnemonic;
   procedure SetAddress (Address : Double);
   function Decode return Mnemonic;
   function Fetch return Byte;
   function Fetch_Double return Double;
   function Byte_To_Hex (Input : Byte) return Opcode_Hex_String;
   function Double_To_Hex (Input : Double) return Double_Hex_String;
end Debug.Instruction;
