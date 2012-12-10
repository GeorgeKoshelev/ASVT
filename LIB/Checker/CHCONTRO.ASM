isRightMove	db	0
MoveIndex	db	0

EnemiesDestroyed	db	0

;bl - column , bh - row , si - pointer to collection ,  cx - count
CheckIsMoveRight	proc
	mov		MoveIndex , 0 
	mov		isRightMove , 1
_cimr_loop:                
	lodsw
	cmp		ax , bx
	je		_cimr_quit
	inc		MoveIndex
	loop	_cimr_loop
	mov		isRightMove , 0
_cimr_quit:
	ret
endp	CheckIsMoveRight

moveType	db	?	; 0 - near , 1 - long

;row,column
HandleCheckerMove	proc
	mov		bl , column
	mov		bh , row
	push	bx
	cmp		CheckerMustMovesCount , 0
	jne 	_hcm_hard_move
_hcm_usual_move:
	mov		moveType , 0
	xor		cx , cx
	mov		cl , CheckerMovesCount
	mov		si , offset CheckerMoves
	jmp		_hcm_check_move_contains
_hcm_hard_move:
	mov		moveType , 1
	xor 	cx , cx
	mov		cl , CheckerMustMovesCount
	mov		si , offset CheckerMustMoves
_hcm_check_move_contains:
	call	CheckIsMoveRight
	pop		bx
	cmp		isRightMove , 1
	jne		_hcm_quit
	cmp		moveType , 0
	jne		_hcm_long_move
	
	call	SaveMove
	call	CheckIsKing
	call	HideCheckerHints
	call	RightMoveWithoutHack

	jmp		_hcm_print
_hcm_long_move:
	push	bx
	;call	ShowCheckerHints
	
	call	SaveMove
	call	CheckIsKing
	call	DestroyEnemy
	pop		bx
	cmp		last_figure_value , 1
	je		_hcm_still_checker
	cmp		last_figure_value , 3
	je		_hcm_still_checker
	
	
	call	GetKingMoves	
	cmp		KingMustMovesCount , 0
	;je		_hcm_finish_long_move
	je		_hcm_finish_king_long_move
	call	ShowKingHints
	call	ContinueLongMove

	jmp		_hcm_quit
_hcm_still_checker:	

	call	GetCheckerMoves
	cmp		CheckerMustMovesCount , 0
	je		_hcm_finish_long_move
	call	ShowCheckerHints	
	call	ContinueLongMove
	jmp		_hcm_quit
_hcm_finish_king_long_move:	
	call	HideKingHints
	call	FinishLongMove
	jmp		_hcm_print
_hcm_finish_long_move:
	call	HideCheckerHints
	call	FinishLongMove
_hcm_print:	
	push	ax
	mov		al , color
	cmp		al , procedure_color
	pop		ax
	jne		_hcm_quit
	call	Print
_hcm_quit:
	ret
endp	HandleCheckerMove


CheckIsKing	proc
	push	ax
	mov		al , color
	cmp		al , procedure_color
	jne		_enemy_move
_my_move:	
	cmp		bh , 0
	je		_cik_king
	jmp		_cik_quit
_enemy_move:	
	cmp		bh , 7
	je		_cik_king
	jmp		_cik_quit
_cik_king:
	inc		last_figure_value
_cik_quit:	
	pop		ax
	ret
endp	CheckIsKing


move_color	db	0
	
MoveChecker	proc
    push	bx	
	mov		bl , last_figure_column
	mov		bh , last_figure_row
	mov		dl , 0
	push	bx
	call	WriteValueToActiveDesk
	pop		bx
	push	bx
	call	GetCoordinates
	xor		ax , ax
	call	RecolorCell
	pop		bx
	pop		bx
	push	bx
	call	GetCoordinates
	mov		al , move_color
	call	GetFigureColor
	call	RecolorCell
	pop		bx
	push	bx
	mov		dl , last_figure_value
	call	WriteValueToActiveDesk
	pop		bx
	ret
endp	MoveChecker

;bl - column , bh - row
FinishLongMove	proc
	mov		move_color , 0
	call	MoveChecker

	cmp		last_figure_value , 1
	je		_flm_skip
	cmp		last_figure_value , 3
	je		_flm_skip
	
	mov		figure_color , 04h
	call	DrawOkr

_flm_skip:	
	;call	CopyActiveDeskToDesk
	mov		WaitingForResponse , 1
	
	mov		isSelected , 0
	ret
endp	FinishLongMove

;bl - column , bh - row
ContinueLongMove proc
	mov		move_color , 4
	push	bx
	call	MoveChecker
	pop		bx
	mov		last_figure_column , bl
	mov		last_figure_row , bh
	cmp		last_figure_value , 1
	je		_clm_quit
	cmp		last_figure_value , 3
	je		_clm_quit
	
	
	
	;call	GetCoordinates
	mov		figure_color , 04h
	call	DrawOkr
	
_clm_quit:	
	ret
endp	ContinueLongMove

;bx enemy_params
DestroyEnemy	proc
	push	bx
    mov		si , offset CheckerEnemy
	mov		al , 2
	mul		MoveIndex
	add		si , ax
	lodsw
	mov		bx , ax
	push	bx	
    mov		dl , 0
	call	WriteValueToActiveDesk	
	pop		bx
	call	GetCoordinates
	xor		ax , ax
	call	RecolorCell
	pop		bx
	inc		EnemiesDestroyed
	ret
endp	DestroyEnemy

;bl - column , bh - row 
RightMoveWithoutHack	proc
	mov		dl , last_figure_value
	push	bx
	push	bx
    call	WriteValueToActiveDesk
	pop		bx
	call	GetCoordinates
	call	GetFigureColor
	mov		al , 0
	call	RecolorCell
	
	
	cmp		last_figure_value , 1
	je		_rmwh_skip_king
	cmp		last_figure_value , 3
	je		_rmwh_skip_king
	
	mov		figure_color , 04h
	call	DrawOkr
	
_rmwh_skip_king:	
	mov		dl , 0

	mov		bl , figure_column
	mov		bh , figure_row	
	push	bx
    call	WriteValueToActiveDesk
	pop		bx
	call	GetCoordinates
	xor		ax , ax
	call	RecolorCell	
	mov		WaitingForResponse , 1
	pop		bx
	mov		last_figure_column , bl
	mov		last_figure_row , bh
	mov		isSelected , 0
	ret
endp	RightMoveWithoutHack

;figure color in ah
GetFigureColor	proc
	push	ax
	mov		al , color
	cmp		al , procedure_color
	jne		_gfc_enemy_color
	pop		ax
	mov		ah , my_color
	jmp		_gfc_quit
_gfc_enemy_color:
	pop		ax
	mov		ah , enemy_color
_gfc_quit:		
	ret
endp	GetFigureColor
	