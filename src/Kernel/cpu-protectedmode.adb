package body CPU.ProtectedMode is
   procedure CreateTSS is
   begin
--      TSS.cs := 16#0B#;
--      TSS.ss0 := 16#10#;
--      TSS.esp0 := 16#2ffff#;
--      TSS.ds := 16#13#;
--      TSS.es := 16#13#;
--      TSS.fs := 16#13#;
--      TSS.gs := 16#13#;

      TSS.cs := 16#1B#;
      TSS.ss0 := 16#10#;
      TSS.esp0 := 16#2ffff#;
      TSS.ss := 16#20#;
      TSS.esp := 16#2efff#;
      TSS.ds := 16#23#;
      TSS.es := 16#23#;
      TSS.fs := 16#23#;
      TSS.gs := 16#23#;
      null;
   end CreateTSS;

   procedure Enable is
      CR0 : Double;
   begin
      CR0 := ReadCR0;
      CR0 := CR0 or 2;
      WriteCR0 (CR0);
   end Enable;

end CPU.ProtectedMode;
