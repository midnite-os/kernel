with System; use System;

package CPU.ProtectedMode is

   type DescriptorType is
     (CodeDescriptor, DataDescriptor, SystemDescriptor);

   type DescriptorPrivilege is
     (Ring0,
      Ring1,
      Ring2,
      Ring3);

   for DescriptorPrivilege use
     (Ring0      => 16#0#,
      Ring1      => 16#1#,
      Ring2      => 16#2#,
      Ring3      => 16#3#);

   for DescriptorPrivilege'Size use 2;

-- Task State Segment

   type TaskStateSegment is
      record
         prev_tss   : Double;   -- The previous TSS - if we used hardware task switching this would form a linked list.
         esp0       : Double;   -- The stack pointer to load when we change to kernel mode.
         ss0        : Double;   -- The stack segment to load when we change to kernel mode.
         esp1       : Double;   -- everything below here is unused now.. 
         ss1        : Double;
         esp2       : Double;
         ss2        : Double;
         cr3        : Double;
         eip        : Double;
         eflags     : Double;
         eax        : Double;
         ecx        : Double;
         edx        : Double;
         ebx        : Double;
         esp        : Double;
         ebp        : Double;
         esi        : Double;
         edi        : Double;
         es         : Double;
         cs         : Double;
         ss         : Double;
         ds         : Double;
         fs         : Double;
         gs         : Double;
         ldt        : Double;
         trap       : Word;
         iomap_base : Word;
      end record;

   pragma Pack (TaskStateSegment);
   for TaskStateSegment'Size use 832;

   TSS : aliased TaskStateSegment;

   procedure CreateTSS;
--
   procedure Enable;

   procedure LoadCS (CodeSelector : Word);
   procedure LoadDS (DataSelector : Word);
   procedure LoadES (DataSelector : Word);
   procedure LoadFS (DataSelector : Word);
   procedure LoadGS (DataSelector : Word);
   procedure LoadSS (StackSelector : Word);

   procedure LoadTR (TSSSelector  : Word; CodeSelector : Word; DataSelector : Word; Ring3Address : System.Address);

   pragma Import (C, LoadCS, "load_cs");
   pragma Import (C, LoadDS, "load_ds");
   pragma Import (C, LoadES, "load_es");
   pragma Import (C, LoadFS, "load_fs");
   pragma Import (C, LoadGS, "load_gs");
   pragma Import (C, LoadSS, "load_ss");

   pragma Import (C, LoadTR, "load_tr");
end CPU.ProtectedMode;
