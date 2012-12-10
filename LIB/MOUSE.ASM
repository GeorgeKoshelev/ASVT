click	db  0
exit	db  0
cancel	db  0

x_coord	dw  ?
y_coord	dw	?

row		db	?
column	db	?

;ax - offset
GetCellNumber	proc
	push	bx
	mov		bl , 40
	div		bl	
	pop		bx
	ret
endp	GetCellNumber

CheckMouseCoordinates	proc
	push	ax
	cmp		x_coord , 320
	jg		_cmc_quit
	cmp		y_coord	, 320
	jg		_cmc_buttons
	mov		ax , x_coord
	call	GetCellNumber
	mov		column , al
	mov		ax , y_coord
	call	GetCellNumber
	mov		row , al	
	call	HandleCell
	jmp		_cmc_quit
_cmc_buttons:
	cmp		x_coord , 48
	jg		_cmc_quit
	cmp		y_coord , 335
	jl		_cmc_quit	
	mov		exit , 1
_cmc_quit:
	pop		ax
	ret
endp	CheckMouseCoordinates

MouseInit	proc
	call 	ExitIfNoMouseAvailable
	call	ShowCursor
	call	SetHandler
	ret
endp	MouseInit


ExitIfNoMouseAvailable	proc
	push	ax
	mov		ax , 0
	int 	33h	
	cmp		ax , 0
	jne		_einma_exit
	mov		ah , 4ch
	int		21h
_einma_exit:
	pop		ax
	ret
endp	ExitIfNoMouseAvailable

ShowCursor	proc
	push	ax
	mov		ax , 1
	int		33h
	pop		ax
	ret
endp	ShowCursor

HideCursor	proc
	push 	ax
    mov		ax , 2
	int		33h
	pop		ax
	ret
endp	HideCursor

SetHandler	proc
	push	ax
	push	cx
	push	dx
    mov	ax , 0ch
    mov	cx , 18
	mov	dx , offset MouseHandler
	int	33h
	pop		dx
	pop		cx
	pop		ax
	ret
endp	SetHandler

DisableHandler	proc
	push	ax
	push	cx
	push	dx
	push	es
	mov		ah , 0ch
	xor		cx , cx
	xor		dx , dx
	push	0
	pop		es
	int		33h
	pop		es
	pop		dx
	pop		cx
	pop		ax
	ret
endp	DisableHandler

MouseHandler:
	cmp		ax , 2
	je		_left
	mov		cs:cancel , 1
	retf
_left:
	mov		cs:click , 1
	mov		cs:x_coord , cx
	mov		cs:y_coord , dx
	retf