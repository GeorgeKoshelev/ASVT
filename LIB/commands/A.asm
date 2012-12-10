HandleA		proc
	mov		disconnect_timer , 0
	cmp		SendedB , 1
	je		_ha_quit
	call	SendB
	mov		SendedB , 1
_ha_quit:	
	ret
endp	HandleA