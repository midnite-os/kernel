with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use Interfaces;

package body Memory is

-- Give this a better name
   PhysicalAddress : access Page;

   function Allocate (Pages : Integer) return access Page is
--      Address : System.Address;
      Index : Integer;
   begin

-- Reserve the page for the Interrupt Vector Table & BIOS Data Area

-- This needs to use the detected amount of Memory
-- This assumes that 4GB is available.
      for Index in 1 .. (1024 * 1024) loop
-- Check to see if the Page has already been allocated
         if (PhysicalPageBitmap(Index) = False) then
-- Set the page as allocated
            PhysicalPageBitmap(Index) := True;
-- Return a pointer to 
            PhysicalAddress := Memory (Index)'Access;
            exit;
         end if;
      end loop;
      return PhysicalAddress;
   end Allocate;

   procedure Reserve (Address : Double; Length : Double) is
      Pages : Integer;
      Index : Integer := 1;
      Start : Integer;
      Finish : Integer;
   begin

      Pages := Integer ((Length / 16#1000#));
      Start := Integer (Shift_Right (Unsigned_32 (Address), 12) + 1);
      Finish := Start + Pages;

      for Index in Start .. Finish loop
         PhysicalPageBitmap (Index) := True;
      end loop;

   end Reserve;

end Memory;
