with Interfaces; use Interfaces;
with Types; use Types;

package CPU is

   type CPUIDType is
     (CPUID0, CPUID1);

   subtype VendorString is String (1 .. 12);

   type X is mod 2**2;

   type Features (CPUID_Type : CPUIDType := CPUID0) is
      record
         case CPUID_Type is
            when CPUID0 =>
               Vendor         : VendorString;
               MaxID          : Double;
            when CPUID1 =>
               EBX            : Double;

-- EDX
               FPU            : Boolean;
               VME            : Boolean;
               DE             : Boolean;
               PSE            : Boolean;
               TSC            : Boolean;
               MSR            : Boolean;
               PAE            : Boolean;
               MCE            : Boolean;

               CX8            : Boolean;
               APIC           : Boolean;
               Reserved1      : Boolean;
               SEP            : Boolean;
               MTRR           : Boolean;
               PGE            : Boolean;
               MCA            : Boolean;
               CMOV           : Boolean;

               PAT            : Boolean;
               PSE36          : Boolean;
               PN             : Boolean;
               CLFLUSH        : Boolean;
               Reserved2      : Boolean;
               DTS            : Boolean;
               ACPI           : Boolean;
               MMX            : Boolean;

               FXSR           : Boolean;
               SSE            : Boolean;
               SSE2           : Boolean;
               SS             : Boolean;
               HT             : Boolean;
               TM             : Boolean;
               IA64           : Boolean;
               PBE            : Boolean;
-- ECX
               PNI            : Boolean;
               PCLMULQDQ      : Boolean;
               DTES64         : Boolean;
               MONITOR        : Boolean;
               DS_CPL         : Boolean;
               VMX            : Boolean;
               SMX            : Boolean;
               EST            : Boolean;

               TM2            : Boolean;
               SSSE3          : Boolean;
               CID            : Boolean;
               Reserved3      : Boolean;
               FMA            : Boolean;
               CX16           : Boolean;
               XTPR           : Boolean;
               PDCM           : Boolean;

               Reserved4      : Boolean;
               PCID           : Boolean;
               DCA            : Boolean;
               SSE4_1         : Boolean;
               SSE4_2         : Boolean;
               X2APIC         : Boolean;
               MOVBE          : Boolean;
               POPCNT         : Boolean;

               TSCDEAD        : Boolean;
               AES            : Boolean;
               XSAVE          : Boolean;
               OSXSAVE        : Boolean;
               AVX            : Boolean;
               F16C           : Boolean;
               RDRND          : Boolean;
               HYPERVISOR     : Boolean;

               Stepping       : Nibble;
               Model          : Nibble;
               Family         : Nibble;
               ProcessorType  : X;
               ExtendedModel  : Nibble;
               ExtendedFamily : Nibble;
               Unused         : X;
         end case;

      end record;

   for Features'Size use 128;
   pragma Pack (Features);
   pragma Unchecked_Union (Features);

   type Features_Ptr is access Features;

   procedure SetTrapFlag;

   procedure ClearInterruptFlag;

   procedure SetInterruptFlag;

   procedure Halt;

   function  ID (EAX : Unsigned_32) return Features_Ptr;

   function  InputByte    (Port : Word) return Byte;
   function  InputWord    (Port : Word) return Word;
   function  InputDouble  (Port : Word) return Double;

   procedure OutputByte   (Port : Word; Data : Byte);
   procedure OutputWord   (Port : Word; Data : Word);
   procedure OutputDouble (Port : Word; Data : Double);

   function  ReadCR0 return Double;
   function  ReadCR2 return Double;
   function  ReadCR3 return Double;
   function  ReadCR4 return Double;

   function  ReadDR0 return Double;
   function  ReadDR1 return Double;
   function  ReadDR2 return Double;
   function  ReadDR3 return Double;
   function  ReadDR6 return Double;
   function  ReadDR7 return Double;

   function  ReadFlags return Double;

   procedure WriteCR0 (CR0 : Double);
   procedure WriteCR2 (CR2 : Double);
   procedure WriteCR3 (CR3 : Double);
   procedure WriteCR4 (CR4 : Double);

   procedure WriteDR0 (DR0 : Double);
   procedure WriteDR1 (DR1 : Double);
   procedure WriteDR2 (DR2 : Double);
   procedure WriteDR3 (DR3 : Double);
   procedure WriteDR6 (DR6 : Double);
   procedure WriteDR7 (DR7 : Double);

   procedure WriteFlags (Flags : Double);

   pragma Import (C, ClearInterruptFlag, "opcode_cli");
   pragma Import (C, SetInterruptFlag,   "opcode_sti");

   pragma Import (C, Halt, "opcode_hlt");

   pragma Import (C, ID, "proc_cpuid");

   pragma Import (C, InputByte,   "input_byte");
   pragma Import (C, InputWord,   "input_word");
   pragma Import (C, InputDouble, "input_double");

   pragma Import (C, OutputByte,   "output_byte");
   pragma Import (C, OutputWord,   "output_word");
   pragma Import (C, OutputDouble, "output_double");

   pragma Import (C, ReadCR0, "read_cr0");
   pragma Import (C, ReadCR2, "read_cr2");
   pragma Import (C, ReadCR3, "read_cr3");
   pragma Import (C, ReadCR4, "read_cr4");

   pragma Import (C, ReadDR0, "read_dr0");
   pragma Import (C, ReadDR1, "read_dr1");
   pragma Import (C, ReadDR2, "read_dr2");
   pragma Import (C, ReadDR3, "read_dr3");
   pragma Import (C, ReadDR6, "read_dr6");
   pragma Import (C, ReadDR7, "read_dr7");

   pragma Import (C, ReadFlags, "read_flags");

   pragma Import (C, WriteCR0, "write_cr0");
   pragma Import (C, WriteCR2, "write_cr2");
   pragma Import (C, WriteCR3, "write_cr3");
   pragma Import (C, WriteCR4, "write_cr4");

   pragma Import (C, WriteDR0, "write_dr0");
   pragma Import (C, WriteDR1, "write_dr1");
   pragma Import (C, WriteDR2, "write_dr2");
   pragma Import (C, WriteDR3, "write_dr3");
   pragma Import (C, WriteDR6, "write_dr6");
   pragma Import (C, WriteDR7, "write_dr7");

   pragma Import (C, WriteFlags, "write_flags");
end CPU;
