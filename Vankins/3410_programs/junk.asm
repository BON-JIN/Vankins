.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h

.STACK 4096

MAX_CONTAINER EQU 150
BUFFER_SIZE	EQU	30

.DATA
index_offset DWORD 0

matrix			WORD   150 DUP(0)
matrix_solution WORD   150 DUP(0)

value WORD ?
num_rows WORD ?
num_cols WORD ?

index_row WORD ?
index_col WORD ?

index_row_a WORD ?
index_col_a WORD ?


index_row_b WORD ?
index_col_b WORD ?

col_right WORD ?
row_down WORD ?

index_array WORD ?

element WORD ?

max_size WORD ?
max_index WORD ?

dividend WORD ?
divisor WORD ?
reminder WORD ?

element_on_the_right WORD ?
element_on_the_down WORD ?

element_to_be_set WORD ?

prompt_vankins BYTE "Vankins Mile", CR , LF, 0
prompt_rows BYTE "row", 0
prompt_cols BYTE "col", 0
prompt_containers BYTE "Size of containers are ", 0
prompt_MAXSIZE BYTE "MAX size is ", 0
prompt_matrix BYTE "Input Matrix is ", CR , LF, 0
prompt_matrix_solution BYTE " Solution Matrix is ",CR , LF, 0
prompt_r BYTE "r", 0
prompt_d BYTE "d", 0
prompt_dash BYTE "------------------------------------------------------------------------------------------", CR , LF, 0


new_line    BYTE CR, LF, 0
txt        BYTE     13 DUP(?), 0


.CODE
print_matrix MACRO  matrix, max_size
	local while_array_is_not_empty_display_matrix, keep_printing
	lea ebx , matrix
	mov ecx , 0
	mov cx , max_size

	mov ax , num_cols
	mov divisor , ax
while_array_is_not_empty_display_matrix:

	mov ax , cx
	mov dx , 0
	

	div divisor
	mov reminder , dx

	cmp dx , 0
	jne keep_printing
	itoa txt , reminder
	output new_line


keep_printing:
	mov ax , [ebx]
	add ebx , 2
	itoa txt, ax
	output txt

	dec cx
	cmp cx , 0
	jne while_array_is_not_empty_display_matrix
	output new_line
	output new_line
	output new_line
ENDM


getElement MACRO matrix_addr, row, col, loc 

	mov index_offset  , 0 ; index_offset is DWORD
	mov eax , 0
	; index = num_col x (row - 1) + (col - 1)
	mov bx , row
	sub bx , 1 ; (row - 1)
	mov ax , num_cols 
	mul bx ; num_col x (row - 1)
	mov bx , col
	sub bx , 1
	add ax , bx ; (row - 1) + (col - 1)

	mov bx , 2
	mul bx
	cwd
	mov index_offset , eax
	lea ebx , matrix_addr
	add ebx , index_offset
	mov eax , 0
	mov ax , WORD PTR [ebx]
	mov loc , ax
	
ENDM

setElement MACRO matrix_addr, row, col, loc
	mov eax , 0
	; index = num_col x (row - 1) + (col - 1)
	mov bx , row
	sub bx , 1 ; (row - 1)
	mov ax ,num_cols 
	mul bx ; num_col x (row - 1)
	mov bx , col
	sub bx , 1
	add ax , bx ; (row - 1) + (col - 1)

	mov bx , 2
	mul bx

	cwd
	mov index_offset , eax


	lea ebx , matrix_addr
	add ebx , index_offset
	mov eax , 0
	mov ax , loc
	mov [ebx] , WORD PTR ax

	mov ax , WORD PTR [ebx]


ENDM

get_index_row_and_col MACRO index, row, col
	
	mov edx , 0
	mov ax , index
	cbw 
	div num_cols
	add ax , 1
	mov row , ax

	mov edx , 0
	mov ax , index
	cbw 
	div num_cols
	add dx , 1
	mov col , dx
