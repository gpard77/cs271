TITLE Programming Assignment 3     (prog03.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #3
; Due Date: 11/1/15
; Description:  This program prompts a user for a list of negative numbers.
; It then displays the number of negatives entered, the sum of those numbers,
; as well as the average (truncated).   

INCLUDE Irvine32.inc


.data
UPPER_LIMIT = -1
LOWER_LIMIT = -100
programName		 BYTE		"Welcome To: Integer Accumulator -- Assignment 3", 0
author			 BYTE		"Author: Geoffrey Pard", 0
greeting_1		 BYTE		"Please Enter Your Name: ", 0
greeting_2		 BYTE		"Hi, ", 0
greeting_3		 BYTE		"Prepare to be amazed!", 0
period			 BYTE		". ", 0
space				 BYTE		" ", 0
space_2			 BYTE		"     ", 0
description_1	 BYTE		"You will be prompted for a number in the range of -100 thru -1.", 0
description_2	 BYTE		"The program will then display the amount of negatives entered, ", 0
description_3	 BYTE		"their sum, and average.", 0
prompt_1			 BYTE		"Enter any number in range [-100, -1]: ", 0
prompt_2			 BYTE		"Enter a positive number when you are finished to see results.", 0
prompt_3			 BYTE		"Number not in range. Terminating Sequence.", 0
message_1		 BYTE		"You entered ", 0
message_2		 BYTE		" valid numbers.", 0
message_3		 BYTE		"The sum of your valid numbers is ", 0
message_4		 BYTE		"The rounded average of your numbers is ", 0
message_5		 BYTE		"Please Enter a Number Greater than -100.", 0
userName			 BYTE		21 DUP(0)
farewell_1		 BYTE		"This completes the program.", 0
farewell_2		 BYTE		"Go forth and be hip, ", 0
num1				 SDWORD	?
count				 SDWORD	?
num3				 SDWORD	-1
sum				 SDWORD	?
average			 SDWORD	?

.code
main PROC
; Display Introduction
		  mov		 edx, OFFSET programName
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET author
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf
; Greeting and Prompt for User Name
		  mov		 edx, OFFSET greeting_1
		  call	 WriteString
		  mov		 edx, OFFSET userName
		  mov		 ecx,	SIZEOF userName
		  call	 ReadString
		  mov		 edx, OFFSET greeting_2
		  call	 WriteString
		  mov		 edx, OFFSET userName
		  call	 WriteString
		  mov		 edx, OFFSET period
		  call	 WriteString
		  mov		 edx, OFFSET greeting_3
		  call	 WriteString
		  call	 CrLF
		  call	 CrLF
; Display Description / User Instructions
		  mov		 edx, OFFSET description_1
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET description_2
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET description_3
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf
; Prompt User for Negative Numbers (Get User Data)
		  mov		 edx, OFFSET prompt_2
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf
	 ; Initialize registers pre-loop
		  mov		 ecx, 0
		  mov		 ebx, 0
	 ; Start loop for negative numbers
	 getNums:
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  ; Evaluate User Input
		  cmp		 eax, UPPER_LIMIT
		  jg		 done			 ; out of bounds
		  cmp		 eax, LOWER_LIMIT
		  jl		 notValid	 ; out of bounds
		  add		 ebx, eax	 ; accumulator stored in ebx
		  loop	 getNums
	 notValid:
		  mov		 edx, OFFSET message_5
		  call	 WriteString
		  call	 CrLf
		  jmp		 getNums
; Display Count and Sum Results
	 done:
		  mov		 count, ecx	 ; move counted number to memory
		  mov		 eax, count
		  mul		 num3
		  mov		 count, eax
		  mov		 sum, ebx	 ; move sum to memory
		  call	 Crlf
		  ; Start Message for Count results
		  mov		 edx, OFFSET message_1
		  call	 WriteString
		  mov		 eax, count
		  call	 WriteDec
		  mov		 edx, OFFSET message_2
		  call	 WriteString
		  mov		 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf
		  ; Start Message for Sum results
		  mov		 edx, OFFSET message_3
		  call	 WriteString
		  mov		 eax, sum
		  call	 WriteInt
		  mov		 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf
; Calculate and Display Rounded Average
		  mov		 edx, 0
		  mov		 eax, sum
		  mov		 ebx, count
		  cmp		 ebx, 0
		  je		 finish			  ; avoid division by 0
		  cdq							  ; convert for signed division
		  idiv	 ebx
		  mov		 average, eax
		  ; Start Message to Display Average
	 finish:
		  mov		 edx, OFFSET message_4
		  call	 WriteString
		  mov		 eax, average
		  call	 WriteInt
		  mov		 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf

; Farewell -- Saying goodbye
		  call	 CrLF
		  mov		 edx, OFFSET farewell_1
		  call	 WriteString
		  call	 CrLF
		  mov		 edx, OFFSET farewell_2
		  call	 WriteString
		  mov		 edx, OFFSET userName
		  call	 WriteString
		  mov		 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf
		  
		  exit	; exit to operating system
main ENDP

END main