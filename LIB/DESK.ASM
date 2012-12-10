;bx - offset to colors
print_row proc near
	mov	cx , 40
_pd0:
	push	cx	
_pd1:	
    mov		cx , 4
_pd2:
	push	cx
	mov		al , ds:[bx]
	push	bx
	mov		bx , x_off
	mov		dx , y_off
	mov		cx , 40
	call	draw_hor_line
	add		x_off , 40
	pop		bx
	mov		al , ds:[bx+1]
	push	bx
	mov		bx , x_off
	mov		dx , y_off
	mov		cx , 40
	call	draw_hor_line	
	pop		bx
	add		x_off , 40
	pop		cx
	loop	_pd2
	pop		cx
	add		y_off , 1
	mov		x_off , 1
	loop	_pd0
	retn
endp	print_row


white_offsets	db 0ffh , 0
black_offsets	db 0 , 0ffh 
x_off	dw 	1
y_off	dw	1

print_desk proc	near
	mov	cx , 4
_pdl:
	push	cx
	lea	bx , white_offsets
    call	print_row
    lea	bx , black_offsets
	call	print_row
_pdq:
	pop	cx
	loop	_pdl
	retn
endp	print_desk

print_full_desk	proc	near
	call	draw_border
	call	print_desk
	retn
endp	print_full_desk

draw_border	proc	near
	xor	dx , dx
	xor	bx , bx
	mov	al , line_color
	mov	cx , 322
	call	draw_hor_line
	mov	cx , 322
	xor	dx , dx
	xor	bx , bx
	call	draw_ver_line
	mov	cx , 322
	xor	dx , dx
	mov	bx , 321
	call	draw_ver_line
	xor	bx , bx
	mov	dx , 321
	mov	cx , 322
	call	draw_hor_line        
	retn
draw_border	endp

line_color 	db 	0AAh