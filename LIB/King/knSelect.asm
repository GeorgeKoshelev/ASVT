KingSelect	proc
	call	KingIsSelectable
	cmp		sucess , 0
	je		_ks_quit
    call	GetCoordinates
	mov		ah , my_color
	mov		al , 4
	call	RecolorCell
	mov		radius , 8
	mov		figure_color , 4
	call	HideCursor
	call	DrawCircle
	call	ShowCursor
	call	ShowKingHints
_ks_quit:
	ret
endp	KingSelect


KingIsSelectable	proc
	mov		sucess , 1
	push	bx
	call	GetKingMoves
	pop		bx
	cmp		KingMustMovesCount , 0
	jne		_is_quit
	cmp		KingMovesCount , 0
 	jne		_is_quit
	mov		sucess , 0
_is_quit:
	ret
endp	KingIsSelectable