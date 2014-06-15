with Console; use Console;

with Debug.Instruction; use Debug.Instruction;

with System.Machine_Code; use System.Machine_Code;

with CPU; use CPU;
with CPU.Interrupts; use CPU.Interrupts;

package body Debug is

   function Nibble_To_Hex (Input : Nibble) return Nibble_Hex_String is
      Output : Nibble_Hex_String := "0";
   begin

      if Input < 10 then
         Output (1) := Character'Val(Integer (Input) + 48);
      else
         Output (1) := Character'Val(Integer (Input) + 55);
      end if;

      return Output;
   end Nibble_To_Hex;

   function Byte_To_Hex (Input : Byte) return Byte_Hex_String is
      Output : Byte_Hex_String := "00";
      WorkingValue : Byte;
      Result : Byte;
      Exponent : Natural := 1;
      Index : Natural := 1;

      function To_Hex_Char (Input : Byte) return Character is
         Output : Character;
      begin
         if Input < 10 then
            Output := Character'Val(Input + 48);
         else
            Output := Character'Val(Input + 55);
         end if;
         return Output;
      end To_Hex_Char;
   begin
      WorkingValue := Input;

      loop
         if Exponent = 0 then
            exit;
         end if;

         Result := WorkingValue / (16 ** Exponent);
         WorkingValue := WorkingValue - (Result * (16 ** Exponent));

         Output (Index) := To_Hex_Char (Result);

         Exponent := Exponent - 1;
         Index := Index + 1;
      end loop;

      Result := WorkingValue mod 16;
      Output (Index) := To_Hex_Char (Result);

      return Output;
   end Byte_To_Hex;


   function Double_To_Hex (Input : Double) return Double_Hex_String is
--      type Double is mod 2**32;

--      Input : Double := 3735928559;
--      Input : Double := 48879;
--      Input  : Double := 4660;
      WorkingValue : Double;
      Output : Double_Hex_String := "00000000";

      Result : Double;
      Exponent : Natural := 7;
      Index : Natural := 1;

      function To_Hex_Char (Input : Double) return Character is
         Output : Character;
      begin
         if Input < 10 then
            Output := Character'Val(Input + 48);
         else
            Output := Character'Val(Input + 55);
         end if;
         return Output;
      end To_Hex_Char;
   begin

      WorkingValue := Input;

      loop
         if Exponent = 0 then
            exit;
         end if;

         Result := WorkingValue / (16 ** Exponent);
         WorkingValue := WorkingValue - (Result * (16 ** Exponent));

         Output (Index) := To_Hex_Char (Result);

         Exponent := Exponent - 1;
         Index := Index + 1;
      end loop;

      Result := WorkingValue mod 16;
      Output (Index) := To_Hex_Char (Result);

      return Output;
   end Double_To_Hex;

   procedure DumpPageFaultCode is
   begin
      Put_Line ("Code: " & Double_To_Hex (GetPageFaultCode) );
   end DumpPageFaultCode;


   procedure DumpRegisters is
      R : Registers_Ptr;
      M : Mnemonic;
   begin
--      CPU.OutputByte (16#20#, 16#FF#);
--      CPU.OutputByte (16#A0#, 16#FF#);
--      Asm ("CLI");
-- Console.Clear;

      R := GetRegisters;

--      Put_Line ("");
--      Put_Line ("");
      Put_Line ("  CS: " & Double_To_Hex (R.CS) &
                " EIP: " & Double_To_Hex (R.EIP));

      Put_Line ("  SS: " & Double_To_Hex (R.SS) &
		" ESP: " & Double_To_Hex (R.ESP) &
                " EBP: " & Double_To_Hex (R.EBP));

      Put_Line (" ESI: " & Double_To_Hex (R.ESI) &
                " EDI: " & Double_To_Hex (R.EDI));

      Put_Line ("  DS: " & Double_To_Hex (R.DS) &
                "  ES: " & Double_To_Hex (R.ES) &
                "  FS: " & Double_To_Hex (R.FS) &
                "  GS: " & Double_To_Hex (R.GS));

      Put_Line (" EAX: " & Double_To_Hex (R.EAX) &
                " EBX: " & Double_To_Hex (R.EBX) &
                " ECX: " & Double_To_Hex (R.ECX) &
                " EDX: " & Double_To_Hex (R.EDX));

--      Put (" EFLAGS: " & Double_To_Hex (R.EFLAGS));
--      Put (" GDTR: ");
--      Put (" IDTR: ");
--      Put (" LDTR: ");
--      Put (" TR  : ");

      Instruction.SetAddress (R.EIP);

      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);
      Put_Line (" " & Double_To_Hex (Instruction.EIP) & ": " & Instruction.Decode);

      Asm ("HLT");

   end DumpRegisters;
end Debug;
