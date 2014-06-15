with System; use System;

package CPU.MMU.Paging is

   type PageDirectoryEntry is
      record
         Present        : Boolean;
         ReadWrite      : Boolean;
         UserSupervisor : Boolean;
         WriteThrough   : Boolean;
         CacheDisabled  : Boolean;
         Accessed       : Boolean;
         Reserved       : Boolean;
         PageSize       : Boolean;
         Global         : Boolean;
         Available1	: Boolean;		-- Change to 3 Bit
         Available2	: Boolean;		--
         Available3	: Boolean;		--
         Address        : TwentyBits;
      end record;

   for PageDirectoryEntry'Size use 32;
   pragma Pack (PageDirectoryEntry);

   type PageTableEntry is
      record
         Present        : Boolean;
         ReadWrite      : Boolean;
         UserSupervisor : Boolean;
         WriteThrough   : Boolean;
         CacheDisabled  : Boolean;
         Accessed       : Boolean;
         Dirty          : Boolean;
         Reserved       : Boolean;
         Global         : Boolean;
         Available1	: Boolean;		-- Change to 3 Bit
         Available2	: Boolean;		--
         Available3	: Boolean;		--
         Address        : TwentyBits;
      end record;

   for PageTableEntry'Size use 32;
   pragma Pack (PageTableEntry);

   type PageDirectoryT is array (Integer range 1 .. 1024) of PageDirectoryEntry;

   PageDirectory : PageDirectoryT;

   type PageTable is array (Integer range 1 .. 1024) of PageTableEntry;

   procedure Enable (PageDirectoryTable : System.Address);

   procedure PageSizeExtensionEnable;

   type PageTableBitmap is array (Integer range 1 .. 32) of Double;
   for PageTableBitmap'Size use 1024;

   MemoryAllocationBitmap : array (Integer range 1 .. 1024) of PageTableBitmap;

   function InitPageDirectoryTable return System.Address;
end CPU.MMU.Paging;
