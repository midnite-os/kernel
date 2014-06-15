-- with Scheduler.Process; use Scheduler.Process;
-- with Scheduler.Queue; use Scheduler.Queue;
with Process; use Process;
with Queue; use Queue;

with Types; use Types;
with System; use System;

with CPU.ProtectedMode; use CPU.ProtectedMode;
with CPU.Interrupts; use CPU.Interrupts;

with Console; use Console;

package Scheduler is

   subtype Milliseconds is Integer range 1 .. 1000;

-- We need to create a Linked List of all processes in the Run state
   subtype ProcessQueue is Queue.Object;

   RunQueue         : Queue.Object;

-- We also need a list of all processes in the Wait state
   WaitQueue	    : ProcessQueue;

   Quantum          : Milliseconds;

   UserLevelCodeSelector : Word;
   UserLevelDataSelector : Word;
 
   EndOfQueue : Boolean := False;
   LastPID    : Integer := 0;

   procedure CreateProcess (Name : ProcessName; Level : ProcessLevel; ProgramCounter : System.Address);
   procedure Initialise (CodeSelector : Word; DataSelector : Word; TSS : TaskStateSegment);
   procedure Init;
   procedure TaskA;
   procedure TaskB;
   procedure PerformContextSwitch (P : Process_Ptr);
   procedure MainLoop;

   procedure ContextSwitch (CodeSelector : Word; DataSelector : Word; Process : System.Address);

   pragma Import (C, ContextSwitch, "contextswitch");
end Scheduler;
