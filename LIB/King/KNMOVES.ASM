KingMoves		dw	20	dup	(0)
KingMovesCount		db	0
KingMustMoves		dw	20	dup	(0)
KingMustMovesCount	db	0
KingEnemy               dw	20	dup	(0)
KingEnemyCount		db 	0
Iteration		db	0
KingMustMovesAfterMove  db	20	dup	(0)
KingMustMovesAfterMoveCount db 	0

KingMovesShifts	db	-1 , 1 , 1 , 1 , 1 , -1 , -1 ,-1

KingShift	dw	?
KingShift1	dw	?

;bl-column , bh - row
GetKingMoves	proc
	mov		KingMovesCount , 0
	mov		KingMustMovesCount , 0
	mov		KingEnemyCount , 0
	mov		KingMustMovesAfterMoveCount , 0
	mov		Iteration , 0
	mov		cx , 4
	mov		si , offset KingMovesShifts
_gkm_loop:
    push	cx
    lodsw
	mov		KingShift , ax
	push	bx
    call	ProceedDirection	
	pop		bx
    inc		Iteration
	pop		cx
	loop	_gkm_loop
	ret
endp	GetKingMoves

EnemyCoordinates	dw	?

;bl - column , bh - row , Iteration , KingShift
ProceedDirection	proc
_pfd_before_enemy:
	call	CheckBounds
	cmp		bounds_ok , 1
	jne		_pfd_quit
	mov		dx , KingShift
	add		bl , dl
	add		bh , dh
	call	GetElementFromBoard
	cmp		al , 0
	jne		_pfd_check_color
	call	AddMove
	jmp		_pfd_before_enemy
_pfd_check_color:
	call	CheckElementColor
	cmp		isMine , 1
	je		_pfd_quit
	mov		EnemyCoordinates , bx
_pfd_after_enemy:
	call	CheckBounds
	cmp	bounds_ok , 1
	jne	_pfd_quit
	mov	dx , KingShift
	add	bl , dl
	add	bh , dh
	call	GetElementFromBoard
	cmp	al , 0
	jne	_pfd_quit
	call	MoveAfterMove
	push	di
	push	ax
	mov	di , offset KingMustMovesAfterMove
	push	cx
	xor	cx , cx
	mov	cl , KingMustMovesCount
	add	di , cx
	pop	cx
	mov	al , NeedMoveAfter
	stosb
	pop	ax
	pop	di
	call	AddMustMove
	jmp	_pfd_after_enemy				
_pfd_quit:
	ret
endp	ProceedDirection

bounds_ok	db	1

NeedMoveAfter	db	0
my_start_coordinates	dw	?

ProceedDirectionAfter	proc
_pda_beforeEnemy:
	call	CheckBounds
	cmp	bounds_ok , 1
	jne	_pda_quit
	mov	dx , KingShift1
	add	bl , dl       
	add	bh , dh
	cmp	bx , EnemyCoordinates
	je	_pda_beforeEnemy
	push	ax
	mov	al , last_figure_column
	mov	ah , last_figure_row
	mov	my_start_coordinates , ax
	pop	ax
	cmp	bx , my_start_coordinates
	je	_pda_beforeEnemy	
	call	GetElementFromBoard
	cmp	al , 0
	je	_pda_beforeEnemy	
	call	CheckElementColor
	cmp	isMine , 1
	je	_pda_quit
	call	CheckBounds
	cmp	bounds_ok , 1
	jne	_pda_quit
	mov	dx , KingShift1
	add	bl , dl
	add	bh , dh
	call	GetElementFromBoard
	cmp	al , 0
	jne	_pda_quit
	inc	NeedMoveAfter
	inc	KingMustMovesAfterMoveCount
_pda_quit:	
	ret
endp	ProceedDirectionAfter



MoveAfterMove	proc
	push	si
	push	bx 
	push	cx
	push	di
	push	ax
	xor	ax , ax
	mov	al , Iteration
	push	ax
	mov	si , offset KingMovesShifts
	mov	cx , 4
	mov	Iteration , 0
	mov	NeedMoveAfter , 0
_mam_loop:
	push	cx 
	lodsw
	mov	KingShift1 , ax
	push	bx
	call	ProceedDirectionAfter
	pop	bx
	pop	cx
	loop	_mam_loop
_mam_quit:
	pop	ax
	mov	Iteration , al
	pop	ax
	pop	di
	pop	cx
	pop	bx
	pop	si
	ret
endp	MoveAfterMove

;bx - coordinates
CheckBounds	proc
	mov	bounds_ok , 1
	cmp	Iteration , 0
	je	_cb_0
	cmp	Iteration , 1
	je	_cb_1
	cmp	Iteration , 2
	je	_cb_2
	jmp	_cb_3
_cb_0:
	cmp	bl , 0
	je	_cb_bad
	cmp	bh , 7
	je	_cb_bad
        jmp	_cb_quit
_cb_1:
	cmp	bl , 7
	je	_cb_bad
	cmp	bh , 7
	je	_cb_bad
	jmp	_cb_quit
_cb_2:
	cmp	bl , 7
	je	_cb_bad
	cmp	bh , 0
	je	_cb_bad
	jmp	_cb_quit
_cb_3:
	cmp	bl , 0
	je	_cb_bad
	cmp	bh , 0
	je	_cb_bad
	jmp	_cb_quit
_cb_bad:
	mov	bounds_ok , 0
_cb_quit:
	ret
endp	CheckBounds	

isMine	db	0

CheckElementColor	proc
    mov		isMine , 1
    cmp		procedure_color , 1
	je		_cec_white
	cmp		al , 3
	je		_cec_quit
	cmp		al , 4
	je		_cec_quit
	mov		isMine , 0
	jmp		_cec_quit
_cec_white:
	cmp		al , 1
	je		_cec_quit
	cmp		al , 2
	je		_cec_quit
	mov		isMine , 0	
_cec_quit:
	ret
endp	CheckElementColor
                         
;bx - coordinates
AddMove	proc
    mov		di , offset KingMoves
	mov		al , 2
	mul		KingMovesCount
	add		di , ax
	mov		ax , bx
	stosw
	inc		KingMovesCount
	ret
endp	AddMove

;bx - coordinates
AddMustMove	proc
    mov		di , offset KingMustMoves
	mov		al , 2
	mul		KingMustMovesCount
	push	ax
	add		di , ax
	mov		ax , bx
	stosw
	pop		ax
	mov		di , offset KingEnemy
	add		di , ax
	mov		ax , EnemyCoordinates
	stosw
	inc		KingMustMovesCount
	inc		KingEnemyCount
    ret
endp	AddMustMove