ticks_count    db 0
disconnect_timer db	0

SetTimerHandler	proc
	push	es
	mov		ax , 3508h
	int		21h
	mov 	word ptr [old_int_08h] , bx
	mov 	word ptr [old_int_08h+2] , es
	mov		ax , 2508h
	mov		dx , offset timer_vector
	int		21h
	pop		es
	ret
endp	SetTimerHandler

DisableTimerHandler	proc
	push	es
	mov		bx , word ptr [old_int_08h]
	mov		cx , word ptr [old_int_08h+2]
	push	cx
	pop		es
	mov		ax , 2508h
	int		21h
	pop		es
	ret
endp	DisableTimerHandler

GameStart	db	0

timer_vector:
	push		ax
	cmp		GameStart , 0
	je		_t_main
	inc		disconnect_timer
	cmp		disconnect_timer , 90
	jne		_t_main
	mov		gameEnd , 1
	jmp		_t_alert_next_time
_t_main:
	cmp		ticks_count , 18
	jne		_t_con
	cmp		cs:isFree , 1
	jne		_t_alert_next_time
	mov		al , 41h
	call		WriteInOutBuff
	mov		ticks_count , 0
_t_con:	
	inc		ticks_count
_t_alert_next_time:
	pop		ax
    db 0eah          
    old_int_08h	dd	?	