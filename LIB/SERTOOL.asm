Print	proc
	mov		isFree , 0
	push	si
	push	cx
	push	ax
	push	dx
	mov		al , 43h
	call	WriteInOutBuff
	mov		si , offset moves_buff
	xor		cx , cx
	mov		cl , moves_count
	
	;add		cl , cl
	
	xor		ax , ax
	mov		al , cl
	mov		dl , 10
	div		dl
	add		al , 30h
	call	WriteInOutBuff
	xor		ax , ax
	mov		al , cl
	div		dl
	mov		al , ah
	add		al , 30h
	call	WriteInOutBuff
	
	;shl		cl , 1

_print_loop:
	push	cx
	lodsb
	mov		bl , al
	lodsb
	mov		bh , al
	call	CastToDeskSymbols
	mov		al , bl
	call	WriteInOutBuff
	mov		al , bh
	call	WriteInOutBuff	
	pop		cx
	loop	_print_loop
	pop		dx
	pop		ax
	pop		cx
	pop		si
	mov		isFree , 1
	ret
endp	Print

;bx - coordinates in/out
CastToDeskSymbols	proc
	push	dx
	cmp		color , 1
	je		_ctds_white
	add		bh , 31h
	mov		dl , 7
	sub		dl , bl
	mov		bl , 41h
	add		bl , dl
	jmp		_ctds_quit
_ctds_white:	
	add		bl , 41h
	mov		dl , 7
	sub		dl , bh
	mov		bh , 31h
	add		bh , dl
_ctds_quit:	
	pop		dx
	ret
endp	CastToDeskSymbols