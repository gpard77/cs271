TITLE Programming Assignment 4     (prog04.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #4
; Due Date: 11/8/15
; Description:  This program prompts a user for a number (n) in a specified range.
; The program will discern the first "n" composite numbers and display them to
; the user.  There is also some minor data validation (checks range).   

INCLUDE Irvine32.inc


.data
UPPER_LIMIT = 400
LOWER_LIMIT = 1
programName		 BYTE		"Welcome To: Composite Numbers -- Assignment 4", 0
author			 BYTE		"Author: Geoffrey Pard", 0
period			 BYTE		". ", 0
space				 BYTE		" ", 0
space_2			 BYTE		"     ", 0
description_1	 BYTE		"How many Composite Numbers would you like to see?", 0
description_2	 BYTE		"Make sure the number is between 1 and 400.", 0
prompt_1			 BYTE		"Enter your number [1, 400]: ", 0
message_1		 BYTE		"The first ", 0
message_2		 BYTE		" composite numbers are as follows: ", 0
message_3		 BYTE		"Number not in range. Please try again.", 0
farewell_1		 BYTE		"This completes the program.  Goodbye", 0
test_1			 BYTE		"From function.", 0
userNum			 DWORD	?
startNum			 DWORD	4
formatNum		 DWORD	9
store	  			 DWORD	?

.code
main PROC
; Display Introduction/Welcome
		  call	 introduction
; Simple Directions
		  call	 directions
; Prompt User for Number of Composites to be shown
		  call	 getUserData
; Validate User Input
		  call	 validate
; Short message/ user input
		  call	 UserInputMessage
; Show Composite Numbers
		  call	 showComposites
; Farewell 
		  call	 farewell
	  
		  exit	; exit to operating system
main ENDP

; This Procedure displays the Program Title and Author
; Registers Used/Changed: EDX
introduction PROC
		  mov		 edx, OFFSET programName
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET author
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf

		  ret
introduction ENDP

; Simple Procedure to alert the user to some basic rules
; Specified range for ints is 1 - 400
; Registers Changed/Used: EDX
directions PROC
		  mov		 edx, OFFSET description_1
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET description_2
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf

		  ret
directions ENDP

; Procedure to Prompt User for Integer Input
; Reads in data; does not validate
; Registers Changed/Used: EAX, EDX
getUserData PROC
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  mov		 userNum, eax

		  ret
getUserData ENDP

; Procedure to Verify correct User Input
; Specified Range for input: 1 - 400 (int)
; two Constants: UPPER_LIMIT gets 400; LOWER_LIMIT gets 1
; Registers Changed/Used: EAX, EDX
validate PROC
	 tryAgain:
		  cmp		 userNum, UPPER_LIMIT
		  jg		 notValid
		  cmp		 userNum, LOWER_LIMIT
		  jl		 notValid
		  jmp		 next_1
	 notValid:		  ; out bounds loop
		  mov		 edx, OFFSET message_3
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  mov		 userNum, eax
		  loop	 tryAgain
	 next_1:

		  ret
validate ENDP

; Simple Procedure used to set up output sequence
; Displays User entered number in a message
; Does not calculate
; Registers Used/Changed: EAX, EDX
userInputMessage PROC
		  call	 CrLf
		  mov		 edx, OFFSET message_1
		  call	 WriteString
		  mov		 eax, userNum
		  call	 WriteDec
		  mov		 edx, OFFSET message_2
		  call	 WriteString
		  call	 CrLf

		  ret
userInputMessage ENDP

; Procedure used to display results
; Uses a counted loop to track numbers
; Nested procedure call "isComposite" calculates numbers
; Formats 10 numbers per line
; Registers Changed/Updated: EAX, ECX
showComposites PROC
		  mov		 ecx, userNum
	 countLoop:
		  call	 isComposite
		  cmp		 formatNum, 0
		  je		 formatting
		  jmp		 next_2
	 formatting:
		  mov		 store, eax
		  mov		 eax, 10
		  mov		 formatNum, eax
		  mov		 eax, store	 
		  call	 CrLf
	 next_2:
		  dec		 formatNum
		  loop	 countLoop

		  ret
showComposites ENDP

; Procedure used to calculate composite numbers
; Numbers divisible by a number other than itself or one
; are written to the console in "showComposites"
; Registers Changed/Used: EAX, EBX, ECX, EDX
isComposite PROC
		  mov		 eax, startNum
		  mov		 ebx, 2
	 findComposite:
		  mov		 edx, 0
		  div		 ebx
		  cmp		 edx, 0
		  je		 compositeTrue
		  inc		 ecx
		  inc		 ebx
		  cmp		 ebx, startNum
		  je		 compositeFalse
		  mov		 eax, startNum
		  loop	 findComposite
	 compositeTrue:
		  mov		 eax, startNum
		  call	 WriteDec
		  mov		 edx, OFFSET space_2
		  call	 WriteString
		  jmp		 done
	 compositeFalse:
		  inc		 formatNum
	 done:
		  inc		 startNum

		  ret
isComposite ENDP

; Procedure to alert user to the end of the program.
; Says Goodbye!
; Registers Changed/Used: EDX
farewell PROC
		  call	 CrLf
		  mov		 edx, OFFSET farewell_1
		  call	 WriteString
		  mov		 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf

		  ret
farewell ENDP

END main