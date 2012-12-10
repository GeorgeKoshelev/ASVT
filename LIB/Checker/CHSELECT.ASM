CheckerSelect	proc
	push	ax
	call	CheckerIsSelectable
	cmp		sucess , 0
	je		_cs_quit
_cs_select:
	call	GetCoordinates
	mov		al , 4
	call	GetFigureColor
	call	RecolorCell
	push	bx
	call	ShowCheckerHints
	pop		bx
_cs_quit:
	pop		ax
	ret
endp	CheckerSelect

CheckerIsSelectable	proc
	mov		sucess , 1
	call	GetCheckerMoves
	cmp		CheckerMustMovesCount , 0 
	jne		_cis_quit
	cmp		CheckerMovesCount , 0
	jne		_cis_quit
	mov		sucess , 0
_cis_quit:
	ret
endp	CheckerIsSelectable	