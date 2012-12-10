write_letters	proc	near    
	cmp	color , 1
	jne	_wlb
	lea	bx , white_letters
	jmp	_wls
_wlb:
	lea	bx , black_letters
_wls:
	mov	cx , 8
	mov	dl , 2
_loop1:
	push	bx
	mov	ah , 02h
	mov	bh , 0
	mov	dh , 23
	int	10h
	pop	bx
	add	dl , 5
	push	dx
	mov	dl , ds:[bx]
	int	21h
	pop	dx
	inc	bx
	loop	_loop1	
	retn
endp	write_letters

write_numbers	proc	near
	cmp	color , 1
	jne	_wnb
	lea	bx , white_numbers
	jmp	_wns
_wnb:
	lea 	bx , black_numbers
_wns:
	mov	cx , 8
	mov	dl , 41
	mov	dh , 1
_loop2:
	push	bx
	mov	ah , 02h
	mov	bh , 0
	int	10h	
	pop	bx
	add	dh , 3
	push	dx
	mov	dl , ds:[bx]
	int	21h
	pop	dx
	inc	bx
	loop	_loop2
	retn
endp	write_numbers

white_letters	db	'abcdefgh'
black_numbers	db	'12345678'
black_letters	db	'hgfedcba'
white_numbers	db	'87654321'