;bh=row,bl=column , out al - element value
GetElementFromBoard	proc
	push	bx
	xor		ax , ax
	mov		al , 8
	mul		bh
	add		al , bl
	mov		bx , offset active_desk  
	add		bx , ax
	mov		al , byte ptr cs:[bx]
	pop		bx
	ret
endp	GetElementFromBoard


;bl - column , bh- row , dl - value to write
WriteValueToActiveDesk	proc
    mov	al , 8
	mul	bh
	add	al , bl
	mov	bx , offset active_desk
	xor	ah , ah
	add	bx , ax
	mov	cs:[bx] , dl
	ret
endp	WriteValueToActiveDesk

;bh = row, bl = column , out cx , dx
GetCoordinates	proc
	mov	al , 40
	mul	bl
	mov	cx , ax
	mov	al , 40
	mul	bh
	mov	dx , ax
	ret
endp	GetCoordinates
