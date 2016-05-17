TITLE Programming Assignment 2     (prog02.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #2
; Due Date: 10/18/15
; Description:  This program prompts a user for number within a specified
; range, the number is validated, and then the user is shown a fibonacci series
; the length of the number provided.  

INCLUDE Irvine32.inc


.data
UPPER_LIMIT = 46
programName		 BYTE		"Welcome To: Fibonacci Numbers -- Assignment 2", 0
author			 BYTE		"Author: Geoffrey Pard", 0
greeting_1		 BYTE		"Please Enter Your Name: ", 0
greeting_2		 BYTE		"Hi, ", 0
greeting_3		 BYTE		"Thanks for stopping by!", 0
period			 BYTE		". ", 0
space				 BYTE		" ", 0
space_2			 BYTE		"     ", 0
description_1	 BYTE		"You will be prompted for a number in the range 1 - 46.", 0
description_2	 BYTE		"The program will then display a fibonacci series using the number provided.", 0
prompt_1			 BYTE		"Enter any number in range [1-46]: ", 0
prompt_2			 BYTE		"Number not in range. Please select again.", 0
message_1		 BYTE		"The Fibonacci Sequence for the first ", 0
message_2		 BYTE		" terms is as follows: ", 0
userName			 BYTE		21 DUP(0)
farewell_1		 BYTE		"This completes the program.", 0
farewell_2		 BYTE		"Goodbye, ", 0
num1				 DWORD	?
num2				 DWORD	0
num3				 DWORD	0
fibs				 DWORD	?
hold_1			 DWORD	?

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
		  call	 CrLF
; Prompt User for Number (Get User Data)
	 start:
		  mov		 ebx, 0
		  cmp		 ebx, num2
		  je		 next
		  mov		 edx, OFFSET prompt_2	 ; error message: out of bounds
		  call	 WriteString
		  call	 CrLF
	 next:
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  mov		 num1, eax
		  inc		 num2
; Validate the number provided is within specified range (Post-Test)
		  cmp		 num1, 1
		  jl		 start
		  cmp		 num1, UPPER_LIMIT
		  jg		 start
; Calculate the Fibonacci Sequence
		  call	 CrLF
		  mov		 edx, OFFSET message_1
		  call	 WriteString
		  mov		 eax, num1
		  call	 WriteDec
		  mov		 edx, OFFSET message_2
		  call	 WriteString
		  call	 CrLF
		  mov		 ecx, num1
		  mov		 eax, 0
		  mov		 ebx, 1
; Display Fibs
	 top:								  ; loop to compute fib series
		  mov		 fibs, eax	 
		  add		 fibs, ebx
		  mov		 eax, ebx
		  call	 WriteDec
		  mov		 edx, OFFSET space_2
		  call	 WriteString
		  inc		 num3				  ; additional counter
		  mov		 edx, 0
		  mov		 hold_1, eax	  ; store eax register contents while performing division
		  mov		 eax, num3
		  mov		 ebx, 5
		  div		 ebx
		  cmp		 edx, 0
		  jne		 cont
		  call	 CrLF			 ; for formatting - skipped unless divisible by 5
	 cont:
		  mov		 ebx, fibs
		  mov		 eax, hold_1	  ; reload eax register to continue loop
		  loop	 top
		  call	 CrLF
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