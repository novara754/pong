[bits 16]
[org 0x7C00]

; Vertical length of each player's paddle.
PADDLE_SIZE equ 5 ; cells

; Entry function (because it's at the beginning)
start:
	call clear_screen

	mov ch, [LEFT_PLAYER_POS]
	mov dl, 0
	call draw_paddle
	mov ch, [RIGHT_PLAYER_POS]
	mov dl, 79
	call draw_paddle
	call draw_ball

	cli
	hlt
	jmp start

; Draw each of the player's paddles, starting at the row
; specified by CH, then moves down PADDLE_SIZE cells to draw
; a white box in each row inbetween.
; The column to draw in is specified by DL.
;
; Clobbers: dh, ax, bh
draw_paddle:
	mov dh, ch
	dec ch
	add dh, PADDLE_SIZE
.loop:
	call move_cursor
	mov al, 0xDB ; box character
	call write_char

	dec dh
	cmp dh, ch
	jne .loop
.end:
	ret

; Draw the ball at the position specified by BALL_X and BALL_Y.
;
; Clobbers: dx, ax, bh
draw_ball:
	mov dh, [BALL_Y]
	mov dl, [BALL_X]
	call move_cursor
	mov al, 0xDB ; box character
	call write_char
	ret

LEFT_PLAYER_POS:  db 0
RIGHT_PLAYER_POS: db 6
BALL_X: db 40
BALL_Y: db 12

%include "io.s"

times 510-($-$$) db 0
dw 0xAA55
