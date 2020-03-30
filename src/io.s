; Removes all content from the screen and sets every cells color to
; Also moves the cursor to the top-left cell.
;
; Clobbers: ax, bh, cx, dx
clear_screen:
	; 0x06 is the scroll function (current screen gets scrolled out of view)
	mov ah, 0x06
	; 0x00 tells it to completely scroll everything out of view
	mov al, 0x00
	; Set background color to black and text color to light grey
	mov bh, 0x0F
	; Store the coordinates of the top-left cell and the bottom-right
	; cells in CX and DX respectively.
	mov cx, 0x0000
	mov dx, 0x184F
	int 0x10

	; Now just move the cursor back to the top-left cell.
	mov dx, 0x0000
	call move_cursor

	ret


; Moves the cursor to the specified coordinates
; in DX (DH=Row, DL=Column)
;
; Clobbers: ah, bh
move_cursor:
	; Move cursor function
	mov ah, 0x02
	; Page 0
	mov bh, 0x00
	int 0x10
	ret

; Write a character at the current cursor position,
; the character to write is specified by the AL register.
;
; Clobbers: ah, bh
write_char:
	; 0x0E is the function to print a character
	; from AL
	mov ah, 0x0E
	; Page 0
	mov bh, 0x00
	int 0x10
	ret
