HandleCommands	proc
	mov		disconnect_timer , 0
	cmp		al , 41h
	jne		_hc_B
	call	HandleA
	jmp		_hc_quit
_hc_B:	
	cmp		al , 42h
	jne		_hc_C
	call	HandleB
	jmp		_hc_quit
_hc_C:
	cmp		ColorSelected  , 1
	jne		_hc_E
	cmp		al , 43h
	jne		_hc_D
	call	HandleC
	jmp		_hc_quit
 _hc_D:
	cmp		al , 44h
	jne		_hc_E
	call	HandleD
	jmp		_hc_quit
 _hc_E:
	cmp		al , 45h
;	jne		_hc_N
	jne		_hc_G
	call	HandleE
	jmp		_hc_quit
;_hc_N:
;	cmp		al , 4Eh
;	jne		_hc_G
;	call	HandleN
;	jmp		_hc_quit
_hc_G:
	cmp		al , 47h
	jne		_hc_quit
	call	HandleG
_hc_quit:	
	ret
endp	HandleCommands