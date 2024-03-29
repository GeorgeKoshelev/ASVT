
Ser_Ini proc near
	push ax								; ���p����� p�����p�
	push dx
		push bx
		push es
			in al, 21h					; IMR 1-�� ����p���p� �p�p������
			or al, 10h					; ���p����� �p�p������ IRQ4 �� COM1
			out 21h, al
			mov al, 0Ch
			mov ah, 35h
			int 21h						; ����� �����p Int 0Ch � es:bx
			mov Ser_ip, bx				; � ���p����� ���
			mov Ser_cs, es
			mov al, 0Ch
			mov dx, offset Ser_int
			push ds
				mov bx, cs
				mov ds, bx
				mov ah, 25h
				int 21h					; ���������� Int 0Ch = ds:dx
			pop ds
		pop es
		pop bx
		cli								; ���p����� �p�p������
		in al, 21h						; IMR 1-�� ����p����p� �p�p������
		and al, not 10h
		out 21h, al						; p��p����� �p�p������ �� COM1
		mov dx, 3FBh					; p�����p ��p������� ������
		in al, dx
		or al, 80h						; ���������� ��� DLAB
		out dx, al
		mov dx, 3F8h
		mov al, 60h
		out dx, al						; ������� ���� ��� ���p���� 1200 ���
		inc dx
		mov al, 0
		out dx, al						; ���p��� ���� ���p����
		mov dx, 3FBh					; p�����p ��p������� ������
		mov al, 00000011b				; 8 ���, 2 ����-����, ��� ��������
		out dx, al
		mov dx, 3F9h					; p�����p p��p������ �p�p������
		mov al, 1						; p��p����� �p�p������ �� �p����
		out dx, al
		nop								; � ����-���� ���������
		nop
		mov dx, 3FCh					; p�����p ��p������� �������
		mov al, 00001011b				; ���������� DTR, RTS � OUT2
		out dx, al
		sti								; p��p����� �p�p������
		mov dx, 3F8h					; p�����p ������
		in al, dx						; ��p����� ����p �p����
	pop dx
	pop ax
	ret
Ser_Ini endp

Source db 1026 dup(0)					; ����p �p���� ��������
Src_ptr dw Source						; ��������� ������� � ����p�
Count dw 0								; ���������� �������� � ����p�
Ser_ip dw 0								; ���p�� ��p�� Int 0Ch
Ser_cs dw 0
Save_ds dw 0							; ��������� ��p�������
Int_sts db 0
Overrun db 0

Ser_Rst proc near
	push ax								; ���p����� p�����p�
	push dx
	push ds
	
	Wait_Free:
		mov ax, cs
		mov ds, ax
		mov dx, 3FDh					; p�����p ��������� �����
		in al, dx
		jmp short $+2					; ��p����� ����p���
		test al, 60h					; ��p����� ��������?
		jz Wait_Free					; ����, ���� ���
		mov dx, 3F9h					; p�����p p��p������ �p�p������
		mov al, 0						; ���p����� �p�p������
		out dx, al
		jmp short $+2					; ��� ��������...
		jmp short $+2
		mov dx, 3FCh					; p�����p ��p������� �������
		mov al, 00000011b				; ������p����� DTR � RTS
		out dx, al
		jmp short $+2
		jmp short $+2
		push bx
			mov al, 0Ch
			mov dx, Ser_ip
			push ds
				mov bx, Ser_cs
				mov ds, bx
				mov ah, 25h
				int 21h					; ������������ �����p Int 0Ch
			pop ds
		pop bx
		cli								; ���p�� �p�p������
		in al, 21h						; ������ ����� �p�p������
		jmp short $+2
		or al, 10h						; ���p����� IRQ4
		out 21h, al
		sti								; p��p������ �p�p������
	pop ds
	pop dx
	pop ax
	ret
Ser_Rst endp

