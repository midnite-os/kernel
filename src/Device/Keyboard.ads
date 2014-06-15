with Types; use Types;
with CPU; use CPU;

with Interfaces; use Interfaces;

with Console; use Console;
with Debug; use Debug;
with System.Machine_Code; use System.Machine_Code;

package Device.Keyboard is
   procedure Init;
   procedure ReadScanCode;
   procedure WriteScanCode (ScanCode : Byte);
end Device.Keyboard;
