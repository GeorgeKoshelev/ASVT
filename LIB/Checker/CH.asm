chints_show	db	0

ShowCheckerHints	proc
	push	ax
	push	bx
	push	cx
	push	si
	mov		al , color
	cmp		al , procedure_color
	jne		_scs_quit
	mov		cx , 0
	cmp		CheckerMustMovesCount , 0
	jne		_scs_must
	cmp		CheckerMovesCount , 0
	jne		_scs_moves
	jmp		_scs_quit
_scs_must:
	mov		si , offset CheckerMustMoves
	mov		cl , CheckerMustMovesCount
	jmp		_scs_draw
_scs_moves:	
	mov		si , offset CheckerMoves
	mov		cl , CheckerMovesCount
_scs_draw:
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
	loop	_scs_draw
	mov		chints_show , 1
_scs_quit:	
	pop		si
	pop		cx
	pop		bx
	pop		ax
	ret
endp	ShowCheckerHints

HideCheckerHints	proc
	push	ax
	push	bx
	push	cx
	push	si
	mov		cx , 0
	cmp		CheckerMustMovesCount , 0
	jne		_hch_moves
	cmp		CheckerMovesCount , 0
	jne		_hch_moves
	jmp		_hch_quit
_hch_must:
	mov		si , offset CheckerMustMoves
	xor		cx , cx
	mov		cl , CheckerMustMovesCount
	jmp		_hch_draw
_hch_moves:	
	mov		si , offset CheckerMoves
	xor		cx , cx
	mov		cl , CheckerMovesCount
_hch_draw:
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
	loop	_hch_draw
	mov		chints_show , 0
_hch_quit:	
	pop		si
	pop		cx
	pop		bx
	pop		ax
	ret
endp	HideCheckerHints