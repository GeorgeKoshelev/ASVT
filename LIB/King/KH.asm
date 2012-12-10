khints_show	db	0

ShowKingHints	proc
	push	ax
	push	bx
	push	cx
	push	si
	mov		al , color
	cmp		al , procedure_color
	jne		_skh_quit
	mov		cx , 0
	cmp		KingMustMovesCount , 0
	jne		_skh_must
	cmp		KingMovesCount , 0
	jne		_skh_moves
	jmp		_skh_quit
_skh_must:
	mov		si , offset KingMustMoves
	mov		cl , KingMustMovesCount
	jmp		_skh_draw
_skh_moves:	
	mov		si , offset KingMoves
	mov		cl , KingMovesCount
_skh_draw:
	push	cx
	lodsw
	mov		bx , ax
	call	GetCoordinates
	mov		x0 , cx
	mov		y0 , dx
	add		x0 , 20
	add		y0 , 20
	mov		al , my_color
	mov		figure_color , al
	call	DrawOkr
	pop		cx
	loop	_skh_draw
	mov		khints_show , 1
_skh_quit:	
	pop		si
	pop		cx
	pop		bx
	pop		ax
	ret
endp	ShowKingHints

HideKingHints	proc
	push	ax
	push	bx
	push	cx
	push	si
	mov		cx , 0
	cmp		KingMustMovesCount , 0
	jne		_hkh_moves
	cmp		KingMovesCount , 0
	jne		_hkh_moves
	jmp		_hkh_quit
_hkh_must:
	mov		si , offset KingMustMoves
	xor		cx , cx
	mov		cl , KingMustMovesCount
	jmp		_hkh_draw
_hkh_moves:	
	mov		si , offset KingMoves
	xor		cx , cx
	mov		cl , KingMovesCount
_hkh_draw:
	push	cx
	lodsw
	mov		bx , ax
	call	GetCoordinates
	mov		x0 , cx
	mov		y0 , dx
	add		x0 , 20
	add		y0 , 20
	mov		figure_color , 0
	call	DrawOkr
	pop		cx
	loop	_hkh_draw
	mov		khints_show , 0
_hkh_quit:	
	pop		si
	pop		cx
	pop		bx
	pop		ax
	ret
endp	HideKingHints