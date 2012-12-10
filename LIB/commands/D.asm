HandleD		proc
	call	GetSymbol
	sub		al , 30h
	cmp		WaitingForResponse , 1
	jne		_hd_quit	
	cmp		al , 0
	je		_hd_good
	call	CancelAllActions
	mov		bl , last_figure_column
	mov		bh , last_figure_row
	call	GetCoordinates
	xor		ax , ax
	call	RecolorCell
	call	DrawFigures
	jmp		_hd_quit
_hd_good:		
	call	CopyActiveDeskToDesk
	mov		WaitingForResponse , 0
	call	PrintEnemyMove
	mov		MyMove , 0
	call	CheckIfEnemyWon
_hd_quit:	
	ret
endp	HandleD


CheckIfEnemyWon proc
	cmp		color , 1
	je		_ciew_white
	cmp		white_count , 0
	jne		_ciew_quit
	call	PrintEnemyWin
	call	SendE
	mov		GameFinished , 1
	mov		e_recieved , 1
	jmp		_ciew_white
_ciew_white:
	cmp		black_count , 0
	jne		_ciew_quit
	call	PrintEnemyWin
	call	SendE
	mov		GameFinished , 1
	mov		e_recieved , 1
_ciew_quit:	
	ret
endp	CheckIfEnemyWon