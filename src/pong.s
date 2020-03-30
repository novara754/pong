[bits 16]
[org 0x7C00]

start:
	call clear_screen

	cli
	hlt
	jmp start

%include "functions.s"

times 510-($-$$) db 0
dw 0xAA55
