with System.Machine_Code; use System.Machine_Code;
with Interfaces; use Interfaces;

--  The different timers on the computer have different frequencies
--  therefore we need to be able to work out
--
--      timer cycles per second
--    --------------------------- = timer cycles per process
--          no of processes

--              1000
--    --------------------------- = quantum (in milliseconds)
--          no of processes


--
--     Run Queue
--
--  +-------------------------------------+
--  |        +------+  +------+  +------+ |
--  |        |      |  |      |  |      | |
--  |        |  01  |<-|  06  |<-|  03  | |
--  |        |      |  |      |  |      | |
--  |        +------+  +------+  +------+ |
--  +-------------------------------------+
--
--  Process 03 is at the start of the queue.
--  There is a pointer from 03 to 06 indicating it is next in the queue
--  If a new process needs to be added to the queue then it is added at
--  the end with a pointer from 01.


--  Processes which are blocking are in the Waiting Queue
--  Once they have completed waiting they are added to the end of the Run Queue
--
--     Waiting
--  +-------------------------------------+
--  | +------+ +------+ +------+          |
--  | |      | |      | |      |          |
--  | |  34  | |  15  | |  21  |          |
--  | |      | |      | |      |          |
--  | +------+ +------+ +------+          |
--  | +------+                            |
--  | |      |                            |
--  | |  46  |                            |
--  | |      |                            |
--  | +------+                            |
--  +-------------------------------------+
--

package body Scheduler is

   TaskASeq : Integer := 1;
   TaskBSeq : Integer := 1;

   InitProcess : Boolean := True;

   procedure Initialise (CodeSelector : Word; DataSelector : Word; TSS : TaskStateSegment) is
   begin
--  Save Selectors as these will be used later on when performing Context Switches
      UserLevelCodeSelector := CodeSelector;
      UserLevelDataSelector := DataSelector;

--      Scheduler.CreateProcess ("Kernel", Supervisor);

--      Scheduler.CreateProcess ("init", User, Scheduler.Init'Address)
      Scheduler.CreateProcess ("Task A    ", User, Scheduler.TaskA'Address);
      Scheduler.CreateProcess ("Task B    ", User, Scheduler.TaskB'Address);
   end Initialise;

   procedure CreateProcess (Name : ProcessName; Level : ProcessLevel; ProgramCounter : System.Address) is
      P : Process_Ptr;
   begin
      P := new Process.Process;
      P.ID := LastPID + 1;
      LastPID := LastPID + 1;
      P.Level := Level;
      P.State := Run;
      P.Name  := Name;
      P.PC    := ProgramCounter;
      Queue.InsertEnd (RunQueue, P);
   end CreateProcess;

   procedure Init is
   begin
      loop
         null;
      end loop;
   end Init;

   procedure TaskA is
   begin
      Put (" Task A: ",
         Screen_Width_Range'First,
         Screen_Height_Range'Last);
      loop
         if (TaskASeq = 1) then
            Console.Put ("\", 10, Screen_Height_Range'Last);
            TaskASeq := TaskASeq + 1;
         elsif (TaskASeq = 2) then
            Console.Put ("-", 10, Screen_Height_Range'Last);
            TaskASeq := TaskASeq + 1;
         elsif (TaskASeq = 3) then
            Console.Put ("/", 10, Screen_Height_Range'Last);
            TaskASeq := TaskASeq + 1;
         elsif (TaskASeq = 4) then
            Console.Put ("|", 10, Screen_Height_Range'Last);
            TaskASeq := 1;
         end if;
      end loop;
   end TaskA;

   procedure TaskB is
   begin
--Asm ("CLI");
--Asm ("HLT");
      Put (" Task B: ",
         Screen_Width_Range'First + 10,
         Screen_Height_Range'Last);
      loop
         if (TaskBSeq = 1) then
            Console.Put ("\", 20, Screen_Height_Range'Last);
            TaskBSeq := TaskBSeq + 1;
         elsif (TaskBSeq = 2) then
            Console.Put ("-", 20, Screen_Height_Range'Last);
            TaskBSeq := TaskBSeq + 1;
         elsif (TaskBSeq = 3) then
            Console.Put ("/", 20, Screen_Height_Range'Last);
            TaskBSeq := TaskBSeq + 1;
         elsif (TaskBSeq = 4) then
            Console.Put ("|", 20, Screen_Height_Range'Last);
            TaskBSeq := 1;
         end if;
      end loop;
   end TaskB;

   procedure MainLoop is
      P : Process_Ptr;
      RegisterC : Byte;
   begin
      CPU.Interrupts.Disable;
--      Put_Line ("IRQ8");
      if InitProcess = True then
         Put_Line (" Scheduler called using IRQ8 for first time, starting init process.");
      end if;
--      loop
--  Get current Process
         P := Queue.Current (RunQueue);

--         Put (" Process : ");
--         Put (P.ID);
--         Put (" - " & P.Name);
--         New_Line;

--  Advance through the Queue
         Queue.Next (RunQueue);

         if EndOfQueue = True then
            Queue.Rewind (RunQueue);
         end if;

         EndOfQueue := Queue.EndOfQueue (RunQueue);

--     end loop;

-- Read Status Byte of RTC
      CPU.OutputByte (16#70#, 16#0C#);
      RegisterC := CPU.InputByte (16#71#);

-- Send EOI to PIC
      CPU.OutputByte (16#A0#, 16#20#);
      CPU.OutputByte (16#20#, 16#20#);

      if InitProcess = True then
         Put_Line (" Scheduler switching context to init process.");
         InitProcess := False;
      end if;
      PerformContextSwitch (P);

      loop
         null;
      end loop;

      Asm ("LEAVE");
      Asm ("IRET");
   end MainLoop;

   procedure PerformContextSwitch (P : Process_Ptr) is
   begin

--      if (P.Level = User) then
         ContextSwitch (UserLevelCodeSelector, UserLevelDataSelector, P.PC);

--      end if;
--      if (P.Level = Supervisor) then
--         null;
--      end if;
   end PerformContextSwitch;

end Scheduler;
