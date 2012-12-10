HandleC		proc
	mov 	commandIsGood , 1
	push	ax
	push	bx
	push	cx
	push	dx	
	cmp		MyMove , 0
	jne		_hc1_quit
	xor		ax , ax
	call 	GetSymbol
	sub		al , 30h
	mov		bl , 10
	mul		bl
	xor		bx , bx
	mov		bx , ax
	xor		ax , ax
	call	GetSymbol	
	sub		al , 30h
	add		bx , ax
	cmp		bx , 0
	je		_enemy_win	
	mov		cx , bx	
	
	
	
	;shl		cl , 1
	
	call	CheckEnemyCommand
	jmp		_hc_result
_enemy_win:	
	call	CheckEnemyWin
	cmp		GameFinished , 1
	je		_hc1_quit
_hc_result:
	cmp		commandIsGood , 1
	je		_good_command	
_bad_command:
	call	BadCommand
	mov		MyMove , 0
	call	PrintBadEnemyMove
	jmp		_hc1_quit
_good_command:
	call	GoodCommand
	call	CopyActiveDeskToDesk
	mov		MyMove , 1
	call	PrintMyMove
	call	CheckIAmWin
	jmp		_hc1_quit
_hc1_quit:
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret
endp		HandleC

CheckIAmWin	proc
	push	ax
	cmp		color , 1
	je		_aiw_white
	cmp		black_count , 0
	je		_aiw_win
	jmp		_aiw_quit
_aiw_white:	
	cmp		white_count , 0
	je		_aiw_win
	jmp		_aiw_quit
_aiw_win:
	call	PrintIWin
	mov		al , 43h
	call	Out_chr
	mov		al , 30h
	call	Out_chr
	mov		al , 30h
	call	Out_chr
	mov		GameFinished , 1
	call	SendE
_aiw_quit:	
	pop		ax
	ret
endp	CheckIAmWin



commandIsGood	db	1

CheckEnemyCommand	proc
	dec		cx
	cmp		WaitingForResponse , 0
	jne		_cec_bad	
	push	cx
	cmp		color , 1
	je		_change_to_black
	mov		procedure_color , 1
	jmp		_change_end
_change_to_black:
	mov		procedure_color , 0
_change_end	:
	mov		commandIsGood , 1
	call	GetSymbol
	mov		bl , al
	call	GetSymbol
	mov		bh , al	
	call	ToMyCoordinates
	mov		row , bh
	mov		column , bl	
	call	HandleSelect
	pop		cx
	cmp		sucess , 0
	je		_cec_bad
_check:
	push	cx
	call	GetSymbol
	mov		bl , al
	call	GetSymbol
	mov		bh , al
	call	ToMyCoordinates
	
	mov		row , bh
	mov		column , bl
	call	HandleMove
	pop		cx
	cmp		isRightMove , 1
	jne		_cec_bad
	loop	_check
	cmp		last_figure_value , 1
	je		_cec_checker
	cmp		last_figure_value , 3
	je		_cec_checker
	cmp		KingMustMovesCount , 0
	jne		_cec_bad
	jmp		_cec_quit
_cec_checker:	
	cmp		CheckerMustMovesCount , 0
	jne		_cec_bad
	jmp		_cecq_quit
_cec_bad:
	call	CancelAllActions
	add		cx , cx
_cec_bad_loop:
	push	cx
	call	GetSymbol
	pop		cx
	loop	_cec_bad_loop
	mov		commandIsGood , 0
_cecq_quit:
	ret
endp	CheckEnemyCommand

;bx - bl - column , bh - row in enemyes coordinates
;bx - column and row in my coordinates
ToMyCoordinates		proc near
	cmp		procedure_color , 0
	je		_tmc_black
	sub		bh , 31h
	sub		bl , 41h
	push	dx
	mov		dl , 7
	sub		dl , bl
	mov		bl , dl
	pop		dx
	jmp		_tmc_quit
_tmc_black:
	sub		bl , 41h
	sub		bh , 31h
	push	dx
	mov		dl , 7
	sub		dl , bh
	mov		bh , dl
	pop		dx
_tmc_quit:	
	retn
endp	ToMyCoordinates


CheckEnemyWin	proc
	cmp		procedure_color , 1
	je		_cew_white
	cmp		black_count , 0
	jne		_cew_bad
	call	PrintEnemyWin
	;mov		SendedB , 0
	call	SendE
	mov		GameFinished , 1
	mov		e_recieved , 1
	call	ChangeSide
	jmp		_cew_quit					;TODO: add fish variant
_cew_white:	
	cmp		white_count , 0
	jne		_cew_bad
	call	PrintEnemyWin
	call	SendE
	;mov		SendedB , 0
	mov		GameFinished , 1
	mov		e_recieved , 1
	call	ChangeSide
	jmp		_cew_quit
_cew_bad:
	mov		commandIsGood , 0
_cew_quit:	
	ret
endp	CheckEnemyWin



GetSymbol	proc
_gs_1:
	call	Get_Chr
	jb		_gs_1
	ret
endp	GetSymbol

BadCommand proc
	push	ax
	mov		isFree , 0
	mov		al , 44h
	call	WriteInOutBuff
	mov		al , 31h
	call	WriteInOutBuff
	mov		isFree , 1
	pop		ax
	ret
endp	BadCommand

GoodCommand proc
	push	ax
	mov		isFree , 0
	mov		al , 44h
	call	WriteInOutBuff
	mov		al , 30h
	call	WriteInOutBuff
	mov		isFree , 1
	pop		ax
	ret
endp	GoodCommand