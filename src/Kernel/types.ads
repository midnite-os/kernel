package Types is
   type Nibble is mod 2**4;
   for Nibble'Size use 4;

   type Byte is mod 2**8;
   for Byte'Size use 8;

   type Word is mod 2**16;
   for Word'Size use 16;

   type TwentyBits is mod 2**20;
   for TwentyBits'Size use 20;

   type Double is mod 2**32;
   for Double'Size use 32;
end Types;
