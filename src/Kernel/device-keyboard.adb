package body Device.Keyboard is

   procedure Init is
      ScanCode : Byte;
      Status : Byte;
   begin

      loop
         Status := CPU.InputByte (16#64#);
         if ((Status and Byte (16#01#)) = 16#01#) then
            ScanCode := CPU.InputByte (16#60#);
            Put (Debug.Byte_To_Hex (ScanCode));
         else
            exit;
         end if;
      end loop;

--      CPU.OutputByte (16#60#, 16#FF#);
--      CPU.OutputByte (16#60#, 16#F0#);
--      CPU.OutputByte (16#60#, 16#02#);

      WriteScanCode (16#FF#);

      WriteScanCode (16#EE#);

      CPU.OutputByte (16#64#, 16#AA#);
      CPU.OutputByte (16#64#, 16#AE#);
   end Init;

   procedure ReadScanCode is
      ScanCode : Byte;
      Status : Byte;

      type CodeVal is array (16#00# .. 16#57#, 1 .. 2) of Character;

--  Scan Code , ASCII Code , ASCII Code with Shift
      ScanCodeTable : CodeVal :=
      (
--  00
       (Character'Val (0), Character'Val (0)),
--  01 - ESC
       (Character'Val (0), Character'Val (0)),
--  02
       ('1', '!'),
--  03
       ('2', '"'),
--  04
       ('3', Character'Val (0)),
--  05
       ('4', '$'),
--  06
       ('5', '%'),
--  07
       ('6', '^'),
--  08
       ('7', '&'),
--  09
       ('8', '*'),
--  0A
       ('9', '('),
--  0B
       ('0', ')'),
--  0C
       ('-', '_'),
--  0D
       ('+', '='),
--  0E - DELETE
       (Character'Val (0), Character'Val (0)),
--  0F - TAB
       (Character'Val (0), Character'Val (0)),
--  10
       ('q', 'Q'),
--  11
       ('w', 'W'),
--  12
       ('e', 'E'),
--  13
       ('r', 'R'),
--  14
       ('t', 'T'),
--  15
       ('y', 'Y'),
--  16
       ('u', 'U'),
--  17
       ('i', 'I'),
--  18
       ('o', 'O'),
--  19
       ('p', 'P'),
--  1A
       ('[', '{'),
--  1B
       (']', '}'),
--  1C - ENTER
       (Character'Val (0), Character'Val (0)),
--  1D - LEFT CTRL
       (Character'Val (0), Character'Val (0)),
--  1E
       ('a', 'A'),
--  1F
       ('s', 'S'),
--  20
       ('d', 'D'),
--  21
       ('f', 'F'),
--  22
       ('g', 'G'),
--  23
       ('h', 'H'),
--  24
       ('j', 'J'),
--  25
       ('k', 'K'),
--  26
       ('l', 'L'),
--  27
       (';', ':'),
--  28
--     (''', '@'),
       (Character'Val (39), '@'),
--  29 - ` ¬
       (Character'Val (96), Character'Val (170)),
--  2A - LEFT SHIFT
       (Character'Val (0), Character'Val (0)),
--  2B
       ('#', '~'),
--  2C
       ('z', 'Z'),
--  2D
       ('x', 'X'),
--  2E
       ('c', 'C'),
--  2F
       ('v', 'V'),
--  30
       ('b', 'B'),
--  31
       ('n', 'N'),
--  32
       ('m', 'M'),
--  33
       (',', '<'),
--  34
       ('.', '>'),
--  35
       ('/', '?'),
--  36 - RIGHT SHIFT
       (Character'Val (0), Character'Val (0)),
--  37 - *
       ('*', '*'),
--  38 - LEFT ALT
       (Character'Val (0), Character'Val (0)),
--  39
       (' ', ' '),
--  3A - CAPSLOCK
       (Character'Val (0), Character'Val (0)),
--  3B - F1
       (Character'Val (0), Character'Val (0)),
--  3C - F2
       (Character'Val (0), Character'Val (0)),
--  3D - F3
       (Character'Val (0), Character'Val (0)),
--  3E - F4
       (Character'Val (0), Character'Val (0)),
--  3F - F5
       (Character'Val (0), Character'Val (0)),
--  40 - F6
       (Character'Val (0), Character'Val (0)),
--  41 - F7
       (Character'Val (0), Character'Val (0)),
--  42 - F8
       (Character'Val (0), Character'Val (0)),
--  43 - F9
       (Character'Val (0), Character'Val (0)),
--  44 - F10
       (Character'Val (0), Character'Val (0)),
--  45 - NUMLOCK
       (Character'Val (0), Character'Val (0)),
--  46 - SCROLL LOCK
       (Character'Val (0), Character'Val (0)),
--  47 .. 49
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
--  4A - "-"
       ('-', '-'),
--  4B .. 55
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
       (Character'Val (0), Character'Val (0)),
--  56
       ('\', '|'),
       (Character'Val (0), Character'Val (0))
       );
--  57,57 - F11
--  58,58 - F12
   begin
      Asm ("PUSHA");

      loop
         Status := CPU.InputByte (16#64#);
         if ((Status and Byte (16#01#)) = 16#01#) then
            ScanCode := CPU.InputByte (16#60#);
--            Put (Byte_To_Hex (ScanCode));
         else
            exit;
         end if;
      end loop;    

      case ScanCode is
--  00 - Key Detection Error or Internal Buffer Overrun
         when 16#00# =>
            null;
--  01 - ESC
         when 16#01# =>
            Put_Line ("ESC");
--  0E - BACKSPACE
         when 16#0E# =>
            Put_Line ("BACKSPACE");
--  0F - TAB
         when 16#0F# =>
            Put_Line ("TAB");
--  1C - ENTER
         when 16#1C# =>
            Put_Line ("ENTER");
--  1D - LEFT CTRL
         when 16#1D# =>
            Put_Line ("LEFT_CTRL");
--  2A - LEFT SHIFT
         when 16#2A# =>
            Put_Line ("LEFT_SHIFT");
--  36 - RIGHT SHIFT
         when 16#36# =>
            Put_Line ("RIGHT_SHIFT");
--  38 - ALT GR
         when 16#38# =>
            Put_Line ("ALT_GR");
--  3A - CAPS LOCK
         when 16#3A# =>
            Put_Line ("CAPS_LOCK");
--  3B - F1
         when 16#3B# =>
            Put_Line ("F1");
--  3C - F2
         when 16#3C# =>
            Put_Line ("F2");
--  3D - F3
         when 16#3D# =>
            Put_Line ("F3");
--  3E - F4
         when 16#3E# =>
            Put_Line ("F4");
--  3F - F5
         when 16#3F# =>
            Put_Line ("F5");
--  40 - F6
         when 16#40# =>
            Put_Line ("F6");
--  41 - F7
         when 16#41# =>
            Put_Line ("F7");
--  42 - F8
         when 16#42# =>
            Put_Line ("F8");
--  43 - F9
         when 16#43# =>
            Put_Line ("F9");
--  44 - F10
         when 16#44# =>
            Put_Line ("F10");
--  45 - NUM LOCK
         when 16#45# =>
            Put_Line ("NUM_LOCK");
--  46 - SCROLL LOCK
         when 16#46# =>
            Put_Line ("SCROLL_LOCK");
--  47 .. 49 - Unassigned
         when 16#47# .. 16#49# =>
            null;
--  4B .. 54 - Unassigned
         when 16#4B# .. 16#54# =>
            null;
--  C7 .. C9 - Unassigned Release
         when 16#C7# .. 16#C9# =>
            null;
--  CB .. D4 - Unassigned Release
         when 16#CB# .. 16#C4# =>
            null;
--  57,57 - F11
         when 16#57# =>
            null;
--  58,58 - F12
         when 16#58# =>
            null;
--  Key Pressed
         when 16#02# .. 16#0D# |
              16#10# .. 16#1B# |
              16#1E# .. 16#29# |
              16#2B# .. 16#35# |
              16#37# |
              16#39# |
              16#4A# |
              16#56# =>
            Put (ScanCodeTable (Integer (ScanCode), 1));
--  Key Released (Ignoring AA as this is defined below)
         when 16#82# .. 16#8D# |
              16#90# .. 16#9B# |
              16#9E# .. 16#A9# |
              16#AB# .. 16#B5# |
              16#B7# |
              16#B9# |
              16#CA# |
              16#D6# =>
            null;
--  55 - Self Test Passed (Command AA sent using Port 64)
--  AA - Self Test Passed
         when 16#55#  | 16#AA# =>
            null;
--  E0 - Extended Scan Code
         when 16#E0# =>
            null;
--  E1 - Extended Scan Code for Pause Key and others?
         when 16#E1# =>
            null;
--  EE - Response to Echo Command
         when 16#EE# =>
            null;
--  FA - Command Acknowledged
         when 16#FA# =>
            null;
--  Self Test Failed
         when 16#FC# .. 16#FD# =>
            null;
--  FE - Resend Last Command
         when 16#FE# =>
            null;
--  FF - Key Detection Error or Internal Buffer Overrun
         when 16#FF# =>
            null;
--  Key
         when others =>
            Put (Debug.Byte_To_Hex (ScanCode));
      end case;

      CPU.OutputByte (16#20#, 16#20#);
      Asm ("POPA");
      Asm ("LEAVE");
      Asm ("IRET");
   end ReadScanCode;

   procedure WriteScanCode (ScanCode : Byte) is
      Status : Byte;
   begin
      loop
         Status := CPU.InputByte (16#64#);
         if ((Status and Byte (16#02#)) = 16#00#) then
            CPU.OutputByte (16#60#, ScanCode);
            exit;
         end if;
      end loop;    

   end WriteScanCode;
end Device.Keyboard;