ENDM

get_right MACRO matrix_addr, row, col, loc

	local process, nothing_on_the_right, done

	mov ax , col
	add ax , 1
	cmp ax , num_cols
	jg nothing_on_the_right

process: 
	mov col_right , ax
	getElement matrix_addr, row, col_right, loc
	jmp done

nothing_on_the_right:
	mov ax , 0
	mov loc , 0
done:
	
ENDM

get_down MACRO matrix_addr, row, col, loc

	local process, nothing_on_the_down, done

	mov ax , row
	add ax , 1
	cmp ax , num_rows
	jg nothing_on_the_down

process: 
	mov row_down , ax
	getElement matrix_addr, row_down, col, loc
	jmp done

nothing_on_the_down:
	mov ax , 0
	mov loc , 0
done:

ENDM

get_element_to_be_set MACRO element, right, down, loc
local compare, down_is_great, right_is_great, done
compare:
	mov ax , right
	cmp ax, down
	jg right_is_great
down_is_great:
	mov ax , down
	add ax , element
	mov loc , ax
	jmp done
right_is_great:
	mov ax , right
	add ax , element
	mov loc , ax
done:

ENDM

algorithm_start MACRO
	local While_everything_is_completed_to_be_caliculated, done
	mov ax , max_size
	sub ax , 1
	mov index_array , ax

While_everything_is_completed_to_be_caliculated:
	get_index_row_and_col index_array, index_row, index_col
	getElement matrix, index_row, index_col, element

	get_right matrix_solution, index_row, index_col, element_on_the_right
	get_down  matrix_solution, index_row, index_col, element_on_the_down

	get_element_to_be_set element, element_on_the_right, element_on_the_down, element_to_be_set
	setElement matrix_solution, index_row, index_col, element_to_be_set

	sub index_array , 1
	cmp index_array , 0
	jl done

	jmp While_everything_is_completed_to_be_caliculated
done:

	output prompt_matrix_solution
	print_matrix matrix_solution, max_size
ENDM

soluion_process MACRO right, down, row, col
local compare, down_is_great, right_is_great, done, solution
compare:
	mov ax , right
	cmp ax, down
	jge right_is_great
	
down_is_great:
	output prompt_d
	add row, 1
	jmp done

right_is_great:
	output prompt_r
	add col, 1

done:
ENDM

solution MACRO
	mov index_row , 1
	mov index_col , 1

while_is_not_deadEnd:
	get_right matrix_solution, index_row, index_col, element_on_the_right
	get_down  matrix_solution, index_row, index_col, element_on_the_down
	soluion_process element_on_the_right, element_on_the_down, index_row, index_col

	mov ax, index_row
	cmp ax, num_rows
	jg done

	mov ax, index_col
	cmp ax, num_cols
	jg done

	jmp while_is_not_deadEnd
done:
	
	output new_line
	output prompt_dash
ENDM

input_proess MACRO
	local input_while_loop

	inputW prompt_rows , num_rows
	outputW num_rows
	inputW prompt_cols , num_cols
	outputW num_cols

	mov ax , num_rows
	mov bx , num_cols
	mul bx
	mov max_size , ax

	output prompt_containers
	outputW max_size

	mov ecx, 0 ; this is very important
	mov cx , max_size
	lea ebx , matrix

input_while_loop:
	;inputW prompt , ax
	inputWO ax
	mov [ebx] , ax
	add ebx , 2

	loop input_while_loop ; decrement cx first, then test cx for 0

	output new_line
	output prompt_matrix
	print_matrix matrix, max_size ; print matrix
ENDM

inputWO          MACRO  location
                   input text, 8
                   atoi text
                   mov location, ax
                ENDM
_start:
	output new_line
	output prompt_vankins
	output new_line

	input_proess

	algorithm_start

	solution

	INVOKE ExitProcess, 0

PUBLIC _start
	END 