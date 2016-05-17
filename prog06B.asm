TITLE Programming Assignment 6     (prog06B.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #5
; Due Date: 12/6/15
; Description:  This program can be used as a tool to learn combinatorics.
; The user will be provided with random problems.  After the answer is entered
; the program checks for correctness and then prompts the user for an additional problem.   

INCLUDE Irvine32.inc


quickString MACRO buffer
	 push		edx
	 mov		edx, OFFSET buffer
	 call		WriteString
	 pop		edx
ENDM

.data
MIN = 1
MAX = 30
LO = 3
HI = 12
programName		 BYTE		"Welcome To: Combinations Calculator -- Assignment 6B", 0
author			 BYTE		"Author: Geoffrey Pard", 0
period			 BYTE		". ", 0
space				 BYTE		" ", 0
space_2			 BYTE		"   ", 0
description_1	 BYTE		"This Program will quiz you on calculating combinations.", 0
description_2	 BYTE		"Enter your answer to check for correctness.", 0
description_3	 BYTE		"You can then decide if you want another problem.", 0
prompt_1			 BYTE		"How many ways can you choose? ", 0
prompt_2			 BYTE		"Would you like another problem? (y/n): ", 0
message_1		 BYTE		"Problem: ", 0
message_2		 BYTE		"Number of Elements in the Set: ", 0
message_3		 BYTE		"Number of Elements to choose from the Set: ", 0
message_4		 BYTE		"There are ", 0
message_5		 BYTE		" combinations of ", 0
message_6		 BYTE		" items from a set of ", 0
message_7		 BYTE		"Correct! ", 0
message_8		 BYTE		"Incorrect... ", 0
message_9		 BYTE		"Invalid Response. ", 0
farewell_1		 BYTE		"This completes the program.  Goodbye.", 0
n					 DWORD	?
fact_n			 DWORD	?
r					 DWORD	?
fact_r			 DWORD	?
nmr				 DWORD	?
fact_nmr			 DWORD	?
userNum			 BYTE		?
reverseNum		 DWORD	?
randomArray		 DWORD	MAX DUP(?)
sLength			 DWORD	0
userInput		 BYTE		MAX DUP(?)
validInput		 BYTE		MAX DUP(?)
result			 DWORD	?
correct			 DWORD	?
convertNum		 DWORD	?

.code
main PROC
; Display Introduction/Welcome
		  call	 introduction
; Simple Directions
		  call	 directions
; Get random numbers to setup problem
		  call	 Randomize
	 again:
		  call	 CrLf
		  push	 OFFSET n
		  push	 OFFSET r
		  call	 probSet
; Show the problem to the User
		  push	 n
		  push	 r
		  call	 showProblem
; Get data from the User
		  push	 OFFSET userInput
		  push	 OFFSET validInput
		  push	 OFFSET sLength
		  call	 getData
; Convert Verified String to Integer
		  push	 OFFSET convertNum
		  push	 OFFSET reverseNum
		  push	 OFFSET validInput
		  push	 OFFSET userNum
		  push	 sLength
		  call	 makeInt
		  call	 CrLf
; ***GET FACTORIALS for n, r, & (n-r)*** 
		  ; n factorial
		  push	 n
		  call	 factorial
		  mov		 fact_n, edx
		  ; r factorial
		  push	 r
		  call	 factorial
		  mov		 fact_r, edx
		  ; (n-r) factorial
		  mov		 eax, n
		  sub		 eax, r
		  mov		 nmr, eax		  ; this is (n-r)
		  push	 nmr
		  call	 factorial
		  mov		 fact_nmr, edx
; ***END FACTORIAL CALCULATIONS***

; Use factorials to calculate appropriate combination
		  push	 fact_n
		  push	 fact_r
		  push	 fact_nmr
		  push	 OFFSET result
		  call	 combinations
; Compare User Answer and Actual result
		  push	 result
		  push	 convertNum
		  push	 OFFSET correct
		  call	 compare
; Response to Comparison
		  push	 n
		  push	 r
		  push	 result
		  push	 correct
		  call	 response
; Prompt the User to Continue
	 prompts:
		  quickString prompt_2
		  call	 ReadChar
		  cmp		 al, 121
		  je		 again
		  cmp		 al, 110
		  je		 endProg
		  call	 CrLf
		  quickString message_9
		  call	 CrLf
		  jmp		 prompts
	 endProg:

; Farewell 
		  call	 farewell
	  
		  exit	; exit to operating system
main ENDP

;*************************************************************
;                     INTRODUCTION
; This Procedure displays the Program Title and Author
; Registers Used/Changed: EDX
;*************************************************************
introduction PROC
		  quickString programName
		  call	 CrLf
		  quickString author
		  call	 CrLf
		  call	 CrLf

		  ret
introduction ENDP

;************************************************************
;                      DIRECTIONS
; Simple Procedure to alert the user to some basic rules
; Specified range for ints is 1 - 400
; Registers Changed/Used: EDX
;************************************************************
directions PROC
		  quickString  description_1
		  call	 CrLf
		  call	 CrLf
		  quickString	description_2
		  call	 CrLf
		  quickString description_3
		  call	 CrLf
		  call	 CrLf

		  ret
directions ENDP

;*****************************************************
;                 probSet
; Procedure to get random numbers within specified
; range to set up new problems.  
; Registers Changed/Used: EAX
;*****************************************************
probSet PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 esi, [ebp+12]
		  mov		 eax, hi
		  sub		 eax, lo
		  inc		 eax
		  call	 RandomRange
		  add		 eax, lo
		  mov		 [esi], eax

		  sub		 eax, min
		  inc		 eax
		  call	 RandomRange
		  add		 eax, min
		  mov		 esi, [ebp+8]
		  mov		 [esi], eax

		  pop		 ebp
		  ret		 8
probSet ENDP

;*****************************************************
;                 showProblem
; Procedure to display the random problem to the user
; (note to grader): Random numbers generated in probSet
; Because of that, parameters passed by value in 
; this procedure.
; Registers Changed/Used: EAX, EBX
;*****************************************************
showProblem	PROC
		  call	 CrLf
		  push	 ebp
		  mov		 ebp, esp
		  mov		 eax, [ebp+12]
		  mov		 ebx,	[ebp+8]
		  quickString message_1
		  call	 CrLf
		  quickString message_2
		  call	 WriteDec
		  call	 CrLf
		  quickString message_3
		  mov		 eax, ebx
		  call	 WriteDec
		  call	 CrLf

		  pop		 ebp
		  ret		 8
showProblem ENDP

;*****************************************************
;                 getData
; Procedure to Prompt User for Integer Input
; Reads in data as a string; does not validate
; Registers Changed/Used: EAX, EBX, ECX, EDX
;*****************************************************
getData PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 ebx, [ebp+8]
	 start:
		  quickString prompt_1
		  mov		 edx, [ebp+16]
		  mov		 ecx, max
		  call	 ReadString

		  mov		 [ebx], eax		  ; string length
		  mov		 ecx, eax
		  mov		 esi, [ebp+16]
		  mov		 edi, [ebp+12]
		  cld

	 counter:
		  lodsb	 
		  cmp		 al, 48
		  jl		 noGood
		  cmp		 al, 57
		  jg		 noGood
		  jmp		 verified
	 noGood:
		  quickString message_9
		  call	 Crlf
		  jmp		 start
	 verified:
		  stosb
		  loop	 counter

		  pop		 ebp

		  ret		 12
getData ENDP

;*****************************************************************
;                      makeInt
; Procedure to convert ASCII string values to a valid integer
; Register Changed/Used: EAX, EBX, ECX, EDX
;*****************************************************************
makeInt PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 esi, [ebp+16]
		  mov		 edi, [ebp+12]			; address of userNum
		  mov		 edx, [ebp+8]

		  mov		 ecx, edx
		  mov		 ebx, 1

		  cld

	 convert:
		  lodsb
		  sub		 al, 48
		  stosb
		  loop	 convert

		  ; Set up Pointers to Reverse String
		  mov		 esi, [ebp+12]
		  mov		 edi, [ebp+20]
		  mov		 ecx, edx
		  add		 esi, ecx
		  dec		 esi
		  mov		 edx, [ebp+24]
		  mov		 edx, 0
		  call	 CrLf
		 
		 ;***This Portion Aggregates string values to Base Ten Sum**** 
	 accum:
		  std
		  lodsb
		  cld
		  push	 edx
		  mul		 ebx
		  pop		 edx
		  add		 edx, eax
		  push	 eax
		  mov		 eax, ebx
		  mov		 ebx, 10
		  push	 edx
		  mul		 ebx
		  pop		 edx
		  mov		 ebx, eax
		  pop		 eax
		  loop	 accum

		  ; Place Int value into memory slot
		  mov		 esi, [ebp+24]
		  mov		 [esi], edx

		  pop		 ebp
		  ret		 20
makeInt ENDP

;*****************************************************************
;                      factorial
; Procedure to recursively solve a random problem
; Receives the value of n and r
; Registers Changed/Used: EAX, EBX, EDX
;*****************************************************************
factorial	PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 eax, [ebp+8]			; variable by value
		  cmp		 eax, 0
		  ja		 recurse
		  mov		 eax, 1
		  jmp		 done


	 recurse:
		  dec		 eax
		  push	 eax
		  call	 factorial

		  mov		 ebx, [ebp+8]
		  mul		 ebx

	 done:
		  mov		 edx, eax
		  pop		 ebp
		  ret		 4
factorial	ENDP

;*****************************************************************
;                     combinations
; Procedure to calculate a combinations problem
; It takes three values already recursively calulated in factorial
; Answer store in result
; Registers Changed/Used: EAX, EBX, ECX
;*****************************************************************
combinations	 PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 ecx, [ebp+20]			; value of n!
		  mov		 ebx, [ebp+16]			; value of r!
		  mov		 eax,	[ebp+12]			; value of nmr!

		  mul		 ebx						; product of r!(nmr!)
		  mov		 ebx, eax
		  mov		 eax, ecx
		  mov		 edx, 0
		  div		 ebx						; n!/product

		  mov		 ebx,	[ebp+8]			; address of result
		  mov		 [ebx], eax				; store in result

		  pop		 ebp
		  ret		 16
combinations	 ENDP

;*****************************************************************
;                      compare
; Procedure to compare the user answer versus actual answer
; Address of correct passed in -- assigned true or false
; Registers Changed/Used: EAX, EBX, EDX
;*****************************************************************
compare PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 eax, [ebp+16]			; value of result
		  mov		 ebx, [ebp+12]			; value of convertNum
		  mov		 esi, [ebp+8]			; address of correct

		  ; compare result and userNum
		  cmp		 eax, ebx
		  je		 isTrue
		  mov		 edx, 0
		  mov		 [esi], edx
		  jmp		 finishComp
	 isTrue:
		  mov		 edx, 1
		  mov		 [esi], edx
	 finishComp:

		  pop		 ebp
		  ret		 12
compare ENDP

;*****************************************************************
;                      response
; Procedure to alert the user to the correctness of their answer
; Registers Changed/Used: EAX, EBX, EDX
;*****************************************************************
response		PROC
		  push	 ebp
		  mov		 ebp, esp

		  ; Correct or Incorrect?
		  mov		 eax, [ebp+8]			; value of correct
		  cmp		 eax, 1
		  je		 isRight
		  quickString message_8
		  call	 CrLf
		  jmp		 showResponse
	 isRight:
		  quickString message_7
		  call	 CrLf

	 showResponse:
		  mov		 ebx, [ebp+16]			; value of r
		  mov		 eax, [ebp+12]			; value of result

		  ; Display results 
		  quickString message_4
		  call	 WriteDec
		  quickString message_5
		  mov		 eax, ebx
		  call	 WriteDec
		  quickString message_6
		  mov		 eax, [ebp+20]			; value of n
		  call	 WriteDec
		  quickString period
		  call	 CrLf

		  pop		 ebp
		  ret		 16
response		ENDP

;*****************************************************************
;                    farewell
; Procedure to alert user to the end of the program.
; Says Goodbye!
; Registers Changed/Used: EDX
;****************************************************************
farewell PROC
		  call	 CrLf
		  call	 CrLf
		  quickString farewell_1
		  call	 CrLf

		  ret
farewell ENDP

END main