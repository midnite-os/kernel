with CPU; use CPU;
with Types; use Types;

package body Device.Uart is
   procedure Put (Char : Character) is
   begin
      CPU.OutputByte (16#3F8#, Byte (Character'Pos (Char)));
   end Put;

   procedure Put (Str  : String) is
   begin
      for Index in Str'First .. Str'Last loop
         Uart.Put (Str (Index));
      end loop;
   end Put;
end Device.Uart;
