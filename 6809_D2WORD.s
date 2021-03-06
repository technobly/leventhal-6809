; Title:		Two-Dimensional Word Array Indexing
;
; Name:			D2WORD
; 
; 
; Purpose:		Given the base address of a word array,
;			two subscripts 'I' and 'J', and the size
;			of the first subscript in bytes, calculate
;			the address of A[I,J]. The array is assumed
;			to be stored in row major order (A[0,0],
;			A[0,1],...,A[K,L]), and both dimensions
;			are assumed to begin at zero as in the
;			following Pascal declaration:
;
;			A:ARRAY[0..2,0..7] OF WORD;
;
; Entry:		TOP OF STACK
;
;			High byte of return address
;			Low  byte of return address
;			High byte of second subscript (column element)
;			Low  byte of second subscript (column element)
;			High byte of first subscript size, in bytes
;			Low  byte of first subscript size, in bytes
;			High byte of first subscript (row element)
;			Low  byte of first subscript (row element) 
;			High byte of array base address
;			Low  byte of array base address 
;			
;			NOTE:
;			
;			The first subscript size is the length of a row in words * 2
;			
; Exit:			Register X = Element's base address
;
; Registers Used:	CC,D,X,Y
;
; Time:			Approximately 790 cycles 
; 
; Size:			Program 38 bytes
;
D2WORD:			
	; 
	; ELEMENT ADDRESS = ROW SIZE * ROW SUBSCRIPT + 2 * COLUMN
	; SUBSCRIPT + BASE ADDRESS
	;
	LDD	#0			; START ELEMENT ADDRESS AT 0
	LDY	#16			; SHIFT COUNTER = 16
	;
	; MULTIPLY ROW SUBSCRIPT * ROW SIZE
	; USING SHIFT AND ADD ALGORITHM
	;
MUL16:
	LSR	4,S 			; SHIFT HIGH BYTE OF ROW SIZE
	ROR	5,S			; SHIFT LOW BYTE OF ROW SIZE 	
	BCC	LEFTSH 			; JUMP IF NEXT BIT OF ROW SIZE IS 0 
	ADDD	6,S			; OTHERWISE, ADD SHIFTED ROW SUBSCRIPT
					; TO ELEMENT ADDRESS
LEFTSH:
	LSL	7,S			; SHIFT LOW BYTE OF ROW SUBSCRIPT
	ROL	6,S			; SHIFT HIGH BYTE PLUS CARRY
	LEAY	-1,Y			; DECREMENT SHIFT COUNTER
	BNE	MUL16			; LOOP 16 TIMES	
	; 
	; ADD  COLUMN SUBSCRIPT TWICE TO ROW SUBSCRIPT * ROW SIZE
	;
	ADDD	2,S			; ADD COLUMN SUBSCRIPT
	ADDD	2,S			; ADD COLUMN SUBSCRIPT AGAIN
	ADDD	8,S			; ADD BASE ADDRESS OF ARRAY
	TFR	D,Y			; EXIT WITH ELEMENT ADDRESS IN X
	;
	; REMOVE PARAMETERS FROM STACK AND EXIT
	;
	PULS	D			; GET RETURN ADDRESS 
	LEAS	6,S			; REMOVE PARAMETERS FROM STACK 
	STD	,S			; PUT RETURN ADDRESS BACK ON STACK
	RTS
;
; SAMPLE EXECUTION
;	
SC2D:
	LDU	#ARY 			; BASE ADDRESS OF ARRAY
	LDY	SUBS1 			; FIRST SUBSCRIPT
	LDX	SSUBS1 			; SIZE OF FIRST SUBSCRIPT
	LDD	SUBS2			; SECOND SUBSCRIPT
	PSHS	U,X,Y,D			; PUSH PARAMETERS
	JSR	D2WORD			; CALCULATE ADDRESS
					; FOR THE INITIAL TEST DATA
					; X = ADDRESS OF ARY(2,4)
					;   = ARY + (2*16) + 4 * 2
					;   = ARY + 40 (CONTENTS ARE 2100H)
					; NOTE BOTH SUBSCRIPTS START AT 0
;
; DATA
;	
SUBS1:	FDB	2			; SUBSCRIPT 1
SSUBS1:	FDB	16			; SIZE OF SUBSCRIPT 1 
					; (NUMBER OF BYTES PER ROW)
SUBS2:	FDB	4			; SUBSCRIPT 2
;
; THE ARRAY (3 ROWS OF 8 COLUMNS)
;
ARY:
	FDB	0100H,0200H,0300H,0400H,0500H,0600H,0700H,0800H
	FDB	0900H,1000H,1100H,1200H,1300H,1400H,1500H,1600H 
	FDB	1700H,1800H,1900H,2000H,2100H,2200H,2300H,2400H
	END
