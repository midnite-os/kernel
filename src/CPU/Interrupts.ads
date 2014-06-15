package CPU.Interrupts is
   procedure Disable;
   procedure Enable;
   procedure Ret;
   procedure Trigger (Interrupt : Byte);

   pragma Import (C, Ret, "opcode_iret");
   pragma Import (C, Trigger, "opcode_int");
end CPU.Interrupts;
