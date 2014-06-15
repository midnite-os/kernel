package body Device.Timer.RTC is

-- FrequencyDivisor must be between 2 and 15
   procedure EnablePeriodicInterrupt (FrequencyDivisor : Byte) is -- range 3 .. 15) is
      Previous : Byte;
      Current  : Byte;
   begin

      CPU.OutputByte (16#70#, 16#8B#);				-- select register B, and disable NMI
      Previous := CPU.InputByte (16#71#);			-- read the current value of register B
      CPU.OutputByte (16#70#, 16#8B#);				-- set the index again (a read will reset the index to register D)
      Current := Previous or 16#40#;
      CPU.OutputByte (16#71#, Current);				-- write the previous value ORed with 0x40. This turns on bit 6 of register B

--  This code is not necessary as we are using Ada's range feature
--      FrequencyDivisor := FrequencyDivisor & 16#F#;		-- rate must be above 2 and not over 15

--  Interrupts should already be disabled.
--      CPU.Interrupts.Disable;

      CPU.OutputByte (16#70#, 16#8A#);				-- set index to register A, disable NMI
      Previous := CPU.InputByte (16#71#);			-- get initial value of register A
      CPU.OutputByte (16#70#, 16#8A#);				-- reset index to A
      Current := (Previous and 16#F0#) or FrequencyDivisor;
      CPU.OutputByte (16#71#, Current);	-- write only our rate to A. Note, rate is the bottom 4 bits.

--  It is not our job to re-enable Interrupts, it could cause problems.
--      CPU.Interrupts.Enable;
   end EnablePeriodicInterrupt;
end Device.Timer.RTC;
