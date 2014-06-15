with CPU; use CPU;
with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use Interfaces;

with Memory; use Memory;
package body CPU.MMU.Paging is

   procedure Enable (PageDirectoryTable : System.Address) is
      CR0 : Double;
   begin
      CPU.WriteCR3 (Double (To_Integer (PageDirectoryTable)));
      CR0 := CPU.ReadCR0;
      CR0 := CR0 or 16#80000000#;
      CPU.WriteCR0 (CR0);
   end Enable;

   function InitPageDirectoryTable return System.Address is
      Physical : access Page;
      PageDirectoryTableAddress : System.Address;

      PageTable : access Page;
      PageTable2 : access Page;
      PageTableAddress : System.Address;
      PageTable2Address : System.Address;
   begin
-- Allocate a single 4kb page for the Page Directory Table
      Physical := Memory.Allocate (1);
-- Blank the Page Directory Table
      for Index in 1 .. 1024 loop
         Physical.Memory (Index) := 16#00000000#;
      end loop;

-- Allocate Memory for the first Page Table
      PageTable := Memory.Allocate (1);
      PageTableAddress := PageTable.all'Address;
-- Add the first Page Table into the Page Directory Table
      Physical.PageDirectory (1).Address := TwentyBits (Shift_Right (Unsigned_32 (To_Integer (PageTableAddress)), 12));
      Physical.PageDirectory (1).Present     := True;
      Physical.PageDirectory (1).ReadWrite   := True;
      Physical.PageDirectory (1).UserSupervisor := True;

-- Identity Map the first Page Table
      for Index in 1 .. 1024 loop
         PageTable.Memory (Index) := 16#00000000#;
         PageTable.PageEntry (Index).Address   := TwentyBits (Index - 1);
         PageTable.PageEntry (Index).Present   := True;
         PageTable.PageEntry (Index).ReadWrite := True;
         PageTable.PageEntry (Index).UserSupervisor := True;
      end loop;

-- Allocate Memory for the second Page Table
      PageTable2 := Memory.Allocate (1);
      PageTable2Address := PageTable2.all'Address;
-- Add the first Page Table into the Page Directory Table
      Physical.PageDirectory (2).Address := TwentyBits (Shift_Right (Unsigned_32 (To_Integer (PageTable2Address)), 12));
      Physical.PageDirectory (2).Present     := True;
      Physical.PageDirectory (2).ReadWrite   := True;
      Physical.PageDirectory (2).UserSupervisor := True;

-- Identity Map the first Page Table
      for Index in 1024 .. 2048 loop
         PageTable2.Memory (Index) := 16#00000000#;
         
         PageTable2.PageEntry (Index).Address   := TwentyBits (Index - 1);
         PageTable2.PageEntry (Index).Present   := True;
         PageTable2.PageEntry (Index).ReadWrite := True;
         PageTable2.PageEntry (Index).UserSupervisor := True;
      end loop;


--      Physical.Memory (1024) := 16#00000000#;
      PageDirectoryTableAddress := Physical.all'Address;
--      Physical.PageDirectory (1024).Address := TwentyBits (Shift_Right (Unsigned_32 (To_Integer (PageDirectoryTableAddress)), 12));
--      Physical.PageDirectory (1024).Present     := True;
--      Physical.PageDirectory (1024).ReadWrite   := True;
--      Physical.PageDirectory (1024).PageSize   := True;

      return PageDirectoryTableAddress;
   end InitPageDirectoryTable;

   procedure PageSizeExtensionEnable is
      CR4 : Double;
   begin
      CR4 := ReadCR4;
      CR4 := CR4 or 16#00000010#;
      WriteCR4 (CR4);
   end PageSizeExtensionEnable;
end CPU.MMU.Paging;
