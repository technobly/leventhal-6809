
	.macro	CLC
		ANDCC	#$FE
	.endm

	.macro	SEC
		ORCC	#$01
	.endm
    
;	Title:		Find Maximum byte-length Element 
;	Name:		MAXELM 
;
;	Purpose:	Given the base address and size of an array,
;			find the Largest element.
;
;	Entry:		Register X = Base address of array 
;			Register A = Size of array in bytes 
;
;	Exit:		If size of array not zero then Carry flag = 0
;			Register A = Largest element 
;			Register X = Address of that element
;
;			If there are duplicate values of the largest element,
;			register X contains the address nearest to the base address.
;			else Carry flag = 1
;
;	Registers Used:	A,B,CC,X,Y
;
;	Time:		Approximately 14 to 26 cycles per byte
;			plus 27 cycles overhead
;
;	Size:		Program 25 bytes
;
MAXELM:
	;
	; EXIT WITH CARRY SET IF NO ELEMENTS IN ARRAY
	;
	SEC			; SET CARRY IN CASE ARRAY HAS NO ELEMENTS
	TSTA			; CHECK NUMBER OF ELEMENTS
	BEQ	EXITMX		; BRANCH (EXIT) WITH CARRY SET IF NO
				; ELEMENTS INDICATES INVALID RESULT
	;
	; EXAMINE ELEMENTS ONE AT A TIME, COMPARING EACH 0NE'S VALUE
	; WITH CURRENT MAXIMUM AND ALWAYS KEEPING LARGER VALUE AND
	; ITS ADDRESS. IN THE FIRST ITERATION, TAKE THE FIRST
	; ELEMENT AS THE CURRENT MAXIMUM.
	;
	TFR	A,B		; SAVE NUMBER OF ELEMENTS IN B
	LEAY	1,X		; SET POINTER AS IF PROGRAM HAD JUST
				; EXAMINED THE FIRST ELEMENT AND FOUND
				; IT TO BE LARGER THAN PREVIOUS MAXIMUM
MAXLP:
	LEAX	-1,Y		; SAVE ADDRESS OF ELEMENT JUST EXAMINED
				; AS ADDRESS OF MAXIMUM
	LDA	,X		; SAVE ELEMENT JUST EXAMINED AS MAXIMUM
	;
	; COMPARE CURRENT ELEMENT TO MAXIMUM
	; KEEP LOOKING UNLESS CURRENT ELEMENT IS LARGER
	;
MAXLP1:
	DECB			; COUNT ELEMENTS
	BEQ	EXITLP		; BRANCH (EXIT) IF ALL ELEMENTS EXAMINED
	CMPA	,Y+		; COMPARE CURRENT ELEMENT TO MAXIMUM
				; ALSO MOVE POINTER TO NEXT ELEMENT
	BCC	MAXLP1		; CONTINUE UNLESS CURRENT ELEMENT LARGER
	BCS	MAXLP		; ELSE CHANGE MAXIMUM
	;
	; CLEAR CARRY TO INDICATE VALID RESULT MAXIMUM FOUND
	;
EXITLP:
	CLC			; CLEAR CARRY TO INDICATE VALID RESULT
EXITMX:
	RTS
;
; SAMPLE EXECUTION:
;
SC6C:
	LDX	#ARY		; GET BASE ADDRESS OF ARRAY
	LDA	#SZARY		; GET SIZE OF ARRAY IN BYTES
	JSR	MAXELM		; FIND LARGEST UNSIGNED ELEMENT
				; RESULT FOR TEST DATA IS
				; A = FF HEX (MAXIMUM), X = ADDRESS OF
				; FF IN ARY.
	BRA	SC6C		; LOOP FOR MORE TESTING

SZARY	EQU	$10		; SIZE OF ARRAY IN BYTES

ARY:	FCB	8
	FCB	7
	FCB	6
	FCB	5
	FCB	4
	FCB	3
	FCB	2
	FCB	1
	FCB	$FE
	FCB	$FD
	FCB	$FC
	FCB	$FB
	FCB	$FA
	FCB	$FB

	END

