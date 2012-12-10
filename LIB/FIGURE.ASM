eror dw ?
x dw ?
y dw ?
x0 dw ?
y0 dw ?
delta dw ?
radius dw ?
figure_color db ?

DrawFigures	proc
	mov	si , desk_offset
	mov	cx , 64
	mov	row , 0
	mov	column , 0
_df_cycle:	
	push	cx
	lodsb
	cmp	al , 0
	je	_df_next
	push	ax
	mov	bh , row
	mov	bl , column
	call	GetCoordinates
	mov	x0 , cx
	add	x0 , 20
	mov	y0 , dx
	add	y0 , 20
	pop	ax
	mov	figure_color , 0fh
	cmp	al , 1
	jne	_df_2
	call	DrawFigure
	jmp	_df_next
_df_2:
	cmp	al , 2
	jne	_df_3
	call	DrawFigure
	mov	figure_color , 04h
	call	DrawOkr
	jmp	_df_next
_df_3:
	mov	figure_color , 0ah
	cmp	al , 3
	jne	_df_4
	call	DrawFigure
	jmp	_df_next
_df_4:
	call	DrawFigure
	mov	radius , 8
	mov	figure_color , 04h
	call	DrawOkr
_df_next:	
	pop	cx
	inc	column
	cmp	column , 8
	jne	_df_next1
	mov	column , 0
	inc	row	
_df_next1:
	loop	_df_cycle		
     	ret
endp	DrawFigures

DrawOkr	proc
	call	HideCursor
	mov		radius , 8		
	call	DrawCircle
	mov		radius , 14
	call	ShowCursor
	ret
endp	DrawOkr

;params : x0 , y0 - center
DrawFigure	proc
	mov	radius , 14
_draw:
	call 	DrawCircle
	dec	radius
	cmp	radius , 0
	jne	_draw
	ret
endp	DrawFigure

Plot proc
	xor	bh , bh
        mov 	Ah, 0Ch             
        mov 	al, figure_color    
        int 	10h	                 
        ret
Plot endp
 
drawCircle proc
        mov x, 0
        mov ax, radius
        mov y, ax
        mov delta, 2
        mov ax, 2
        mov dx, 0
        imul y
        sub delta, ax
        mov eror, 0
        jmp ccicle
finally: ret
ccicle:
        mov ax, y
        cmp ax, 0
        jl  finally
        mov cx, x0
        add cx, x
        mov dx, y0
        add dx, y
        call Plot
        mov cx, x0
        add cx, x
        mov dx, y0
        sub dx, y
        call Plot
        mov cx, x0
        sub cx, x
        mov dx, y0
        add dx, y
        call Plot
        mov cx, x0
        sub cx, x
        mov dx, y0
        sub dx, y
        call Plot
        mov ax, delta
        mov eror, ax
        mov ax, y
        add eror, ax
        mov ax, eror
        mov dx, 0
        mov bx, 2
        imul bx
        sub ax, 1
        mov eror, ax
        cmp delta, 0
        jg sstep
        je sstep
        cmp eror, 0
        jg  sstep
        inc x
        mov ax, 2
        mov dx, 0
        imul x
        add ax, 1
        add delta, ax
        jmp ccicle
sstep:
        mov ax, delta
        sub ax, x
        mov bx, 2
        mov dx, 0
        imul bx
        sub ax, 1
        mov eror, ax
        cmp delta, 0
        jg tstep
        cmp eror, 0
        jg tstep
        inc x
        mov ax, x
        sub ax, y
        mov bx, 2
        mov dx, 0
        imul bx
        add delta, ax
        dec y
        jmp ccicle
tstep:
        dec y
        mov ax, 2
        mov dx, 0
        imul y
        mov bx, 1
        sub bx, ax
        add delta, bx
        jmp ccicle
drawCircle endp