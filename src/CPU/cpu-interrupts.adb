with Device.PIC; use Device.PIC;

package body CPU.Interrupts is
   procedure Disable is
   begin
      CPU.ClearInterruptFlag;
--  Are we using an APIC or the PIC?
-- if (CPU.APIC = True) then
--    CPU.APIC.Disable ??
-- else
--  Disable all IRQs using PIC
--      Device.PIC.Disable;
-- end if;

-- Disable all NMIs
   end Disable;

   procedure Enable is
   begin
      CPU.SetInterruptFlag;
   end Enable;

end CPU.Interrupts;
