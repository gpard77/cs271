TITLE Programming Assignment 1     (prog01_EC.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #1
; Due Date: 10/11/15
; Description:  This program will introduce the programmer, prompt the user for two integers,
;	use those digits for calculation (add, subtract, multiply, divide), and display a sign off message.

INCLUDE Irvine32.inc


.data

num1			DWORD	?			; integer to be entered by user
num2			DWORD ?			; integer to be entered by user
intro_1		BYTE	"Elementary Arithmetic by Geoffrey Pard", 0
intro_2		BYTE	"This is Programming Assignment #1", 0
instruct_1	BYTE  "This program will prompt you for two numbers.", 0
instruct_2	BYTE  "Then it will display various calculations using those numbers.", 0
prompt_1		BYTE	"Enter first number: ", 0
prompt_2		BYTE	"Enter second number: ", 0
prompt_3		BYTE	"Enter 1 to enter new numbers; 0 to quit: ", 0
prompt_4		BYTE	"Would you like to try again?", 0
printAnd		BYTE	" and ", 0
printIs		BYTE	" is ", 0
period		BYTE  ".", 0
value_less	BYTE	"Value must be less than first!", 0
ec_1			BYTE	"**EC: Repeat Until User Quits**", 0
ec_2			BYTE	"**EC: Program Verifies Second Number is Less than First**", 0
sum			DWORD	?
diff			DWORD ?
prod			DWORD ?
quot			DWORD ?
remain		DWORD ?
result_1		BYTE	"Sum of ", 0
result_2		BYTE	"Difference of ", 0
result_3		BYTE  "Product of ", 0
result_4		BYTE	"Quotient of ", 0
result_5		BYTE  " with Remainder ", 0
goodBye		BYTE	"Thanks for participating! Bye!", 0
	
.code
main PROC

; Program Introduction
	mov		edx, OFFSET intro_1
	call		WriteString
	call		CrLf
	mov		edx, OFFSET intro_2
	call		WriteString
	call		CrLf
	mov		edx, OFFSET ec_1
	call		WriteString
	call		CrLf
	mov		edx, OFFSET ec_2
	call		WriteString
	call		CrLf
	call		CrLf

; Program Description and Instructions
	mov		edx, OFFSET instruct_1
	call		WriteString
	call		CrLf
	mov		edx, OFFSET instruct_2
	call		WriteString
	call		CrLf
	call		CrLf

; Prompt User for Integers
again:
	mov		edx, OFFSET prompt_1
	call		WriteString
	call		ReadInt
	mov		num1, eax
	mov		edx, OFFSET prompt_2
	call		WriteString
	call		ReadInt
	mov		num2, eax
	call		CrLf
	call		CrLf

; Validate and Perform Calculations
	; check to see if second number less than first
	mov		eax, num1
	cmp		eax, num2
	jle		fblock
	; Find the Sum
	mov		eax, num1
	mov		ebx, num2
	add		eax, ebx
	mov		sum, eax
	; Find the Difference
	mov		eax, num1
	mov		ebx, num2
	sub		eax, ebx
	mov		diff, eax
	; Find the Product
	mov		eax, num1
	mov		ebx, num2
	mul		ebx
	mov		prod, eax
	; Find the Quotient and Remainder
	mov		edx, 0
	mov		eax, num1
	mov		ebx, num2
	div		ebx
	mov		quot, eax
	mov		remain, edx

; Print Results to Console
	; First, the summation results...
	mov		edx, OFFSET result_1
	call		WriteString
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET printAnd
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET printIs
	call		WriteString
	mov		eax, sum
	call		WriteDec
	mov		edx, OFFSET period
	call		WriteString
	call		CrLf
	; The subtraction results...
	mov		edx, OFFSET result_2
	call		WriteString
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET printAnd
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET printIs
	call		WriteString
	mov		eax, diff
	call		WriteDec
	mov		edx, OFFSET period
	call		WriteString
	call		CrLf
	; The product results...
	mov		edx, OFFSET result_3
	call		WriteString
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET printAnd
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET printIs
	call		WriteString
	mov		eax, prod
	call		WriteDec
	mov		edx, OFFSET period
	call		WriteString
	call		CrLf
	; The quotient and remainder results...
	mov		edx, OFFSET result_4
	call		WriteString
	mov		eax, num1
	call		WriteDec
	mov		edx, OFFSET printAnd
	call		WriteString
	mov		eax, num2
	call		WriteDec
	mov		edx, OFFSET printIs
	call		WriteString
	mov		eax, quot
	call		WriteDec
	mov		edx, OFFSET result_5
	call		WriteString
	mov		eax, remain
	call		WriteDec
	mov		edx, OFFSET period
	call		WriteString
	call		CrLf
	call		CrLf
	jmp		Done
fblock:
	 mov		edx, OFFSET value_less
	 call		WriteString
	 call		CrLf
	 call		CrLf
Done:

; Check to see if user wants to continue
	 mov		edx, OFFSET prompt_4
	 call		WriteString
	 call		CrLf
	 mov		edx, OFFSET prompt_3
	 call		WriteString
	 call		ReadInt
	 call		CrLf
	 mov		ebx, 1
	 cmp		ebx, eax
	 je		again

; Message to User to end program
	mov		edx, OFFSET goodBye
	call		WriteString
	call		CrLf

	exit	; exit to operating system
main ENDP

END main