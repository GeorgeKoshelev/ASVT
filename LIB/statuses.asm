enemy_win_message db	'Enemy won :($' ;length 12
i_win_message	  db	'I Win! :)$'   ;length 9
my_move_message		db	'My move$'	
enemy_move_message	db	'Waiting for enemy move$'
bad_move_message	db	'Error: bad move, my move$'
waiting_move_message	db	'Waiting for reply$'
bad_enemy_move		db	'Error: bad move, en move$'

PrintBadEnemyMove proc
	push	dx
	mov		dx , offset bad_enemy_move
	call	PrintStatus
	pop		dx
	ret
endp		PrintBadEnemyMove

PrintWaiting		proc
	push	dx
	mov		dx , offset waiting_move_message
	call	PrintStatus
	pop		dx
	ret
endp		PrintWaiting

PrintBadMove		proc
	push	dx
	mov		dx , offset bad_move_message
	call	PrintStatus
	pop		dx
	ret
endp		PrintBadMove

PrintEnemyMove		proc
	push	dx
	mov		dx , offset enemy_move_message
	call	PrintStatus
	pop		dx
	ret
endp		PrintEnemyMove

PrintMyMove		proc
	push	dx
	mov		dx , offset my_move_message
	call	PrintStatus
	pop		dx
	ret
endp		PrintMyMove

PrintEnemyWin		proc
	push	dx
	mov		dx , offset enemy_win_message
	call	PrintStatus
	pop		dx
	ret
endp		PrintEnemyWin

PrintIwin	proc
	push	dx
	mov		dx , offset i_win_message
	call	PrintStatus
	pop		dx
	ret
endp	PrintIwin

Clean		proc
	push	ax
	push	bx
	push	dx
	push	cx	
	mov		ah , 02h
	mov		bh , 0
	mov		dh , 18h
	mov		dl , 27h
	int		10h	
	mov		cx , 24
	mov		ah , 02h
	mov		dl , 20h
_clean_loop:
	int		21h
	loop	_clean_loop
	pop		cx
	pop		dx
	pop		bx
	pop		ax
	ret
endp		Clean

;dx - offset of message To Print
PrintStatus	proc
	push	ax
	push	bx
	push	dx
	push	cx

	call	Clean
	push	dx
	mov		ah , 02h
	mov		bh , 0
	mov		dh , 18h
	mov		dl , 27h
	int		10h	
	pop		dx
	mov		ah , 09h
	int		21h
		
	pop		cx
	pop		dx
	pop		bx
	pop		ax
	ret
endp	PrintStatus