Ser_Int proc far
	push ax
	push dx
	push ds
		mov ax, cs
		mov ds, ax
		mov dx, 3FAh					; p�����p ������������� �p�p������
		in al, dx
		mov Int_Sts, al					; ���p���� ��� ����p�����
		test al, 1						; ���� ���������� �p�p������?
		jz Is_Int						; ��
	pop Save_ds							; ���, ��p����� ��p�������
	pop dx								; ���p��� ��p�������� Int 0Ch
	pop ax
	push Ser_cs
	push Ser_ip
		push Save_ds
		pop  ds
	ret									; ������� ��p����

	Is_Int:
		mov al, 64h						; ������� EOI ��� IRQ4
		out 20h, al						; � 1-� ����p����p �p�p������
		test Int_Sts, 4					; �p�p������ �� �p����?
		jnz Read_Char					; ��
	No_Char:
		sti								; ���, p��p����� �p�p������
		jmp Int_Ret						; � ��������� ��p������ Int 0Ch

	Read_Char:
		mov dx, 3FDh					; p�����p ��������� �����
		in al, dx
		and al, 2
		mov Overrun, al					; ovvrrun<>0, ���� ���� ����p� �������
		mov dx, 3F8h					; p�����p ������
		in al, dx						; ������ ������
		or al, al						; ���� �p���� ����,
		jz No_Char						; �� ����p�p��� ���
		push bx
			mov ah, Overrun
			or ah, ah					; �p�������� ������ ����p��?
			jz Save_Char				; ���
			mov ah, al					; ��,
			mov al, 7					; �������� ��� �� ������ (07h)
		Save_Char:
			mov bx, Src_ptr				; ������� ������ � ����p
			mov [bx], al
			inc Src_ptr					; � ��������� ��������
			inc bx
			cmp bx, offset Src_ptr-2	; ���� ����� ����p�
			jb Ser_Int_1
			mov Src_ptr, offset Source	; �� "�����������" �� ������
		Ser_Int_1:
			cmp Count, 1024			; ����p �����?
			jae Ser_Int_2				; ��
			inc Count					; ���, ������ ������
		Ser_Int_2:
			or ah, ah					; ���� ���� ����p� �������
			jz Ser_Int_3
			mov al, ah					; �� ������� � ����p ��� ������
			xor ah, ah
			jmp short Save_Char
	Ser_Int_3:
		pop bx
		sti								; p��p����� �p�p������
Int_Ret:
	pop  ds
	pop  dx
	pop  ax
	iret
Ser_Int endp

Out_Chr proc near ; (al)
	push ax
	push cx
	push dx
		mov ah, al
		sub cx, cx
		
	Wait_Line:
		mov dx, 3FDh					; p�����p ��������� �����
		in al, dx
		test al, 20h					; ���� ����� � ��p�����?
		jnz Output						; ��
		jmp short $+2
		jmp short $+2
		loop Wait_Line					; ���, ����
	pop dx
	pop cx
	pop ax
	stc									; ��� ���������� ��p��
	ret									; CF = is_error = 1
	
	Output:
		mov al, ah
		mov dx, 3F8h					; p�����p ������
		jmp short $+2
		out dx, al						; ������� ������
	pop dx
	pop cx
	pop ax
	clc									; ��p������� ����p��
	ret									; CF = is_error = 0
Out_Chr endp

Get_Chr proc near
	cmp Count, 0						; ����p ����?
	jne loc_1729						; ���
	stc									; ��, ����p�� �� ������
	ret									; CF = buffer_is_empty = 1
loc_1729:
	push si
		cli								; ���p���� �p�p������
		mov si, Src_ptr
		sub si, Count
		cmp si, offset Source
		jae loc_1730
		add si, 1024
	loc_1730:
		mov al, [si]					; ����p�� ������
		dec Count						; � �������� �������
		sti								; p��p������ �p�p������
	pop si
	clc									; � ��p������� ����p��
	ret									; al = symbol, CF = buffer_is_empty = 0
Get_Chr endp

; Buf_Size  equ  1024           ; p����p ����p�
; Source    db   Buf_Size+2 dup (0) ; ����p �p���� ��������
; Src_ptr   dw   Source         ; ��������� ������� � ����p�
; Count     dw   0              ; ���������� �������� � ����p�
; Ser_ip    dw   0              ; ���p�� ��p�� Int 0Ch
; Ser_cs    dw   0
; Save_ds   dw   0              ; ��������� ��p�������
; Int_sts   db   0
; Overrun   db   0	


