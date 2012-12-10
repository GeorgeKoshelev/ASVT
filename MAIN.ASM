.286
.model tiny
.code
org 100h
start:
	mov		cx , offset out_buff
	mov		head_buff , cx
	mov		tail_buff , cx
	call	set_mode
	call	MouseInit
	push	es
	call	SetTimerHandler
	call	Ser_Ini
	pop		es
	call	print_full_desk
	call	draw_exit_button
	
	
	mov		black_count , 12
	mov		white_count , 12
	mov		GameFinished , 0
	
	
	
	
	; mov		color , 1
	; mov		my_color , 0fh
	; mov		enemy_color , 0ah
	; mov		desk_offset , offset white_desk
	
	; mov		color , 0
	; mov		my_color , 0ah
	; mov		enemy_color , 0fh
	; mov		desk_offset , offset black_desk
	
	; mov		ColorSelected , 1
	
	; call	write_letters
	; call	write_numbers
	; call	DrawFigures
	
	; mov		black_count , 1
	; mov		white_count , 1
	
    jmp _main
      include lib/desk.asm
      include lib/video.asm
      include lib/buttons.asm
      include lib/letters.asm
      include lib/lines.asm
      include lib/figure.asm
      include lib/mouse.asm
      include lib/deskcont.asm
      include lib/king/knmoves.asm
      include lib/king/knselect.asm
      include lib/king/kncontr.asm
      include lib/checker/chcontro.asm
      include lib/checker/chselect.asm
      include lib/checker/chmoves.asm
      include lib/deskcopy.asm
      include lib/utils.asm
	  include lib/serial.asm
	  include lib/timer.asm
	  include lib/outbuff.asm
	  include lib/commands/common.asm
	  include lib/commands/A.asm
	  include lib/commands/B.asm
	  include lib/commands/C.asm
	  include lib/commands/D.asm
	  include lib/commands/E.asm
	  include lib/commands/N.asm
	  include lib/commands/G.asm
	  include lib/sertool.asm
	  include lib/bselect.asm
	  include lib/statuses.asm
	  include lib/checker/ch.asm
	  include lib/king/kh.asm
      color		db	?
      my_color 	db	?
      enemy_color	db	?
	  flag		db	0
	  gameEnd	db	0
	  IWin		db	0
_main:
	cmp		gameEnd , 1
	jne		_main_cont
	jmp		_quit
_main_cont:	
	mov		isFree , 0 
	xor		cx , cx
	mov		cl , OutCount
	cmp		cl , 0
	je		_end_write
 _write:
	push	cx
	call	ReadFromOutBuff
	call	Out_Chr
	pop		cx
	loop	_write
 _end_write:	
	 mov		isFree , 1
 _read:
	 call	Get_Chr
	 jb		_end_read
	 call	HandleCommands
	 jmp	_read
 _end_read:
	cmp		click , 1
	jne		_c2	
	cmp		e_recieved , 1
	jne		_c_f
	call	ChangeSide
	mov		e_recieved , 0
	jmp		_c3
_c_f:	
	call	CheckMouseCoordinates	
	mov		click , 0
_c2:
	cmp		cancel , 1
	jne		_c3
	call	CancelAllActions
	mov		cancel , 0
_c3:
	cmp		exit , 1
	je 		_quit
_c4:
	mov 	ah, 1
	int 	16h	
	jz 		_main
	xor		ah, ah
	int 	16h
	cmp 	ah, 1
	jne		_c5
	call	StartNewGame
	mov		SendedB , 0
	jmp		_main
_c5:	
	cmp		ah , 0fh
	je		_c4
	cmp		push_was , 0
	jne		_c5_push
	push	ax
	mov		ah , 02h
	mov		bh , 0
	mov		dl , 02ch
	mov		dh , 20
	int		10h
	mov		row_curr , 20
	mov		column_curr	, 02ch
	mov		push_was , 1
	mov		dh , 20
	call	ClearPreviousMessage
	pop		ax
_c5_push:	
	call	ProcessPush
	jmp		_c4
_quit:
	call	DisableTimerHandler
	call	Ser_Rst
	call	DisableHandler
;max length of message 36 symbols
ret

push_was	db	0

row_curr	db	0
column_curr	db	0
input_buff	db	100	dup	(20h)
input_length	db	0

ProcessPush	proc
	cmp		ah , 1ch
	jne		_read_pp
	call	SengG
	jmp		_pp_quit
_read_pp:	
	cmp		ah , 0eh
	je		_pp_backspace
	cmp		input_length , 99
	jne		_read_cont
	ret
_read_cont:	
	cmp		column_curr , 4fh
	jne		_pp_row_not_inc
	mov		column_curr , 02ch
	inc		row_curr
_pp_row_not_inc:	
	inc		column_curr
	mov		ah , 02h
	mov		bh , 0
	mov		dh  , row_curr
	mov		dl  , column_curr
	int		10h
	
	mov		bx , offset input_buff
	xor		cx , cx
	mov		cl , input_length
	add		bx , cx
	mov		cs:[bx] , al
	inc		input_length
	mov		ah , 09h
	mov		bh , 0
	mov		bl , my_color
	mov		cx , 1
	int		10h
	
	jmp		_pp_quit
_pp_backspace:
	cmp		input_length , 0
	je		_pp_quit
	mov		bx , offset input_buff
	xor		cx , cx
	mov		cl , input_length
	dec		input_length
	add		bx , cx
	mov		cs:[bx] , byte ptr 20h
	cmp		column_curr , 02ch
	jne		_pp_row_not_decr
	mov		column_curr , 050h
	dec		row_curr 
_pp_row_not_decr:
	mov		ah , 02h
	mov		bh , 0
	mov		dh , row_curr
	mov		dl , column_curr
	int		10h
	dec		column_curr
	mov		ah , 09h
	mov		al , 20h
	mov		bh , 0
	mov		cx , 1
	int		10h
_pp_quit:	
	ret
endp	ProcessPush


StartNewGame	proc
	call	CopyDumpDeskToDeskWhite
	call	CopyDumpDeskToDeskBlack
	mov		GameOver , 0
	mov		e_recieved , 0
	mov		black_count , 12
	mov		white_count , 12
	mov		isSelected , 0
	mov		ColorSelected , 0
	mov		x_off , 1
	mov		y_off , 1
	call	print_desk
	mov		x_off , 1
	mov		y_off , 1
	call	print_desk
	ret
endp	StartNewGame

end start

