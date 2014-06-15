package body Debug.Instruction is
--   EIP        : aliased Double := 0;


   procedure SetAddress (Address : Double) is
   begin
      EIP := Address;
   end SetAddress;

--   function Decode (Instruction : Byte) return Mnemonic is
   function Decode return Mnemonic is
      Assembly : Mnemonic := "UNKNOWN / UNDEF         ";
--      Opcode : Byte;
      Instruction : Byte;

      subtype Register is String (1 .. 20);
--
      function Decode_RM (Operand : Byte; Instruction : Byte) return Register is

         subtype R8  is String (1 .. 2);
         subtype R16 is String (1 .. 2);
         subtype R32 is String (1 .. 3);

         function To_Register8 (Operand : Byte) return R8 is
         begin
            case Operand is
               when 0 => return "AL";
               when 1 => return "CL";
               when 2 => return "DL";
               when 3 => return "BL";
               when 4 => return "AH";
               when 5 => return "CH";
               when 6 => return "DH";
               when 7 => return "BH";
               when others => null; -- return "  ";
            end case;
            return "  ";
         end To_Register8;

         function To_Register32 (Operand : Byte) return R32 is
         begin
            case Operand is
               when 0 => return "EAX";
               when 1 => return "ECX";
               when 2 => return "EDX";
               when 3 => return "EBX";
               when 4 => return "ESP";
               when 5 => return "EBP";
               when 6 => return "ESI";
               when 7 => return "EDI";
               when others => null; -- return "   ";
            end case;
            return "   ";
         end To_Register32;

         Op1 : Byte;
         Op2 : Byte;
         R   : Register := "                    ";

         type Mod_bits is mod 2**2;