; proc Ser_Ini near
	; push 	ax        ; ���p����� p�����p�
	; push 	dx
	; push 	bx
	; push 	es
	; in   	al, 21h    ; IMR 1-�� ����p���p� �p�p������
	; or   	al, 8h    ; ���p����� �p�p������ IRQ4 �� COM1
	; out  	21h, al
	; mov  	al, 0Bh
	; mov  	ah, 35h
	; int  	21h       ; ����� �����p Int 0Ch � es:bx
	; mov  	Ser_ip, bx ; � ���p����� ���
	; mov  	Ser_cs, es
	; mov		al, 0Bh
	; mov  	dx, offset Ser_int
	; push 	ds
	; mov  	bx, cs
	; mov  	ds, bx
	; mov  	ah, 25h
	; int  	21h       ; ���������� Int 0Ch = ds:dx
	; pop  	ds
	; pop  	es
	; pop		bx
	; cli            ; ���p����� �p�p������
	; in   	al, 21h    ; IMR 1-�� ����p����p� �p�p������
	; and  	al, not 8h
	; out  	21h, al    ; p��p����� �p�p������ �� COM1
	; mov  	dx, 2FBh   ; p�����p ��p������� ������
	; in   	al, dx
	; or   	al, 80h    ; ���������� ��� DLAB
	; out  	dx, al
	; mov  	dx, 2F8h
	; mov  	al, 60h
	; out  	dx, al     ; ������� ���� ��� ���p���� 1200 ���
	; inc  	dx
	; mov  	al, 0
	; out  	dx, al     ; ���p��� ���� ���p����
	; mov  	dx, 2FBh   ; p�����p ��p������� ������
	; mov  	al, 00000011b ; 8 ���, 2 ����-����, ��� ��������
	; out  	dx, al
	; mov  	dx, 2F9h   ; p�����p p��p������ �p�p������
	; mov  	al, 1      ; p��p����� �p�p������ �� �p����
	; out  	dx, al
	; nop            ; � ����-���� ���������
	; nop
	; nop
	; nop
	; mov  	dx, 2FCh   ; p�����p ��p������� �������
	; mov  	al, 00001011b ; ���������� DTR, RTS � OUT2
	; out  	dx, al
	; sti            ; p��p����� �p�p������
	; mov  	dx, 2F8h   ; p�����p ������
	; in   	al, dx     ; ��p����� ����p �p����
	; pop  	dx
	; pop  	ax
	; ret
; endp Ser_Ini

; proc Ser_Rst near
	; push 	ax        ; ���p����� p�����p�
	; push 	dx
; Wait_Free:
	; mov  	dx, 2FDh   ; p�����p ��������� �����
	; in   	al,dx
	; jmp  	short $+2 ; ��p����� ����p���
	; test 	al, 60h    ; ��p����� ��������?
	; jz   	Wait_Free ; ����, ���� ���
	; mov  	dx, 2F9h   ; p�����p p��p������ �p�p������
	; mov  	al, 0      ; ���p����� �p�p������
	; out  	dx,al
	; jmp  	short $+2 ; ��� ��������...
	; jmp  	short $+2
	; mov  	dx, 2FCh   ; p�����p ��p������� �������
	; mov  	al, 00000011b ; ������p����� DTR � RTS
	; out  	dx, al
	; jmp  	short $+2
	; jmp  	short $+2
	; push 	bx
	; mov  	al, 0Bh
	; mov  	dx, Ser_ip
	; push 	ds
	; mov  	bx, Ser_cs
	; mov  	ds, bx
	; mov  	ah, 25h
	; int  	21h       ; ������������ �����p Int 0Ch
	; pop  	ds
	; pop  	bx
	; cli            ; ���p�� �p�p������
	; in   	al, 21h    ; ������ ����� �p�p������
	; jmp  	short $+2
	; or   	al, 8h    ; ���p����� IRQ4 bxlo 16h
	; out  	21h, al
	; sti            ; p��p������ �p�p������
	; pop  dx
	; pop  ax
	; ret
; endp Ser_Rst

; proc Ser_Int far
	; push 	ax
	; push 	dx
	; push 	ds
	; mov  	ax, cs
	; mov		ds, ax
	; mov  	dx, 2FAh   ; p�����p ������������� �p�p������
	; in   	al, dx
	; mov  	Int_Sts, al; ���p���� ��� ����p�����
	; test 	al, 1      ; ���� ���������� �p�p������?
	; jz   	Is_Int    ; ��
	; pop  	Save_ds   ; ���, ��p����� ��p�������
	; pop  	dx        ; ���p��� ��p�������� Int 0Ch
	; pop  	ax
	; push 	Ser_cs
	; push 	Ser_ip
	; push 	Save_ds
	; pop  	ds
	; ret            ; ������� ��p����
