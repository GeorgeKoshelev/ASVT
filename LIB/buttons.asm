exit_string	db	'Exit'

draw_exit_button	proc	near
	mov	al , button_border_color
	mov	cx , 29
	mov	dx , 335
	mov	bx , 0
	call	draw_ver_line
	mov	al , button_border_color
	mov	cx , 48
	mov	dx , 335
	mov	bx , 0
	call	draw_hor_line
	mov	cx , 4
	lea	bx , exit_string
	mov	dl , 0
	call	print_string
	mov	al , button_border_color
	mov	cx , 29
	mov	dx , 335
	mov	bx , 48
	call	draw_ver_line        
	retn
endp	draw_exit_button

;bx - string offset
;cx - string length
;dl - start pointer
print_string	proc	near
_ps1:
	push	bx
	mov	ah , 02h
	mov	bh , 0
	mov	dh , 24
	inc	dl
	int	10h
	pop	bx
	mov	ah , 09h
	mov	al , byte ptr ds:bx
	inc	bx
	push	bx
	push	cx
	mov	bh , 0
	mov	bl , font_color
	mov	cx , 1
	int	10h
	pop	cx
	pop	bx
	loop	_ps1	
	retn
endp	print_string

button_border_color	db	0AAh
font_color	db	0AAh