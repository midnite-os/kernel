with CPU; use CPU;
with Console; use Console;
with Types; use Types;

package body Memory.A20 is
   procedure Enable is
      StatusByte : Byte;
      CheckByte : Byte;
   begin
      StatusByte := CPU.InputByte(16#92#);
      CheckByte := StatusByte and 16#2#;

      if (CheckByte = 2) then
-- A20 Already Enabled
         Put_Line (" A20 Line Already Enabled");
      else
         Put_Line (" Enabling A20 Line");
         StatusByte := StatusByte or 2;
         StatusByte := StatusByte and 16#FE#;
         CPU.OutputByte(16#92#, StatusByte);
      end if;
   end Enable;
end Memory.A20;
