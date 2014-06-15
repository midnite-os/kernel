with Console; use Console;
with Types; use Types;
with CPU; use CPU;

package body Device.PCI is
   procedure Detect is
      PCIPort1 : Word := 16#CF8#;
      PCIPort2 : Word := 16#CFA#;
      PCIPort3 : Word := 16#CFC#;

      Data : Double := 16#80000000# + (0 * 2048) + 0;
   begin
      CPU.OutputByte (PCIPort1, 0);
      CPU.OutputByte (PCIPort2, 0);

      CPU.OutputDouble (PCIPort1, Data);

      Data := CPU.InputDouble (PCIPort3);

      Console.Put (Integer'Image (Integer (Data)), 1, 20);

   end Detect;
end Device.PCI;
