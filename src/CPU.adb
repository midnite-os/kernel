package body CPU is
   procedure SetTrapFlag is
      EFlags : Double;
   begin
      EFlags := ReadFlags;
      EFlags := EFlags or 16#100#;
      WriteFlags (EFlags);
   end SetTrapFlag;
end CPU;
      
