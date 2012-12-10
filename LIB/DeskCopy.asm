CopyActiveDeskToDesk	proc
	cmp		EnemiesDestroyed , 0
	je		_cadtd_skip
	mov		cl , EnemiesDestroyed
	cmp		procedure_color , 1
	jne		_cadtd_black
	sub		black_count , cl
	jmp		_cadtd_skip
_cadtd_black:	
	sub		white_count , cl
_cadtd_skip:
	mov		si , offset active_desk
	mov		di , desk_offset
	call	Copy
	ret
endp	CopyActiveDeskToDesk

CopyDeskToActiveDesk	proc
	mov		si , desk_offset
	mov		di , offset active_desk
	call	Copy
	ret
endp	CopyDeskToActiveDesk

CopyDumpDeskToDeskWhite		proc
	mov		si , offset white_desk_dump
	mov		di , offset white_desk
	call	Copy
	ret
endp	CopyDumpDeskToDeskWhite

CopyDumpDeskToDeskBlack		proc
	mov		si , offset black_desk_dump
	mov		di , offset black_desk
	call	Copy
	ret
endp	CopyDumpDeskToDeskBlack


Copy	proc
    mov		cx , 64
	rep		movsb
	ret
endp	Copy

Statistic	proc
	push	ax
	push	dx
	mov		ah , 02h
	mov		dl , 30h
	add		dl , black_count
	int		21h
	mov		dl , 30h
	add		dl , white_count
	int		21h
	pop		dx
	pop		ax
	ret
endp		Statistic