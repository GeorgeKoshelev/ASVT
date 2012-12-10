random	db	?
RecievedB	db	0
SendedB		db	0
ColorSelected	db	0

saved	db	0

HandleB	proc
	;cmp		ColorSelected , 1
	;jne		_hb_handle
	;ret
_hb_handle:
	call	Get_chr
	jb		_hb_handle	
	mov		saved , al
	cmp		SendedB , 1
	je		_hb_wasSent
	call	SendB
_hb_wasSent:	
	cmp		saved , 32h
	je		_hb_32h
	cmp		saved , 31h
	je		_hb_31h
_hb_30h:	
	cmp		random , 30h
	je		_hb_draw
	cmp		random , 31h
	je		_hb_lose
	jmp		_hb_win
_hb_31h:
	cmp		random , 30h
	je		_hb_win
	cmp		random , 31h
	je		_hb_draw
	jmp		_hb_lose
_hb_32h:	
	cmp		random , 30h
	je		_hb_lose
	cmp		random , 31h
	je		_hb_win
	jmp		_hb_draw
_hb_draw:
	call	SendB
	jmp		_hb_quit
_hb_win:
	mov		GameStart , 1
	call StartNewGame
	mov		color , 1
	mov		my_color , 0fh
	mov		enemy_color , 0ah
	mov		desk_offset , offset white_desk
	mov		MyMove , 1
	call	PrintMyMove
	jmp		_hb_draw1
_hb_lose:
	mov		GameStart , 1
	call	StartNewGame
	mov		color , 0
	mov		my_color , 0ah
	mov		enemy_color , 0fh
	mov		desk_offset , offset black_desk
	mov		MyMove , 0
	call	PrintEnemyMove
_hb_draw1:	
	call	write_letters
	call	write_numbers
	call	DrawFigures
	mov		ColorSelected , 1
_hb_quit:
	ret
endp	HandleB

SendB proc
	push	ax
	push	dx
	mov		al , 42h
	call	Out_Chr
	call	GetRandom
	call	Out_Chr
	pop		dx
	pop		ax
	ret
endp	SendB

;al - random number
GetRandom	proc
	push	dx
	xor		ax , ax
	mov		al , ticks_count
	mov		dl , 3
	div		dl
	add		ah , 30h
	mov		random , ah
	mov		al , ah
	pop		dx
	ret
endp	GetRandom
