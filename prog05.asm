TITLE Programming Assignment 5     (prog05.asm)

; Author: Geoffrey Pard
; Email: pardg@oregonstate.edu
; Course: CS 271 - 400            
; Assignment: Programming Assignment #5
; Due Date: 11/22/15
; Description:  This program prompts a user for a number (n) in a specified range.
; The program will then display 'n' random numbers.  It will then calculate the
; median value, sort the list, and re-dispaly. There is also some minor data validation (checks range).   

INCLUDE Irvine32.inc


.data
MIN = 10
MAX = 200
LO = 100
HI = 999
programName		 BYTE		"Welcome To: Sorting Random Integers -- Assignment 5", 0
author			 BYTE		"Author: Geoffrey Pard", 0
period			 BYTE		". ", 0
space				 BYTE		" ", 0
space_2			 BYTE		"   ", 0
description_1	 BYTE		"This Program shows you random integers.", 0
description_2	 BYTE		"It calculates a median value, sorts the list, ", 0
description_3	 BYTE		"and re-displays the list in descending order.", 0
description_4	 BYTE		"You will be prompted for an amount of numbers to display.", 0
description_5	 BYTE		"Make sure the number is between 10 and 200.", 0
prompt_1			 BYTE		"Enter your number [10, 200]: ", 0
message_1		 BYTE		"Before Sort, the Array Elements are as follows: ", 0
message_2		 BYTE		"The Sorted Array Elements are as follows: ", 0
message_3		 BYTE		"Number not in range. Please try again.", 0
message_4		 BYTE		"The Median of the Array is ", 0
farewell_1		 BYTE		"This completes the program.  Goodbye", 0
userNum			 DWORD	?
randomArray		 DWORD	MAX DUP(?)

.code
main PROC
; Display Introduction/Welcome
		  call	 introduction
; Simple Directions
		  call	 directions
; Get data from the User
		  push	 OFFSET userNum
		  call	 getData
; Validate User Input
		  push	 OFFSET userNum
		  call	 validate
; Fill Array with Random Values
		  call	 Randomize
		  push	 OFFSET randomArray
		  push	 userNum
		  call	 fillArray
; Display the Elements of the Array (PRE-SORTED)
		  call	 CrLf
		  push	 OFFSET randomArray
		  push	 userNum
		  push	 OFFSET message_1
		  call	 displayList
; Sort the Elements in the Array
		  push	 OFFSET randomArray
		  push	 userNum
		  call	 sortList
; Display Median of the Values in the Array
		  call	 CrLf
		  push	 OFFSET randomArray
		  push	 userNum
		  call	 displayMedian
; Display the Elements of the Array (SORTED)
		  call	 CrLf
		  push	 OFFSET randomArray
		  push	 userNum
		  push	 OFFSET message_2
		  call	 displayList
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
		  mov		 edx, OFFSET programName
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET author
		  call	 WriteString
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
		  mov		 edx, OFFSET description_1
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf
		  mov		 edx, OFFSET description_2
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET description_3
		  call	 WriteString
		  call	 CrLf
		  call	 CrLf
		  mov		 edx, OFFSET description_4
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET description_5
		  call	 WriteString
		  call	 CrLf

		  ret
directions ENDP

;*****************************************************
;                 getData
; Procedure to Prompt User for Integer Input
; Reads in data; does not validate
; Registers Changed/Used: EBX, EDX
;*****************************************************
getData PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  mov		 ebx, [ebp+8]
		  mov		 [ebx], eax
		  pop		 ebp

		  ret		 4
getData ENDP

;*****************************************************************
;                     validate
; Procedure to Verify correct User Input
; Specified Range for input: 10 - 200 (DWORD)
; two Constants: MAX gets 200; MIN gets 10
; Registers Changed/Used: EAX, EBX, ECX, EDX
;*****************************************************************
validate PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 ebx, [ebp+8]
		  mov		 ecx, [ebx]
	 tryAgain:
		  cmp		 ecx, MAX
		  jg		 notValid
		  cmp		 ecx, MIN
		  jl		 notValid
		  jmp		 next_1
	 notValid:		  ; out bounds loop
		  mov		 edx, OFFSET message_3
		  call	 WriteString
		  call	 CrLf
		  mov		 edx, OFFSET prompt_1
		  call	 WriteString
		  call	 ReadInt
		  mov		 ebx, [ebp+8]
		  mov		 [ebx], eax
		  mov		 ecx, [ebx]
		  inc		 ecx
		  loop	 tryAgain

	 next_1:
		  pop		 ebp

		  ret		 4
validate ENDP