--         pragma Pack (Mod_bits);
         for Mod_bits'Size use 2;

         M   : Mod_bits;
         I   : Byte;
      begin
         Op1 := Operand and 16#7#;
         Op2 := Byte (Shift_Right (Unsigned_32 (Operand), 3) and 16#7#);

         I   := Instruction and 16#7#;

         M   := Mod_bits (Shift_Right (Unsigned_32 (Operand), 6));

         case I is
--  r/m8     - r8
            when 0 =>
               case M is
                  when 2#11# =>
                     R := To_Register8 (Op1) & ", " & To_Register8 (Op2) & "              ";
                  when 2#10# =>
                     case Op1 is
                        when 0 .. 3 |
                             6 .. 7 =>
                           R := "[" & To_Register32 (Op1) & " +              ";
                        when 4 =>
--  SIB
                           R := "[sib                ";
                        when 5 =>
--  dest32
                           R := "[dest32             ";
                        when others => null;
                     end case;
                  when 2#01# =>
                     declare
                        Offset : Byte;
                     begin
                        Offset := Fetch;
                        case Op1 is
                           when 0 .. 3 | 
                                5 .. 7 =>
                              R := "[" & To_Register32 (Op1) & " + 16#" & Byte_To_Hex (Offset) & "#], " & To_Register8 (Op2) & "  ";
                           when 4 =>
--  SIB
                              R := "                    ";
                           when others => null;
                        end case;
                     end;
                  when 2#00# =>
                     R := "[" & To_Register32 (Op1) & "], " & To_Register8 (Op2) & "           ";
               end case;
--  r/m16/32 - r16/32
            when 1 =>
               case M is
                  when 2#11# =>
                     R := To_Register32 (Op1) & ", " & To_Register32 (Op2) & "            ";
                  when 2#10# =>
                     case Op1 is
                        when 0 .. 3 |
                             6 .. 7 =>
                           R := "[" & To_Register32 (Op1) & " +              ";
                        when 4 =>
--  SIB
                           R := "[sib                ";
                        when 5 =>
--  dest32
                           R := "[dest32             ";
                        when others => null;
                     end case;
                  when 2#01# =>
                     declare
                        Offset : Byte;
                     begin
                        Offset := Fetch;
                        case Op1 is
                           when 0 .. 3 | 
                                5 .. 7 =>
                              R := "[" & To_Register32 (Op1) & " + 16#" & Byte_To_Hex (Offset) & "#], " & To_Register32 (Op2) & " ";
                           when 4 =>
--  SIB
                              R := "                    ";
                           when others => null;
                        end case;
                     end;
                  when 2#00# =>
                     R := "[" & To_Register32 (Op1) & "], " & To_Register32 (Op2) & "          ";
               end case;
--  r8       - r/m8
            when 2 =>
               case M is
                  when 2#11# =>
                     R := To_Register8 (Op2) & ", " & To_Register8 (Op1) & "              ";
                  when 2#10# =>
                     case Op1 is
                        when 0 .. 3 |
                             6 .. 7 =>
                           R := To_Register8 (Op2) & ", [" & To_Register32 (Op1) & " +          ";
                        when 4 =>
--  SIB
                           R := To_Register8 (Op2) & ", [sib            ";
                        when 5 =>
--  dest32
                           R := To_Register8 (Op2) & ", [dest32         ";
                        when others => null;
                     end case;
                  when 2#01# =>
                     declare
                        Offset : Byte;
                     begin
                        Offset := Fetch;
                        case Op1 is
                           when 0 .. 3 | 
                                5 .. 7 =>
                              R := "[" & To_Register32 (Op1) & " + 16#" & Byte_To_Hex (Offset) & "#], " & To_Register8 (Op2) & "  ";
                           when 4 =>
--  SIB
                              R := "                    ";
                           when others => null;
                        end case;
                     end;
                  when 2#00# =>
                     R := To_Register8 (Op2) & ", [" & To_Register32 (Op1) & "]           ";
               end case;
--  r16/32   - r/m16/32
            when 3 =>
               case M is
                  when 2#11# =>
                     R := To_Register32 (Op2) & ", " & To_Register32 (Op1) & "            ";
                  when 2#10# =>
                     case Op1 is
                        when 0 .. 3 |
                             6 .. 7 =>
                           R := "   , [" & To_Register32 (Op1) & " +         ";
                        when 4 =>
--  SIB
                           R := "   , [sib           ";
                        when 5 =>
--  dest32
                           R := "   , [dest32        ";
                        when others => null;
                     end case;
                  when 2#01# =>
                     declare
                        Offset : Byte;
                     begin
                        Offset := Fetch;
                        case Op1 is
                           when 0 .. 3 | 
                                5 .. 7 =>
                              R := To_Register32 (Op2) & ", [" & To_Register32 (Op1) & " + 16#" & Byte_To_Hex (Offset) & "#] ";
                           when 4 =>
--  SIB
                              R := "                    ";
                           when others => null;
                        end case;
                     end;
                  when 2#00# =>
                     R := To_Register32 (Op2) & ", [" & To_Register32 (Op1) & "]          ";
               end case;
            when 4 =>
               R := "AL, 16#" & Byte_To_Hex (Operand) & "#          ";
            when 5 =>
               R := "EAX, 16#00000000#   ";
            when others =>
               null;
         end case;
         return R;
      end Decode_RM;

   begin
      Instruction := Instructions (EIP);
      case Instruction is
--  ADD
         when 16#00# .. 16#05# =>
            Assembly := "ADD " & Decode_RM (Fetch, Instruction);
--  PUSH ES
         when 16#06# =>
            Assembly := "PUSH ES                 ";
--  POP ES
         when 16#07# =>
            Assembly := "POP ES                  ";
--  OR
         when 16#08# .. 16#0E# =>
            Assembly := "OR  " & Decode_RM (Fetch, Instruction);
--  Two Byte Instructions
         when 16#0F# =>
            null;
--  ADC
         when 16#10# .. 16#15# =>
            Assembly := "ADC " & Decode_RM (Fetch, Instruction);
--  PUSH SS
         when 16#16# =>
            Assembly := "PUSH SS                 ";
--  POP SS
         when 16#17# =>
            Assembly := "POP SS                  ";
--  SBB
         when 16#18# .. 16#1D# =>
            Assembly := "SBB " & Decode_RM (Fetch, Instruction);
--  PUSH DS
         when 16#1E# =>
            Assembly := "PUSH DS                 ";
--  POP DS
         when 16#1F# =>
            Assembly := "POP DS                  ";
--  AND
         when 16#20# .. 16#25# =>
            Assembly := "XOR " & Decode_RM (Fetch, Instruction);
--  ES:
         when 16#26# =>
            Assembly := "ES:                     ";
--  DAA AL
         when 16#27# =>
            Assembly := "DAA AL                  ";
--  SUB
         when 16#28# .. 16#2D# =>
            Assembly := "SBB " & Decode_RM (Fetch, Instruction);
--  CS:
         when 16#2E# =>
            Assembly := "CS:                     ";
--  DAS AL
         when 16#2F# =>
            Assembly := "DAS AL                  ";
--  XOR
         when 16#30# .. 16#35# =>
            Assembly := "XOR " & Decode_RM (Fetch, Instruction);
--  SS:
         when 16#36# =>
            Assembly := "SS:                     ";
--  AAA AL
         when 16#37# =>
            Assembly := "AAA AL                  ";
--  CMP
         when 16#38# .. 16#3D# =>
            Assembly := "CMP " & Decode_RM (Fetch, Instruction);
--  DS:
         when 16#3E# =>
            Assembly := "DS:                     ";
--  AAS AL
         when 16#3F# =>
            Assembly := "AAS AL                  ";
--  INC
         when 16#40# .. 16#47# =>
            Assembly := "INC                     ";
--  DEC
         when 16#48# .. 16#4F# =>
            Assembly := "DEC                     ";
--  PUSH
         when 16#50# .. 16#57# =>
            Assembly := "PUSH                    ";
--  POP
         when 16#58# .. 16#5F# =>
            Assembly := "POP                     ";
--  PUSHA / PUSHAD
         when 16#60# =>
            Assembly := "PUSHAD                  ";
--  POPA / POPAD
         when 16#61# =>
            Assembly := "POPAD                   ";
--  BOUND
         when 16#62# =>
            Assembly := "BOUND                   ";
--  ARPL
         when 16#63# =>
            Assembly := "ARPL                    ";
--  FS:
         when 16#64# =>
            Assembly := "FS:                     ";
--  GS:
         when 16#65# =>
            Assembly := "GS:                     ";
--  Operand / Precision size prefix
         when 16#66# =>
            Assembly := "O32                     ";
--  Address size prefix
         when 16#67# =>
            Assembly := "ADDR32                  ";
         when 16#68# =>
            Assembly := "PUSH 16#" & Double_To_Hex (Fetch_Double) & "#       ";
         when 16#69# =>
            Assembly := "IMUL                    ";
         when 16#6A# =>
            Assembly := "PUSH 16#" & Byte_To_Hex (Fetch) & "#            ";
         when 16#6B# =>
            Assembly := "IMUL                    ";
         when 16#6C# =>
            Assembly := "INSB                    ";
         when 16#6D# =>
            Assembly := "INSW/D                  ";
         when 16#6E# =>
            Assembly := "OUTSB                   ";
         when 16#6F# =>
            Assembly := "OUTSW/D                 ";
--  Branch Instructions
         when 16#70# .. 16#7F# =>
            Assembly := "J                       ";
         when 16#80# .. 16#83# =>
      SetAddress (EIP + 2);
            Assembly := "arith                   ";
         when 16#84# .. 16#85# =>
            Assembly := "TEST                    ";
         when 16#86# .. 16#87# =>
            Assembly := "XCHG                    ";
         when 16#8D# =>
            Assembly := "LEA                     ";
         when 16#8F# =>
            Assembly := "POP                     ";
--  MOV
         when 16#88# .. 16#8C# |
              16#8E# |
              16#A0# .. 16#A3# |
              16#B0# .. 16#B7# |
              16#C6# |
              16#C7# =>
            Assembly := "MOV " & Decode_RM (Fetch, Instruction);
         when 16#B8# .. 16#BF# =>
            Assembly := "MOV 16#" & Double_To_Hex (Fetch_Double) & "#        ";
--  XCHG
         when 16#90# .. 16#97# =>
            Assembly := "XCHG                    ";
         when 16#98# =>
            Assembly := "CWDE                    ";
--  NOP and XCHG EAX, EAX have the same encoding
            if Assembly = "XCHG EAX, EAX           " then
               Assembly := "NOP                     ";
            end if;
--  CWD / CDQ
         when 16#99# =>
            Assembly := "CWD/CDQ                 ";
--  CALL
         when 16#9A# =>
            Assembly := "CALL                    ";
--  Wait prefix & FWAIT / WAIT
         when 16#9B# =>
            null;
--  PUSHF / PUSHFD
         when 16#9C# =>
            Assembly := "PUSHFD                  ";
--  POPF / POPFD
         when 16#9D# =>
            Assembly := "POPFD                   ";
--  SAHF
         when 16#9E# =>
            Assembly := "SAHF                    ";
--  LAHF
         when 16#9F# =>
            Assembly := "LAHF                    ";
--  MOVSB
         when 16#A4# =>
            Assembly := "MOVSB                   ";
--  MOVSW/MOVSD
         when 16#A5# =>
            Assembly := "MOVSW/MOVSD             ";
--  CMPSB
         when 16#A6# =>
            Assembly := "CMPSB                   ";
--  CMPSW/CMPSD
         when 16#A7# =>
            Assembly := "CMPSW/CMPSD             ";
--  TEST
         when 16#A8# .. 16#A9# =>
            Assembly := "TEST                    ";
--  STOSB
         when 16#AA# =>
            Assembly := "STOSB                   ";
--  STOSW/STOSD
         when 16#AB# =>
            Assembly := "STOSW/STOSD             ";
--  LODSB
         when 16#AC# =>
            Assembly := "LODSB                   ";
--  LODSW/LODSD
         when 16#AD# =>
            Assembly := "LODSW/LODSD             ";
--  SCASB
         when 16#AE# =>
            Assembly := "SCASB                   ";
--  SCASW/SCASD
         when 16#AF# =>
            Assembly := "SCASW/SCASD             ";
--  SHIFT / ROTATE
         when 16#C0# .. 16#C1# |
              16#D0# .. 16#D3# =>
            Assembly := "shift / rotate          ";
--  RETN
         when 16#C2# =>
            Assembly := "RETN imm16              ";
--  RETN
         when 16#C3# =>
            Assembly := "RETN                    ";
--  LES
         when 16#C4# =>
            Assembly := "LES                     ";
--  LDS
         when 16#C5# =>
            Assembly := "LDS                     ";
--  ENTER
         when 16#C8# =>
            Assembly := "ENTER                   ";
--  LEAVE
         when 16#C9# =>
            Assembly := "LEAVE                   ";
--  RETF
         when 16#CA# .. 16#CB# =>
            Assembly := "RETF                    ";
--  INT3
         when 16#CC# =>
            Assembly := "INT3                    ";
--  INT
         when 16#CD# =>
--  Fetch next opcode
            declare
               Interrupt : Byte;
            begin
               Interrupt := Fetch;
--  Convert to Hex
               Assembly := "INT 16#" & Byte_To_Hex (Interrupt) & "#              ";
            end;
--  INTO
         when 16#CE# =>
            Assembly := "INTO                    ";
--  IRET / IRETD
         when 16#CF# =>
--            Assembly := "IRET                    ";
            Assembly := "IRETD                   ";
--  AAM / AMX
         when 16#D4# =>
            Assembly := "AAM/AMX                 ";
--  AAD / ADX
         when 16#D5# =>
            Assembly := "AAD/ADX                 ";
--  SALC / SETALC
         when 16#D6# =>
            Assembly := "SALC/SETALC             ";
--  XLATB
         when 16#D7# =>
            Assembly := "XLATB                   ";
--  Floating Point
         when 16#D8# .. 16#DF# =>
            Assembly := "floating point          ";
--  LOOPNZ / LOOPNE
         when 16#E0# =>
            Assembly := "LOOPNZ / LOOPNE         ";
--  LOOPZ / LOOPE
         when 16#E1# =>
            Assembly := "LOOPZ / LOOPE           ";
--  LOOP
         when 16#E2# =>
            Assembly := "LOOP                    ";
--  JCXZ / JECXZ
         when 16#E3# =>
            Assembly := "JCXZ / JECXZ            ";
--  IN
         when 16#E4# =>
            Assembly := "IN AL, 16#" & Byte_To_Hex (Fetch) & "#           ";
--  IN
         when 16#E5# =>
            Assembly := "IN eAX, 16#" & Byte_To_Hex (Fetch) & "#          ";
--  OUT
         when 16#E6# =>
            Assembly := "OUT 16#" & Byte_To_Hex (Fetch) & "#, AL          ";
--  OUT
         when 16#E7# =>
            Assembly := "OUT 16#" & Byte_To_Hex (Fetch) & "#, eAX           ";
--  CALL
         when 16#E8# =>
            Assembly := "CALL 16#" & Double_To_Hex (Fetch_Double) & "#       ";
--  JMP
         when 16#E9# .. 16#EB# =>
            Assembly := "JMP                     ";
--  IN
         when 16#EC# =>
            Assembly := "IN AL, DX               ";
--  IN
         when 16#ED# =>
            Assembly := "IN eAX, DX              ";
--  OUT
         when 16#EE# =>
            Assembly := "OUT DX, AL              ";
--  OUT
         when 16#EF# =>
            Assembly := "OUT DX, eAX             ";
--  LOCK
         when 16#F0# =>
            Assembly := "LOCK                    ";
--  ICEBP
         when 16#F1# =>
            Assembly := "INT1                    ";
--  REPNZ / REPNE / REP / REPZ / REPE
         when 16#F2# .. 16#F3# =>
            Assembly := "REP                     ";
--  HLT
         when 16#F4# =>
            Assembly := "HLT                     ";
--  CMC
         when 16#F5# =>
            Assembly := "CMC                     ";
--  
         when 16#F6# .. 16#F7# =>
            Assembly := "arithmetic              ";
--  CLC
         when 16#F8# =>
            Assembly := "CLC                     ";
--  STC
         when 16#F9# =>
            Assembly := "STC                     ";
--  CLI
         when 16#FA# =>
            Assembly := "CLI                     ";
--  STI
         when 16#FB# =>
            Assembly := "STI                     ";
--  CLD
         when 16#FC# =>
            Assembly := "CLD                     ";
--  STD
         when 16#FD# =>
            Assembly := "STD                     ";
--  INC / DEC
         when 16#FE# =>
            Assembly := "INC / DEC               ";
--  INC / DEC / CALL / CALLF / JMP / JMPF / PUSH
         when 16#FF# =>
            Assembly := "INC / DEC / CALL / CA...";
      end case;
      SetAddress (EIP + 1);
      return Assembly;
   end Decode;

   function Fetch return Byte is
--      Operand : Byte;
   begin
--      Operand := Character'Pos (Instructions (EIP));
--      Operand := Instructions (Instruction.EIP);
      EIP := EIP + 1;
      SetAddress (EIP);
--      return Operand;
      return Instructions (EIP);
   end Fetch;

   function Fetch_Double return Double is
      Operand : Double;
      Byte1 : Byte;
      Byte2 : Byte;
      Byte3 : Byte;
      Byte4 : Byte;
   begin
      Byte1 := Fetch;
      Byte2 := Fetch;
      Byte3 := Fetch;
      Byte4 := Fetch;

      Operand := Double (Byte1) + (Double (Byte2) * 256) + (Double (Byte3) * 65536) + (Double (Byte4) * 256 * 256 * 256);
      return Operand;
   end Fetch_Double;

   function Byte_To_Hex (Input : Byte) return Opcode_Hex_String is
      Output       : Opcode_Hex_String := "00";
      Result       : Natural;
      WorkingValue : Natural;
      function To_Hex_Char (Input : Natural) return Byte is
         Output : Byte;
      begin
         if Input < 10 then
            Output := Byte (Input + 48);
         else
            Output := Byte (Input + 55);
         end if;
         return Output;
      end To_Hex_Char;
   begin
      WorkingValue := Integer (Input);
      Result := WorkingValue / 16;
      Output (1) := Character'Val (To_Hex_Char (Result));

      WorkingValue := WorkingValue - (Result * 16);
      Result := WorkingValue mod 16;
      Output (2) := Character'Val (To_Hex_Char (Result));

      return Output;
   end Byte_To_Hex;

   function Double_To_Hex (Input : Double) return Double_Hex_String is
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

end Debug.Instruction;
