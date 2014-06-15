with Process; use Process;

package Queue is
   type Node;
   type Node_Ptr is access Node;

   type Node is
      record
         Item     : Process_Ptr;
         Previous : Node_Ptr;
         Next     : Node_Ptr;
      end record;

   NewNode        : Node_Ptr;

   type Object is
      record
         CurrentNode    : Node_Ptr;
         FirstNode      : Node_Ptr;
         PreviousNode   : Node_Ptr;
         LastNode       : Node_Ptr;
      end record;

   function  Current     (NodeObj : in Object) return Process_Ptr;
--   function  Next        (NodeObj : in Object) return Process_Ptr;
--   function  Previous    (NodeObj : in Object) return Process_Ptr;

   procedure Next  (NodeObj : in out Object);
   procedure Previous  (NodeObj : in out Object);

   function  EndOfQueue (NodeObj : Object) return Boolean;

   procedure FastForward (NodeObj : in out Object);
   procedure InsertEnd   (NodeObj : in out Object; Proc : Process_Ptr);
   procedure Remove      (NodeObj : in out Object; Proc : Process_Ptr);
   procedure Rewind      (NodeObj : in out Object);
end Queue;