;************************************************************
;                     fillArray
; Procedure used to fill an array with random numbers
; Elements in Array dictated by User Input
; Random Seed called in Main Proc
; Registers Used/Changed: EAX, ECX
;*************************************************************
fillArray PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 esi, [ebp+12]
		  mov		 ecx, [ebp+8]
	 fill:
		  ; Create Random numbers within specified range
		  ; based on code from lecture slides
		  mov		 eax, hi
		  sub		 eax, lo
		  inc		 eax
		  call	 RandomRange
		  add		 eax, lo
		  mov		 [esi], eax		  ; place value in array slot
		  add		 esi, 4			  ; move to next "subscript"
		  loop	 fill
		  pop		 ebp

		  ret		 8
fillArray ENDP

;***************************************************************
;                    displayList
; This procedure is called in order to show the contents of the
; array.  Proc does no sorting; shows ten numbers per line
; Registers Changed/Updated: EAX, EBX, ECX, EDX
;***************************************************************
displayList PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 edx,	[ebp+8]					  ; title of display
		  call	 WriteString
		  call	 CrLf
		  mov		 esi, [ebp+16]					  ; address of array
		  mov		 ecx, [ebp+12]					  ; number of elements in array
		  mov		 ebx, 9							  ; for line formatting
	 display_next:
		  mov		 eax, [esi]						  ; current array element
		  call	 WriteDec
		  mov		 edx, OFFSET space_2			  ; line formatting
		  call	 WriteString
		  add		 esi, 4							  ; next element in array (DWORD(s))
		  cmp		 ebx, 0
		  jnz		 no_line
		  call	 CrLf
		  mov		 ebx, 10
	 no_line:
		  dec		 ebx
		  loop	 display_next
		  call	 CrLf
		  pop		 ebp

		  ret		 12
displayList ENDP

;***************************************************************
;                        displayMedian
; This procedure calculates and displays the median value of 
; an array passed in by reference. Arrays with an even number of
; elements will have the values of the middle two elements 
; averaged.
; Registers Used/Changed: EAX, EBX, EDX
;***************************************************************
displayMedian PROC
		  push	 ebp
		  mov		 ebp, esp
		  mov		 esi, [ebp+12]				 ; address of array
		  mov		 eax, [ebp+8]				 ; number of array elements
		  ; determine if # of elements is even or odd
		  mov		 edx, 0
		  mov		 ebx, 2
		  div		 ebx
		  cmp		 edx, 0
		  jz		 isEven
		  jnz		 isOdd
	 isEven:
		  dec		 eax
		  mov		 ebx, 4						 ; moving by DWORD 
		  mul		 ebx							 ; (userNum - 1) * 4 bytes
		  add		 esi, eax					 ; beginning array address plus distance
		  mov		 eax, [esi]					 ; retrieve value
		  add		 esi, 4						 ; move up one element
		  add		 eax,	[esi]					 ; sum both retrieved elements
		  mov		 ebx, 2
		  mov		 edx, 0
		  div		 ebx							 ; find average
		  jmp		 print_message
	 isOdd:
		  mov		 ebx, 4						 ; moving by DWORD
		  mul		 ebx							 ; odd numbers truncated, mul by 4 bytes
		  add		 esi, eax					 ; beginning array address plus distance
		  mov		 eax, [esi]					 ; retrieve middle element
	 print_message:
		  mov		 edx, OFFSET message_4
		  call	 WriteString
		  call	 WriteDec
		  mov	 edx, OFFSET period
		  call	 WriteString
		  call	 CrLf

		  pop		 ebp

		  ret		 8
displayMedian ENDP

;***************************************************************
;                       sortList
; This Procedure uses the bubble sort method to arrange
; array elements in descending order. Based on code listed
; in the textbook.
; Registers Changed/Used: EAX, ECX
;***************************************************************
sortList PROC
		  push	 ebp
		  mov		 ebp, esp
		 
		  mov		 ecx, [ebp+8]
		  dec		 ecx
	 outer_loop:
		  push	 ecx
		  mov		 esi, [ebp+12]
	 inner_loop1:
		  mov		 eax, [esi]
		  cmp		 [esi+4], eax
		  jl		 inner_loop2				 ; sort descending order
		  xchg	 eax, [esi+4]
		  mov		 [esi], eax
	 inner_loop2:
		  add		 esi, 4
		  loop	 inner_loop1
		  pop		 ecx
		  loop	 outer_loop

		  pop		 ebp

		  ret		 8
sortLIST ENDP

;*****************************************************************
;                    farewell
; Procedure to alert user to the end of the program.
; Says Goodbye!
; Registers Changed/Used: EDX
;****************************************************************
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