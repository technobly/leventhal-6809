;	Title:			Hex ASCII to Binary 
;
;	Name:			HEX2BN 
;
;	Purpose:		Converts two ASCII characters to one byte of binary data
;
;	Entry:			Register A = ASCII more significant digit 
;				Register B = ASCII less significant digit
;
;	Exit:			Register A = Binary data
;
;	Registers Used:		A,B,CC
;
;	Time:			Approximately 39 cycles 
;
;	Size:			Program	25 bytes
;				Data	1 byte on stack
; 
;	CONVERT MORE SIGNIFICANT DIGIT TO BINARY
;
HEX2BN:
	SUBA	#'0'		; SUBTRACT ASCII OFFSET (ASCII 0)
	CMPA	#9		; CHECK IF DIGIT DECIMAL 
	BLS	SHFTMS		; BRANCH IF DECIMAL 
	SUBA	#7		; ELSE SUBTRACT _OFFSET FOR LETTERS 
SHFTMS:	LSLA			; SHIFT DIGIT TO MORE SIGNIFICANT BITS
	LSLA
	LSLA
	LSLA
; 
; CONVERT LESS SIGNIFICANT DIGIT TO BINARY
;
	SUBB	#'0'		; SUBTRACT ASCII OFFSET (ASCII 0) 
	CMPB	#9		; CHECK IF DIGIT DECIMAL 
	BLS	CMBDIG		; BRANCH IF DECIMAL 
	SUBB	#7		; ELSE SUBTRACT OFFSET FOR LETTERS 
; 
;	COMBINE LESS SIGNIFICANT, MORE SIGNIFICANT DIGITS 
; 
CMBDIG:
	STB	,-S		; SAVE LESS SIGNIFICANT DIGIT IN STACK

	ADDA	,S+		; ADD DIGITS
	RTS
;
;	SAMPLE EXECUTION
SC1D:
	; CONVERT ASCII 'C7' TO C7 HEXADECIMAL

	LDA	#'C'
	LDB	#'7'
	JSR	HEX2BN		; A = C7H
;
;	CONVERT ASCII '2F' TO 2F HEXADECIMAL
;
	LDA	#'2'
	LDB	#'F'
	JSR	HEX2BN		; A = 2FH
;
;	CONVERT ASCII '2A' TO 2A HEXADECIMAL
;
	LDA	#'2'
	LDB	#'A'
	JSR	HEX2BN		; A = 2AH

	END

