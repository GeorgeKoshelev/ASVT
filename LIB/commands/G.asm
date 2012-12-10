
right_side		db		0
bottom_side		db		0

packet_chat_length	db	0

HandleG		proc
	mov		dh , 2
	call	ClearPreviousMessage
	call 	GetSymbol
	sub		al , 30h	
	mov		bl , 10
	mul		bl
	xor		bx , bx
	mov		bl , al	
	xor		ax , ax
	call	GetSymbol	
	sub		al , 30h
	add		bl , al
	xor		bh , bh
	cmp		bx , 0
	je		_handleG_quit
	mov		packet_chat_length , bl
	xor		cx , cx
	mov		cl , packet_chat_length
	push	cx
	mov		ah , 03h
	mov		bh , 0
	int		10h
	pop		cx
	push	dx
	push	cx
	mov		ah , 02h
	mov		dh , 2
	mov		bottom_side , dh
	mov		dl , 02Ch
	cmp		length_name , 10
	jg		_more
	add		dl , length_name
	add		dl , 1
	jmp		_han_skip
_more:	
	add		dl , 11
_han_skip:	
	mov		right_side , dl
	pop		cx
_read_chat:
	push	cx
	mov		ah , 02h
	mov		dh , bottom_side
	mov		dl , right_side
	mov		bh , 0
	int		10h
	call	GetSymbol
	cmp		right_side , 4fh
	jne		_dont_coret
	inc		bottom_side
	mov		dh , bottom_side
	mov		right_side , 02bh
_dont_coret:	
	inc		right_side
	mov		ah , 09h
	mov		dl , al
	mov		bh , 0
	mov		bl , enemy_color
	mov		cx , 1
	int		10h
	pop		cx
	loop	_read_chat	
	mov		bh , 0
	pop		dx
	int		10h
_handleG_quit:
	ret
endp	HandleG

;dh - row to start
ClearPreviousMessage	proc
	mov		dl , 02ch
	xor		cx , cx
	mov		cl , 120
_fl:
	push	cx
	mov		ah , 02h
	mov		bh , 0
	int		10h
	push	dx
	mov		ah , 09h
	mov		al , 20h
	mov		bh , 0
	mov		bl , enemy_color
	mov		cx , 1
	int		10h
	pop		dx
	cmp		dl , 4fh
	jne		_cont_fl
	mov		dl , 02bh
	inc		dh
_cont_fl:
	inc		dl
	pop		cx
	loop	_fl
	ret
endp ClearPreviousMessage

NWas	db	0

SengG	proc
	push	si
	push	di
	mov		si , offset input_buff
	;cmp		Nwas , 0
	;jne		_g_send
	;mov		al , 43h
	;call	Out_chr
	;mov		al , 30h
	;call	Out_chr
	;mov		al , 39h
	;call	Out_chr
	;mov		dx , offset input_buff
	;mov		cx , 9
	;mov		NWas , 1
	;jmp		_sendg_loop
_g_send:	
	mov		al , 47h
	call	Out_chr
	mov		al , 39h
	call	Out_chr
	mov		al , 39h
	call	Out_chr
	mov		bx , offset input_buff
	mov		cx , 100
_sendg_loop:
	push	cx
	lodsb
	push	bx
_s_retry:	
	call	Out_chr
	jc		_s_retry
	pop		bx
	mov		cs:[bx] , byte ptr 20h
	inc		bx
	pop		cx
	loop	_sendg_loop	
	pop		di
	pop		si
	mov		input_length , 0
	mov		push_was , 0
	ret
endp	SengG

