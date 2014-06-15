with System; use System;

package Process is
   type ProcessLevel is
      (User, Supervisor);

   subtype ProcessName is String (1 .. 10);

   type ProcessState is
      (Run, Wait);

   type Process;
   type Process_Ptr is access Process;

   type Process is
      record
         ID         : Integer;
         Level      : ProcessLevel;
         State      : ProcessState;
         Name       : ProcessName;
         PC         : System.Address;
      end record;
end Process;
