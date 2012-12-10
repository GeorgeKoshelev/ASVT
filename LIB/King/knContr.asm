HandleKingMove	proc
	mov		bl , column
	mov		bh , row
	push	bx
	cmp		KingMustMovesCount , 0
	jne		_hkn_hard_move
_hkn_usual_move:
	mov		moveType , 0
	xor		cx , cx
	mov		cl , KingMovesCount
	mov		si , offset KingMoves
	jmp		_hkn_check_move_contains
_hkn_hard_move:
	mov		moveType , 1
	xor		cx , cx
	mov		cl , KingMustMovesCount
	mov		si , offset KingMustMoves
_hkn_check_move_contains:
	call	KingCheckIsMoveRight
	pop		bx
	cmp		isRightMove , 1
	jne		_hkm_quit
	call	SaveMove
	cmp		moveType , 0
	jne		_hkm_long_move	
	call	MoveKing
	call	HideKingHints
	jmp		_hkm_print
_hkm_long_move:
	call	KingDestroyEnemy
	call	DeleteKingPreviousPlace
	call	GetKingMoves
    cmp		KingMustMovesCount , 0
	je		_hkm_finish_long_move
	call	ShowKingHints
	call	KingContinueLongMove
	jmp		_hkm_quit
_hkm_finish_long_move:
	call	HideKingHints
	call	MoveKing
_hkm_print:
	push	ax
	mov		al , color
	cmp		al , procedure_color
	pop		ax
	jne		_hkm_quit
	call	Print
_hkm_quit:
	ret
endp	HandleKingMove

DeleteKingPreviousPlace proc
	push	bx
	mov		bl , last_figure_column
	mov		bh , last_figure_row
	mov		dl , 0
	call	WriteValueToActiveDesk
	pop		bx
	ret
endp	DeleteKingPreviousPlace


KingContinueLongMove proc
	mov		move_color , 4
	push	bx
	call	MoveChecker
	
	mov		figure_color , 04h
	call	DrawOkr
	
	pop		bx
	mov		last_figure_column , bl
	mov		last_figure_row , bh	
	ret
endp	KingContinueLongMove


; KingFinishLongMove	proc
	; mov		move_color , 0
	; call	MoveChecker
	
	; mov		figure_color , 04h
	; call	DrawOkr	
	
	; ;call	CopyActiveDeskToDesk
	
	; mov		WaitingForResponse , 1
	
	; mov		isSelected , 0
	; ret
; endp	KingFinishLongMove

;bl - column , bh - row , si - pointer to collection ,  cx - count
KingCheckIsMoveRight	proc
	push	bx
	mov		MoveIndex , 0 
	mov		isRightMove , 1
_kcimr_loop:                
	lodsw
	cmp		ax , bx
	je		_kcimr_check_move_after_move
	inc		MoveIndex
	loop	_kcimr_loop
	mov		isRightMove , 0
	jmp		_kcimr_quit
_kcimr_check_move_after_move:
    cmp		KingMustMovesAfterMoveCount , 0
	je		_kcimr_quit
	push	si
	mov		si , offset KingMustMovesAfterMove
	push	cx
	xor		cx , cx
	mov		cl , MoveIndex
	add		si , cx
	pop		cx
	lodsb
	cmp		al , 0
	jne		_kcimr_good
	mov 	isRightMove , 0
_kcimr_good:
	pop		si	
_kcimr_quit:     
	pop		bx
	ret
endp	KingCheckIsMoveRight

MoveKing		proc
	mov		move_color , 0
	call	MoveChecker
	
	mov		figure_color , 04h
	call	DrawOkr	
	
	mov		WaitingForResponse , 1
	
	mov		isSelected , 0
	
	ret
endp	MoveKing


; KingRightMoveWithoutHack	proc
	; ;mov		dl , last_figure_value
	; ;push	bx
	; ;call	WriteValueToActiveDesk
	; ;call	GetCoordinates
	; ;mov		al , 0
	; ;call	GetColor
	; ;pop		bx	
	; ;mov		dl , 0
	; ;mov		bl , figure_column
	; ;mov		bh , figure_row
	; ;push	bx
	; ;call	WriteValueToActiveDesk
	; ;pop		bx
	; ;call	GetCoordinates
	; ;xor		ax , ax
	; ;call	RecolorCell
	; ;call	CopyActiveDeskToDesk
	
	; mov		move_color , 0
	; call	MoveChecker
	
	; mov		figure_color , 04h
	; call	DrawOkr	
	
	; mov		WaitingForResponse , 1
	
	; mov		isSelected , 0
	; ;call	DrawFigures
	; ret
; endp	KingRightMoveWithoutHack

;bx enemy_params
KingDestroyEnemy	proc
	push	bx
    mov		si , offset KingEnemy
	mov		al , 2
	mul		MoveIndex
	add		si , ax
	lodsw	
	mov		bx , ax
	push	bx	
	inc		EnemiesDestroyed
    mov		dl , 0
	call	WriteValueToActiveDesk	
	pop		bx
	call	GetCoordinates
	xor		ax , ax
	call	RecolorCell
	pop		bx
	ret
endp	KingDestroyEnemy

help	proc
    push	bx
	push	ax
	push	dx
	mov		ah , 02h
	mov		dl , 30h
	add		dl , bl
	int		21h
	mov		dl , 30h
	add		dl , bh
	int		21h
	pop		dx
	pop		ax
	pop		bx
	ret
endp	help
