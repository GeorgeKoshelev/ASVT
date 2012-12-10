MustSelectArray		dw	12	dup(?)
MustSelectCount		db	0

j		db		0
legal	db		0

;bx : bl -column , bh - row
CheckSelectLegal	proc
	push	bx
	mov		MustSelectCount , 0
	mov		j , 0
	mov		legal , 1
	call	SelectLegal
	pop		bx
	cmp		MustSelectCount , 0
	je		_csl_quit
	call	CheckElementContainsInArray
_csl_quit:	
	ret
endp	CheckSelectLegal	

;al - value of figure from board
SelectLegal	proc
	push	si
	push	ax
	push	cx
	mov		cx , 64
_wsl_loop:	
	push	cx
	call	JToBx
	call	GetElementFromBoard
	cmp		al , 0
	je		_wsl_skip
	cmp		procedure_color , 1
	je		_wsl_white
	cmp		al , 1
	je		_wsl_skip
	cmp		al , 2
	je		_wsl_skip
	cmp		al , 4
	je		_wsl_king
	jmp		_wsl_checker
_wsl_white:	
	cmp		al , 3
	je		_wsl_skip
	cmp		al , 4
	je		_wsl_skip
	cmp		al , 2
	je		_wsl_king
_wsl_checker:	
	call	GetCheckerMoves
	cmp		CheckerMustMovesCount , 0
	je		_wsl_skip
	call	WriteMustSelectElement
	jmp		_wsl_skip
_wsl_king:
	call	GetKingMoves
	cmp		KingMustMovesCount , 0
	je		_wsl_skip
	call	WriteMustSelectElement
_wsl_skip:	
	inc		j
	pop		cx
	loop	_wsl_loop
_wsl_quit:	
	pop		cx
	pop		ax
	pop		si
	ret
endp	SelectLegal

JToBx	proc
	push	dx
	push	ax
	mov		dl , 8
	xor		ax , ax
	mov		al , j
	div		dl
	mov		bl , ah
	mov		bh , al
	pop		ax
	pop		dx
	ret
endp	JToBx


;bx - value to write
WriteMustSelectElement	proc
	push	di
	push	ax
	mov		di , offset MustSelectArray
	push	cx
	xor		cx , cx
	mov		cl , MustSelectCount
	add		di , cx
	add		di , cx
	pop		cx
	mov		ax , bx
	stosw
	inc		MustSelectCount
	pop		ax
	pop		di
	ret
endp	WriteMustSelectElement

;bx - element to check
CheckElementContainsInArray		proc
	push	cx
	push	si
	xor		cx , cx
	mov		cl , MustSelectCount
	cmp		cl , 0
	je		_cecia_bad
	mov		si , offset MustSelectArray
_cecia_loop:
	lodsw
	cmp		ax , bx
	je		_cecia_quit
	loop	_cecia_loop
_cecia_bad:	
	mov		legal , 0
_cecia_quit:	
	pop		si
	pop		cx
	ret
endp	CheckElementContainsInArray	