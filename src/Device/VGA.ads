package Device.VGA is
   procedure Init;
   procedure SetMode;

   pragma Import (C, Init, "vga_init");
   pragma Import (C, SetMode, "setmode");
end Device.VGA;
