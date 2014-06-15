package body Queue is
   procedure InsertEnd (NodeObj : in out Object; Proc : Process_Ptr) is
   begin
      NewNode := new Node;
      NewNode.Item := Proc;

      if (NodeObj.FirstNode = null) then
         NodeObj.FirstNode := NewNode;
         NodeObj.PreviousNode := NewNode;
         NodeObj.CurrentNode := NewNode;
         NodeObj.LastNode := NewNode;

         NodeObj.LastNode.Next := null;
         NodeObj.FirstNode.Previous := null;
      else
         NodeObj.LastNode.Next := NewNode;
         NewNode.Previous := NodeObj.LastNode;
         NodeObj.LastNode := NewNode;
         NodeObj.LastNode.Next := null;
      end if;
   end InsertEnd;

   procedure Remove (NodeObj : in out Object; Proc : Process_Ptr) is
   begin
      null;
   end Remove;

   function  Current (NodeObj : in Object) return Process_Ptr is
   begin
      return NodeObj.CurrentNode.Item;
   end Current;

   function  EndOfQueue (NodeObj : Object) return Boolean is
   begin
      if (NodeObj.CurrentNode.Next = null) then
         return True;
      else
         return False;
      end if;
   end EndOfQueue;

   procedure FastForward (NodeObj : in out Object) is
   begin
      NodeObj.CurrentNode := NodeObj.LastNode;
   end FastForward;

   procedure Next (NodeObj : in out Object) is
   begin
      if (NodeObj.CurrentNode.Next /= null) then
         NodeObj.CurrentNode := NodeObj.CurrentNode.Next;
      else
         NodeObj.CurrentNode := NodeObj.LastNode;
      end if;
--      return NodeObj.CurrentNode.Item;
   end Next;

   procedure Previous (NodeObj : in out Object) is
   begin
      if (NodeObj.CurrentNode.Previous /= null) then
         NodeObj.CurrentNode := NodeObj.CurrentNode.Previous;
      end if;
--      return NodeObj.CurrentNode.Item;
   end Previous;

   procedure Rewind (NodeObj : in out Object) is
   begin
      NodeObj.CurrentNode := NodeObj.FirstNode;
   end Rewind;
end Queue;
