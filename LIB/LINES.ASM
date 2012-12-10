;dx - y-offset
;cx - pixels count
;bx - x-offset
;al - color
draw_ver_line	proc	near
	mov	ah , 0ch	
_border_ver:
	push	cx
	mov	cx , bx
	push	bx
	mov	bh , 0 
	int	10h
	pop	bx
       	inc	dx
        pop	cx
	dec	cx 
	jnz	_border_ver
	retn
endp	draw_ver_line


;dx - y-position
;bx - x-position
;cx - lines count
;al - color
draw_hor_line	proc	near
	mov	ah , 0ch
_border_hor:
        push	cx
	mov	cx , bx
	push	bx
	xor	bx , bx
	int	10h
	pop	bx
	inc	bx
	pop	cx
	loop	_border_hor
	retn
draw_hor_line	endp