; Is_Int:
	; mov  	al, 63h    ; ������� EOI ��� IRQ4 ; bxlo 64h
	; out  	20h, al    ; � 1-� ����p����p �p�p������
	; test 	Int_Sts, 4 ; �p�p������ �� �p����?
	; jnz  	Read_Char ; ��
; No_Char:
	; sti            ; ���, p��p����� �p�p������
	; jmp  	Int_Ret   ; � ��������� ��p������ Int 0Ch
; Read_Char:
	; mov  	dx, 2FDh   ; p�����p ��������� �����
	; in   	al, dx
	; and  	al, 2
	; mov  	Overrun, al; ovvrrun<>0, ���� ���� ����p� �������
	; mov  	dx, 2F8h   ; p�����p ������
	; in   	al, dx     ; ������ ������
	; or   	al, al     ; ���� �p���� ����,
	; jz   	No_Char   ; �� ����p�p��� ���
	; push 	bx
	; mov  	ah, Overrun
	; or   	ah, ah     ; �p�������� ������ ����p��?
	; jz   	Save_Char ; ���
	; mov  	ah, al     ; ��,
	; mov  	al, 7      ; �������� ��� �� ������ (07h)
; Save_Char:
	; mov  	bx, Src_ptr; ������� ������ � ����p
	; mov  	[bx], al
	; inc  	Src_ptr   ; � ��������� ��������
	; inc  	bx
	; cmp  	bx, offset Src_ptr-2 ; ���� ����� ����p�
	; jb   	Ser_Int_1
	; mov  	Src_ptr, offset Source ; �� "�����������" �� ������
; Ser_Int_1:
	; cmp  	Count, Buf_Size ; ����p �����?
	; jae  	Ser_Int_2 ; ��
	; inc  	Count     ; ���, ������ ������
; Ser_Int_2:
	; or   	ah, ah     ; ���� ���� ����p� �������
	; jz   	Ser_Int_3
	; mov  	al, ah     ; �� ������� � ����p ��� ������
	; xor  	ah, ah
	; jmp  	short Save_Char
; Ser_Int_3:
	; pop  	bx
	; sti            ; p��p����� �p�p������
; Int_Ret:
	; pop  	ds
	; pop  	dx
	; pop  	ax
	; iret
; endp Ser_Int

; proc Out_Chr near
	; push 	ax
	; push 	cx
	; push 	dx
	; mov  	ah, al
	; sub		cx, cx
; Wait_Line:
	; mov  	dx, 2FDh   ; p�����p ��������� �����
	; in   	al, dx
	; test 	al,20h    ; ���� ����� � ��p�����?
	; jnz  	output    ; ��
	; jmp  	short $+2
	; jmp  	short $+2
	; loop 	Wait_Line ; ���, ����
	; pop  	dx
	; pop  	cx
	; pop  	ax
	; stc            ; ��� ���������� ��p��
	; ret
; output:
	; mov  	al, ah
	; mov  	dx, 2F8h   ; p�����p ������
	; jmp  	short $+2
	; out  	dx, al     ; ������� ������
	; pop  	dx
	; pop  	cx
	; pop  	ax
	; clc            ; ��p������� ����p��
	; ret
; endp Out_Chr

; proc Get_Chr near
	; cmp  	Count, 0   ; ����p ����?
	; jne  	loc_1729  ; ���
	; stc            ; ��, ����p�� �� ������
	; ret
; loc_1729:
	; push 	si
	; cli            ; ���p���� �p�p������
	; mov  	si, Src_ptr
	; sub  	si, Count
	; cmp  	si, offset Source
	; jae  	loc_1730
	; add  	si, Buf_Size
; loc_1730:
	; mov  	al, [si]   ; ����p�� ������
	; dec  	Count     ; � �������� �������
	; sti            ; p��p������ �p�p������
	; pop  	si
	; clc            ; � ��p������� ����p��
	; ret
; endp Get_Chr