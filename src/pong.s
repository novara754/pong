[bits 16]
[org 0x7C00]

; Vertical length of each player's paddle.
PADDLE_SIZE equ 5 ; cells
SCREEN_WIDTH equ 80
SCREEN_HEIGHT equ 25

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

	call handle_input
	call update_paddles
	call update_ball

	; Wait for 166ms
	mov ah, 0x86
	mov cx, 0x0000 ; high word of wait time
	mov dx, 0x9870 ; low word of wait time
	int 0x15

	; cli
	; hlt
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

; Checks if a key on the keyboard has been pressed.
; If a key was pressed it will be read from the keyboard buffer, and checked for relevancy.
; Relevancy is defined as follows: The keys 'W', 'S', 'I', and 'K' are relevant, as these are
; used to control the two paddles, all other keys are irrelevant.
;
; If a relevant key was pressed, its bit in KEYS_PRESSED will be set.
;
; Clobbers: ax
handle_input:
	mov byte [KEYS_PRESSED], 0
.loop:
	mov ah, 0x01
	int 0x16
	jnz .read_key
	ret
.read_key:
	mov ah, 0x00
	int 0x16
	cmp al, 'w'
	je .set_w
	cmp al, 's'
	je .set_s
	cmp al, 'i'
	je .set_i
	cmp al, 'k'
	je .set_k
	jmp .loop
.set_w:
	or byte [KEYS_PRESSED], (1 << 0)
	jmp .loop
.set_s:
	or byte [KEYS_PRESSED], (1 << 1)
	jmp .loop
.set_i:
	or byte [KEYS_PRESSED], (1 << 2)
	jmp .loop
.set_k:
	or byte [KEYS_PRESSED], (1 << 3)
	jmp .loop

; Updates the position of each paddle based on the key states in KEYS_PRESSED.
; W = left paddle up
; S = left paddle up
; I = right paddle up
; K = right paddle up
;
; If W and S or I and K are pressed at the same time the paddle will not move at all
;
; Clobbers: ah
;
update_paddles:
	mov ah, [KEYS_PRESSED]
	and ah, (1 << 0)
	jnz .left_up
.after_left_up:
	mov ah, [KEYS_PRESSED]
	and ah, (1 << 1)
	jnz .left_down
.after_left_down:
	mov ah, [KEYS_PRESSED]
	and ah, (1 << 2)
	jnz .right_up
.after_right_up:
	mov ah, [KEYS_PRESSED]
	and ah, (1 << 3)
	jnz .right_down
.after_right_down:
	ret
.left_up:
	cmp byte [LEFT_PLAYER_POS], 0
	je .after_left_up
	dec byte [LEFT_PLAYER_POS]
	jmp .after_left_up
.left_down:
	cmp byte [LEFT_PLAYER_POS], (SCREEN_HEIGHT - PADDLE_SIZE - 1)
	je .after_left_down
	inc byte [LEFT_PLAYER_POS]
	jmp .after_left_down
.right_up:
	cmp byte [RIGHT_PLAYER_POS], 0
	je .after_right_up
	dec byte [RIGHT_PLAYER_POS]
	jmp .after_right_up
.right_down:
	cmp byte [RIGHT_PLAYER_POS], (SCREEN_HEIGHT - PADDLE_SIZE - 1)
	je .after_right_down
	inc byte [RIGHT_PLAYER_POS]
	jmp .after_right_down

; Updates the ball's position based on BALL_DX and BALL_DY.
; It does this by adding the value in those variables to its position BALL_X and BALL_Y.
; Additionally this function performs collision checks with the top and bottom wall, as well
; as with each paddle.
;
; Clobbers: ah
update_ball:
	cmp byte [BALL_Y], 0
	je .flip_dy
	cmp byte [BALL_Y], (SCREEN_HEIGHT - 1)
	je .flip_dy
.after_flip_dy:
	mov ah, [BALL_DX]
	add [BALL_X], ah
	mov ah, [BALL_DY]
	add [BALL_Y], ah
	cmp byte [BALL_X], 1
	je .check_left_paddle
	cmp byte [BALL_X], (SCREEN_WIDTH - 2)
	je .check_right_paddle
.end:
	ret
.flip_dy:
	neg byte [BALL_DY]
	jmp .after_flip_dy
.check_left_paddle:
	mov ah, [LEFT_PLAYER_POS]
	cmp [BALL_Y], ah
	jl .end
	mov ah, [LEFT_PLAYER_POS]
	add ah, PADDLE_SIZE
	cmp [BALL_Y], ah
	jg .end
	neg byte [BALL_DX]
	ret
.check_right_paddle:
	mov ah, [LEFT_PLAYER_POS]
	cmp [BALL_Y], ah
	jl .end
	mov ah, [RIGHT_PLAYER_POS]
	add ah, PADDLE_SIZE
	cmp [BALL_Y], ah
	jg .end
	neg byte [BALL_DX]
	ret

LEFT_PLAYER_POS:  db 0
RIGHT_PLAYER_POS: db 6

BALL_X: db 40
BALL_Y: db 12
BALL_DY: db 1
BALL_DX: db 1

; Each bit represents the state of a key.
; 0bxxxx_xxxx
;        |||`- W key
;        ||`-- S key
;        |`--- I key
;        `---- K key
; The 4 highest bits are unused.
KEYS_PRESSED: db 0

%include "io.s"

times 510-($-$$) db 0
dw 0xAA55
