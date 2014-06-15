with Types; use Types;
with System; use System;

with CPU.MMU.Paging; use CPU.MMU.Paging;

with System.Unsigned_Types; use System.Unsigned_Types;
package Memory is

-- A single 4kb page is represented in the Bitmap matrix as 1 bit
--   Page -> 1 bit

-- There is a 4GB address space which means we have 1024 x 1024 x 4kb

   type PageBitmap is array (Integer range 1 .. (1024 * 1024)) of Boolean;

   pragma Pack (PageBitmap);
   for PageBitmap'Size use 16#1000_00#;

   PhysicalPageBitmap : PageBitmap;

   type PageType is
     (Raw, PageDirectory, PageTable);

   type A is array (Integer range 1 .. 1024) of Double;
   type B is array (Integer range 1 .. 1024) of PageTableEntry;

   type Page (Page_Type : PageType := Raw) is
      record
         case Page_Type is
            when Raw =>
               Memory : A;
            when PageDirectory =>
               PageDirectory : PageDirectoryT;
            when PageTable =>
               PageEntry : B;
         end case;
      end record;
   pragma Unchecked_Union (Page);

   Memory : array (Integer range 1 .. (1024 * 1024)) of aliased Page;
   for Memory'Address use System'To_Address (16#00000000#);
   pragma Import (Ada, Memory);

   function Allocate (Pages : Integer) return access Page;
   procedure Reserve (Address : Double; Length : Double);

   pragma Export (C, Allocate, "__gnat_malloc");

end Memory;
