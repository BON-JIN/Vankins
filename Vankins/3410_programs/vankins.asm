.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h

.STACK 4096


.DATA


prompt_a BYTE "ABCD" , 0
prompt_b BYTE "BBBB" , 0
new_line BYTE 8 , CR, LF, 0
txt BYTE SIZEOF prompt_a DUP(0)


.CODE
_start:
	
	mov ecx , 0




	;lea esi , prompt_a
	;lea edi , txt
	lea ebx , prompt_a
	lea edx , txt
while_loop:
	;mov al , [esi]
	;mov [edi], al
	;inc esi
	;inc edi

	;test al , al
	;jnz while_loop

	mov ax , 5
	mov bl , 3
	imul bl
	outputW ax

	INVOKE ExitProcess, 0

PUBLIC _start
	END 