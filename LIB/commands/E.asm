e_recieved 	db	0

GameOver	db	0

HandleE	proc
	cmp		black_count , 0
	je		_handlee_cont
	cmp		white_count , 0
	je		_handlee_cont
	
	
	jmp		_handleE_quit
_handlee_cont:	
	inc		GameCount
	cmp		GameCount , 2
	jne		_handle_e_skip
	mov		GameOver , 1	
_handle_e_skip:	
	mov		e_recieved , 1
	
_handleE_quit:
	ret
endp	HandleE

SendE	proc
	push	ax
	mov		al , 45h
	call	Out_chr
	pop		ax
	ret
endp	SendE

ChangeSide	proc
	mov		x_off , 1
	mov		y_off , 1
	call	print_desk
	mov		x_off , 1
	mov		y_off , 1
	call	print_desk
	mov		black_count , 12
	mov		white_count , 12
	cmp		color , 0
	je		_cs_0
	mov		color , 0
	mov		my_color , 0ah
	mov		enemy_color , 0fh
	mov		desk_offset , offset black_desk
	mov		MyMove , 0
	call	PrintEnemyMove
	jmp		_cs_o_quit
_cs_0:	
	mov		color , 1
	mov		my_color , 0fh
	mov		enemy_color , 0ah
	mov		desk_offset , offset white_desk
	mov		MyMove , 1
	call	PrintMyMove
_cs_o_quit:	
	call	DrawFigures
	call	write_letters
	call	write_numbers
	mov		WaitingForResponse , 0
	ret
endp	ChangeSide