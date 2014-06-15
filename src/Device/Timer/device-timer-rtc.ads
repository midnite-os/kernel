with Types; use Types;
with CPU; use CPU;

--  Frequency = 32.768 kHz = 32768 Hz = 2^15 Hz
--  Frequency = 32768 >> (FrequencyDivisor - 1)
--  FrequencyDivisor is between 3 and 15
--  This gives us Frequencies of

--  Divisor | Frequency
-- ---------+-----------
--     3    |  8192 Hz
--     4    |  4096 Hz
--     5    |  2048 Hz
--     6    |  1024 Hz
--     7    |   512 Hz
--     8    |   256 Hz
--     9    |   128 Hz
--    10    |    64 Hz
--    11    |    32 Hz
--    12    |    16 Hz
--    13    |     8 Hz
--    14    |     4 Hz
--    15    |     2 Hz

package Device.Timer.RTC is

--  Possibly move these functions into a package called Device.RTC and
--  make this simply a Timer that depends on Device.RTC

--   function GetTimeCurrentSecond return TimeSecond;
--   function GetTimeCurrentMinute return TimeMinute;
--   function GetTimeCurrentHour return TimeHour;
--   function GetTimeCurrentDayOfWeek return DateDayOfWeek;
--   function GetTimeCurrentDayOfMonth return DateDayOfMonth;
--   function GetTimeCurrentMonth return DateMonth;
--   function GetTimeCurrentYear return DateYear;

--   procedure SetTimeCurrentSecond;
--   procedure SetTimeCurrentMinute;
--   procedure SetTimeCurrentHour;
--   procedure SetTimeCurrentDayOfWeek;
--   procedure SetTimeCurrentDayOfMonth;
--   procedure SetTimeCurrentMonth;
--   procedure SetTimeCurrentYear;

--   procedure EnableAlarmInterrupt;
--   procedure EnableUpdateEndedInterrupt;
--   procedure EnableSquareWaveInterrupt;

   procedure EnablePeriodicInterrupt (FrequencyDivisor : Byte); -- range 3 .. 15);
end Device.Timer.RTC;
