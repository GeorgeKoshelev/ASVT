out_buff	db	1024	dup (0)
head_buff	dw	0
tail_buff	dw	0
isFree		db	1
OutCount	db	0

; al - parameter to write
WriteInOutBuff		proc
	push	bx
	cmp		cs:head_buff , 1024
	jne		_wiob_skip
	mov		head_buff , 0
_wiob_skip:
	mov		bx , offset cs:out_buff
	add		bx , cs:head_buff
	mov		cs:[bx] , al
	inc		cs:head_buff
	inc		cs:OutCount
	pop		bx
	ret
endp	WriteInOutBuff

;al - read value
ReadFromOutBuff		proc
	push	si
	cmp		tail_buff , 1024
	jne		_rfob_skip
	mov		tail_buff , 0
_rfob_skip:	
	mov		si , offset out_buff
	add		si , tail_buff
	lodsb
	inc		tail_buff
	dec		OutCount
	pop		si
	ret
endp	ReadFromOutBuff	