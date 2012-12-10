white_desk	db	0,3,0,3,0,3,0,3,3,0,3,0,3,0,3,0,0,3,0,3,0,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0
white_desk_dump	db	0,3,0,3,0,3,0,3,3,0,3,0,3,0,3,0,0,3,0,3,0,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0

black_desk	db	0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,3,0,3,0,3,0,0,3,0,3,0,3,0,3,3,0,3,0,3,0,3,0
black_desk_dump	db	0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,3,0,3,0,3,0,0,3,0,3,0,3,0,3,3,0,3,0,3,0,3,0

				

;black_desk	db		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; black_desk	db	0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,1,0,
				; 0,0,0,0,0,3,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0
				
; white_desk	db	0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,3,0,0,0,0,0,
				; 0,1,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0			
				
;black_desk	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;black_desk_dump	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				
;white_desk	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0			
;white_desk_dump	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0			
				
; black_desk	db	0,0,0,0,0,0,0,0,
				; 0,0,3,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,0,0,0,
				; 0,0,0,0,0,1,0,0,
				; 0,0,0,0,0,0,0,0

active_desk	db	64	dup(?)

desk_offset	dw	?

MyMove	db	?

isSelected	db	0

moves_buff	dw	100 dup (?)
moves_count	db	0

figure_row	db	?
figure_column	db	?
figure_value	db	?

last_figure_row 	db	?
last_figure_column 	db	?
last_figure_value  	db	?

black_count		db		?
white_count		db		?

WaitingForResponse	db	?

GameFinished	db		0
GameCount	db	0

;bx - param to save
SaveMove	proc
	push	bx
	push	dx
	xor		dx , dx
	add		dl , moves_count
	add		dl , dl
	add		dx , offset moves_buff
	xchg	dx , bx	
	mov		cs:[bx] , dx
	inc		moves_count	
	pop		dx
	pop		bx
	ret
endp	SaveMove
                       
CancelAllActions	proc
	cmp		isSelected , 0
	je		_cal_quit
	cmp		chints_show , 1
	je		_caa_hide_checker_hints
	cmp		khints_show , 1
	je		_caa_hide_king_hints
	jmp		_caa_skip
_caa_hide_king_hints:
	call	HideKingHints
	jmp		_caa_skip
_caa_hide_checker_hints:
	call	HideCheckerHints
_caa_skip:	
	mov		bl , last_figure_column
	mov		bh , last_figure_row
	call	GetCoordinates
	xor	ax , ax
	call	RecolorCell
	call	DrawFigures
	mov	isSelected , 0
	mov	moves_count , 0
_cal_quit:
	ret
endp	CancelAllActions


;row , column
HandleCell	proc
	cmp		isSelected , 1
	je		_hcell_move
	push	ax
	mov		al , color
	mov		procedure_color , al
	pop		ax

	push	bx
	mov		bl , column
	mov		bh , row
	call	CheckSelectLegal
	pop		bx
	cmp		legal , 1
	je		_hcell_skip
	mov		sucess , 0
	jmp		_hcell_quit
_hcell_skip:	
	call	HandleSelect
	ret
_hcell_move:
	call	HandleMove
_hcell_quit:
	ret
endp	HandleCell


cell_value	db	?

procedure_color	db	0

;row,column,procedure_color
HandleSelect	proc near
	push	ax
	mov		al , color
	cmp		al , procedure_color
	pop		ax
	jne		_hs_1
	cmp		MyMove , 1
	je		_hs_1
	retn
_hs_1:	
	mov		sucess , 1
	mov		moves_count , 0	
	mov		EnemiesDestroyed , 0
	call	CopyDeskToActiveDesk
	mov		bl , column
	mov		bh , row
	call	GetElementFromBoard
	cmp		al , 0
	je		_quit_sh_bad
	mov		figure_value , al
	mov		last_figure_value , al	
	cmp		procedure_color , 1
	jne		_hs_black
_hs_white:
	cmp		al , 3
	je		_quit_sh_bad
	cmp		al , 4
	je		_quit_sh_bad
	push	bx
	cmp		al , 1
	jne 	_hs_white1	
	call	CheckerSelect
	jmp		_hs_continue
_hs_white1:
	call	KingSelect
	jmp		_hs_continue
_hs_black:
	cmp		al , 1
	je		_quit_sh_bad
	cmp		al , 2
	je		_quit_sh_bad
	push	bx
	cmp		al , 3
	jne		_hs_black1	
	call	CheckerSelect
	jmp		_hs_continue
_hs_black1:	
	call	KingSelect
_hs_continue:
	pop		bx
	cmp		sucess , 0 
	je		_quit_sh
	mov		isSelected , 1
	mov		figure_row , bh
	mov		figure_column , bl
	mov		last_figure_row , bh
	mov		last_figure_column , bl
	call	SaveMove
	jmp		_quit_sh
_quit_sh_bad:
	mov		sucess , 0
_quit_sh:
	retn
endp	HandleSelect

sucess	db	1

Alert	proc
	push	ax
	push	dx
	mov		ah , 02h
	mov		dl , 21h
	int		21h
	pop		dx
	pop		ax
	ret
endp	Alert

	
;row , column , last_figure_row , last_figure_column
HandleMove	proc
	cmp	last_figure_value , 1
	je	_hm_checker
	cmp	last_figure_value , 3
	je	_hm_checker
_hw_king:
	call	HandleKingMove
	jmp	_hm_quit
_hm_checker:
	call	HandleCheckerMove
_hm_quit:
	ret
endp	HandleMove


;cx - x-off
;dx - y-off
;al - cell color 
;ah - figure color
RecolorCell	proc
	push	ax
	push	cx
	push	dx


	push	ax
	push	cx
	push	dx
	inc	dx
	inc	cx
	mov	bx , cx
	mov	cx , 40
	push	ax
	call	HideCursor
	pop	ax
_rc_loop:
	push	bx	
	push	cx
	mov	cx , 40
	call	draw_hor_line
	inc	dx
	pop	cx
	pop	bx
	loop	_rc_loop
	pop	dx
	pop	cx
	pop	ax
	mov	figure_color , ah
	mov	x0 , cx
	add	x0 , 20
	mov	y0 , dx
	add	y0 , 20
	call	DrawFigure
	call	ShowCursor
	
	pop	dx
	pop	cx
	pop	ax
	
	ret
endp	RecolorCell

