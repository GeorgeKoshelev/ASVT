CheckerMoves 		dw 2	dup (0)
CheckerMovesCount	db 0
CheckerMustMoves	dw 4	dup (0)
CheckerMustMovesCount	db 0
CheckerEnemy		dw 4	dup (0)
CheckerEnemyCount	dw 0
CheckerFarShifts 	db	-1 , 1 , 1 ,1 , 1 , -1 , -1 , -1	

;bl - column , bh - row
GetCheckerMoves	proc
	push	bx
	push	bx
	mov		CheckerEnemyCount , 0
	mov		di , offset CheckerMoves
	mov		CheckerMovesCount , 0
	call	GetCheckerNearMoves
	mov		di , offset CheckerMustMoves
	mov		si , offset CheckerFarShifts
	mov		CheckerMustMovesCount , 0
	pop		bx
	call	GetCheckerFarMoves
	pop		bx
	ret
endp	GetCheckerMoves

gcfm_bad	db 0

CheckByColor	proc
	cmp		procedure_color , 0
	jne		_gcfm_white
	cmp		al , 3
	je		_cbc_bad
	cmp		al , 4
	je		_cbc_bad
	jmp		_cbc_ok
_gcfm_white:
	cmp		al , 1
	je		_cbc_bad
	cmp		al , 2
	je		_cbc_bad
	jmp		_cbc_ok
_cbc_bad:
    mov		gcfm_bad , 1
_cbc_ok:
	ret
endp	CheckByColor

shift	dw 	?
enemy_cell	dw	?

GetCheckerFarMoves	proc
	mov	cx , 4
_gcfm_cycle:
	push	cx
	push	bx
	lodsw
	mov		shift , ax
	call	PreventBadMoves
	cmp		gcfm_bad , 1
	je		_gcfm_next
	mov		ax , shift
	add		bl , al
	add		bh , ah
	call	GetElementFromBoard
	cmp		al , 0
	je		_gcfm_next
	call	CheckByColor
	cmp		gcfm_bad , 1
	je		_gcfm_next	
	mov		enemy_cell , bx
	mov		ax , shift
	add		bl , al
	add		bh , ah
	call	GetElementFromBoard
	cmp		al , 0
	jne		_gcfm_next
	mov		ax , bx
	stosw
	push	di
	mov		di , offset CheckerEnemy
	add		di , CheckerEnemyCount
	add		di , CheckerEnemyCount
	mov		ax , enemy_cell
	stosw
	inc		CheckerEnemyCount
	pop		di
	inc		CheckerMustMovesCount
_gcfm_next:
	mov		gcfm_bad , 0
	pop		bx
	pop		cx 
	loop	_gcfm_cycle
_gcfm_quit:
	ret
endp	GetCheckerFarMoves
                  
GetCheckerNearMoves	proc
	push	bx	
	call	RightDirection
	cmp		RightOk , 1
	jne		_gcnm_skip
	call	GetElementFromBoard
	cmp		al , 0
	jne		_gcnm_skip
	mov		ax , bx
	stosw
	inc	CheckerMovesCount
_gcnm_skip:
	pop		bx
	call	LeftDirection
	call	GetElementFromBoard
	cmp	al , 0
	jne	_gcnm_quit
	mov	ax , bx
	stosw
	inc	CheckerMovesCount
_gcnm_quit:
	ret
endp	GetCheckerNearMoves

LeftOk	db	1
LeftDirection	proc
	mov		LeftOk , 1
	push	ax
	mov		al , color
	cmp		al , procedure_color
	jne		_ld_back_direction
	cmp		bh , 0
	je		_ld_bad
	cmp		bl , 0
	je		_ld_bad
	dec	bl
	dec	bh
	jmp		_ld_quit
_ld_back_direction:	
	cmp		bh , 7
	je		_ld_bad
	cmp		bl , 0
	je		_ld_bad
	dec	bl
	inc	bh
	jmp	_ld_quit
_ld_bad:	
	mov		LeftOk , 0
_ld_quit:	
	pop		ax
	ret
endp	LeftDirection

RightOk	db	1
;bx-start coordinates
RightDirection	proc
	mov		RightOk , 1
	push	ax
	mov		al , color
	cmp		al , procedure_color
	jne		_rd_back_direction
	cmp		bh , 0
	je		_rd_bad
	cmp		bl , 7
	je		_rd_bad
	inc	bl
	dec	bh
	jmp		_rd_quit
_rd_back_direction:
	cmp		bh , 7
	je		_rd_bad
	cmp		bl , 7
	je		_rd_bad
	inc	bl
	inc	bh
	jmp		_rd_quit
_rd_bad:	
	mov		RightOk , 0
_rd_quit:	
	pop		ax
	ret
endp	RightDirection

;bl - column , bh - row , cx - iteration
PreventBadMoves	proc
	cmp	cx , 4
	je	_pbm4
	cmp	cx , 3
	je	_pbm3
	cmp	cx , 2
	je	_pbm2
	jmp	_pbm1
_pbm4:
	cmp	bl , 1
	jle	_pbm_bad
	cmp	bh , 6
	jge	_pbm_bad
	jmp	_pbm_quit
_pbm3:
	cmp	bl , 6
	jge	_pbm_bad
	cmp	bh , 6
	jge	_pbm_bad
	jmp	_pbm_quit
_pbm2:
	cmp	bl , 6
	jge	_pbm_bad
	cmp	bh , 1
	jle	_pbm_bad
	jmp	_pbm_quit
_pbm1:
	cmp	bl , 1
	jle	_pbm_bad
	cmp	bh , 1
	jle	_pbm_bad
	jmp	_pbm_quit
_pbm_bad:
	mov	gcfm_bad , 1
_pbm_quit:
	ret
endp	PreventBadMoves
