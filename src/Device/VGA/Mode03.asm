STRUC VGAREG
   PORT   resw  1
   INDEX  resb  1
   VALUE  resb  1
ENDSTRUC

MODE03H:
    ISTRUC VGAREG
        at PORT,  dw 03C2H
        at INDEX, db 00H
        at VALUE, db 67H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03DAH
        at INDEX, db 00H
        at VALUE, db 00H
    IEND

    ISTRUC VGAREG
        at PORT,  dw 03C4H
        at INDEX, db 00H
        at VALUE, db 03H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C4H
        at INDEX, db 01H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C4H
        at INDEX, db 02H
        at VALUE, db 03H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C4H
        at INDEX, db 03H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C4H
        at INDEX, db 04H
        at VALUE, db 02H
    IEND

    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 00H
        at VALUE, db 5FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 01H
        at VALUE, db 4FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 02H
        at VALUE, db 50H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 03H
        at VALUE, db 82H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 04H
        at VALUE, db 55H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 05H
        at VALUE, db 81H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 06H
        at VALUE, db 0BFH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 07H
        at VALUE, db 1FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 08H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 09H
        at VALUE, db 4FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0AH
        at VALUE, db 0EH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0BH
        at VALUE, db 0FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0CH
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0DH
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0EH
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 0FH
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 10H
        at VALUE, db 9CH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 11H
        at VALUE, db 0EH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 12H
        at VALUE, db 8FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 13H
        at VALUE, db 28H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 14H
        at VALUE, db 01H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 15H
        at VALUE, db 96H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 16H
        at VALUE, db 0B9H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 17H
        at VALUE, db 0A3H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03D4H
        at INDEX, db 18H
        at VALUE, db 0FFH
    IEND

    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 00H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 01H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 02H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 03H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 04H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 05H
        at VALUE, db 10H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 06H
        at VALUE, db 0EH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 07H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03CEH
        at INDEX, db 08H
        at VALUE, db 0FFH
    IEND

; Color Palette
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 00H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 01H
        at VALUE, db 01H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 02H
        at VALUE, db 02H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 03H
        at VALUE, db 03H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 04H
        at VALUE, db 04H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 05H
        at VALUE, db 05H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 06H
        at VALUE, db 06H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 07H
        at VALUE, db 07H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 08H
        at VALUE, db 08H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 09H
        at VALUE, db 09H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0AH
        at VALUE, db 0AH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0BH
        at VALUE, db 0BH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0CH
        at VALUE, db 0CH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0DH
        at VALUE, db 0DH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0EH
        at VALUE, db 0EH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 0FH
        at VALUE, db 0FH
    IEND
; Color Palette

    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 10H
        at VALUE, db 0CH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 11H
        at VALUE, db 00H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 12H
        at VALUE, db 0FH
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 13H
        at VALUE, db 08H
    IEND
    ISTRUC VGAREG
        at PORT,  dw 03C0H
        at INDEX, db 14H
        at VALUE, db 00H
    IEND

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
