
enemy_name	db	10	dup	(?)
length_name	db	0

packet_name_length	db	0
n		db		0

HandleN		proc
	mov		n , 0
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
	je		_handleN_quit
	mov		packet_name_length , bl
	mov		bx , offset enemy_name
	xor		cx , cx
	mov		cl , packet_name_length
	push	cx
	mov		ah , 03h
	mov		bh , 0
	int		10h
	pop		cx
	push	dx
	push	cx
	mov		ah , 02h
	mov		dh , 2
	mov		dl , 02Ch
	int		10h
	pop		cx
_read_name:
	push	cx
	call	GetSymbol
	mov		cs:[bx] , al
	inc		bx
	cmp		n , 10
	je		_don_t_print
	inc		n
	inc		length_name
	mov		ah , 02h
	mov		dl , al
	int		21h
_don_t_print:	
	pop		cx
	loop	_read_name	
	mov		bh , 0
	mov		ah , 02h
	mov		dl , 3eh
	int		21h
	pop		dx
	int		10h
_handleN_quit:
	ret
endp	HandleN
