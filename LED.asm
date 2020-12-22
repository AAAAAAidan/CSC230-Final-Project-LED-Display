# File:			LEDExtraCredit.asm
# Author:		Aidan Zamboni
# Date:			11/26/2020
# Purpose:	Functions for moving and turning an LED light on and off in the bitmap display.
# 					
#						NEW:	I added the option to control the basic RGB color values of
# 								the LED. Using the R, G, and B keys, you can turn the RGB values
# 								on and off. For example, the LED starts at 0xff0000. In other
# 								words, the R value is on and the G and B values are off.
# 								Now say you press G. Now R and G are on, so you get 0xffff00,
# 								or yellow. If all values are turned on, you get white. If all
# 								values are turned off, you get black. The values work with both
# 								the on and off state of the light. Three dots will show on the
# 								top left corner to indicate which values are on.
# 					
# 					NEW FUNCTIONS:	ToggleRed, ToggleGreen, ToggleBlue.
# 													There is also some code added to DrawLED, you can find it
#														on line 439 at the bottom of the file.
# 					
# The Bitmap Display will be stored in the Heap starting at Address 0x10040000.
# The Unit Width and Height in Pixels will be 8.
# The Display Width and Height will be 512 Pixels.
# The LED will be centered in the upper middle.

.data
# Instance Data
	BaseAddress:	.word 0x10040000	# Bse address of display matrix
	State:				.word 0x01				# Starts with LED on 
	Start:				.word 4208				# Where the LED drawing starts on the bitmap
	OnColor:			.word	0X00ff0000
	OffColor:			.word	0X00770000
	OnGrey:				.word	0X00bababa
	OffGrey:			.word	0X00404040
	White:				.word	0X00ffffff
	Black:				.word	0X00000000
	
 # Subprogram: InitializeLED
 .text
 InitializeLED:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack
	
	# LOGIC 
	# Allocate 4096 bytes of memory in heap using the syscall #9
	li $a0, 4096
	li $v0, 9
	syscall
	
	# Draw the LED using the bitmap dispay martix
	jal DrawLED
	
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	
 # Subprogram TurnOnLED
 .text
 TurnOnLED:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack
	
	#LOGIC
	# Update the state to 0 and then draw the LED in an ON State
	li $t0, 1
	sw $t0, State
	jal DrawLED
	
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
 
 
 
 
 # Subprogram TurnOffLED
 .text
 TurnOffLED:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	# Update the state to 0 and then draw the LED in an OFF State
	li $t0, 0
	sw $t0, State
	jal DrawLED

	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram ToggleLED
 .text
 ToggleLED:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
 	# Get the current state
	lw $t0, State
	beq $t0, $zero, Switch_On
	
	# If light is on, turn it off
	jal TurnOffLED
	b End_Switch_If
	
	# Else if light is off, turn it on
	Switch_On:
		jal TurnOnLED
	End_Switch_If:
	
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram MoveUp
 .text
 MoveUp:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, Start # Starting address offset
	li $t1, 256 # Minimum offset
	
	# Check if the address is out of bounds
	blt $t0, $t1, Skip_Up
	
	# Up by one row
	subi $t0, $t0, 256
	
	# Update the starting address offset and draw the LED in the new position
	sw $t0, Start
	jal DrawLED

Skip_Up:
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram MoveLeft
 .text
 MoveLeft:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, Start # Starting address offset
	li $t1, 256 # Pixels in a row
	
	div $t0, $t1 # Divide start offset by 256
	mfhi $t3 # If remainder is zero, then current column is 1
	
	# Check if the address is out of bounds
	beq $t3, $zero, Skip_Left
	
	# Left by one column
	subi $t0, $t0, 4
	
	# Update the starting address offset and draw the LED in the new position
	sw $t0, Start
	jal DrawLED

Skip_Left:
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram MoveDown
 .text
 MoveDown:
	# Prologue: save the $ra
	addi $sp, $sp, -4	 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, Start # Starting address offset
	li $t1, 14332 # Maximum offset
	
	# Check if the address is out of bounds
	bgt $t0, $t1, Skip_Down
	
	# Down by one row
	addi $t0, $t0, 256
	
	# Update the starting address offset and draw the LED in the new position
	sw $t0, Start
	jal DrawLED

Skip_Down:
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram MoveRight
 .text
 MoveRight:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, Start # Starting address offset
	li $t1, 256 # Pixels in a row
	
	div $t0, $t1 # Divide start offset by 256
	mfhi $t3 # If remainder is greater than, then current column is at the edge
	
	li $t4, 220 # Maximum column in a row
	
	# Check if the address is out of bounds
	bgt $t3, $t4, Skip_Left
	
	# Right by one column
	addi $t0, $t0, 4
	
	# Update the starting address offset and draw the LED in the new position
	sw $t0, Start
	jal DrawLED

Skip_Right:
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram ToggleRed - NEW
 .text
 ToggleRed:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, OnColor # On state color
	lw $t1, OffColor # Off state color
	
	# Toggle the red in the colors
	xori $t0, $t0, 0X00ff0000
	xori $t1, $t1, 0X00770000
	
	# Update the state colors and draw the LED
	sw $t0, OnColor
	sw $t1, OffColor
	jal DrawLED

	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram ToggleGreen - NEW
 .text
 ToggleGreen:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, OnColor # On state color
	lw $t1, OffColor # Off state color
	
	# Toggle the green in the colors
	xori $t0, $t0, 0X0000ff00
	xori $t1, $t1, 0X00007700
	
	# Update the state colors and draw the LED
	sw $t0, OnColor
	sw $t1, OffColor
	jal DrawLED

	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram ToggleBlue - NEW
 .text
 ToggleBlue:
	# Prologue: save the $ra
	addi $sp, $sp, -4 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack

	# LOGIC
	lw $t0, OnColor # On state color
	lw $t1, OffColor # Off state color
	
	# Toggle the blue in the colors
	xori $t0, $t0, 0X000000ff
	xori $t1, $t1, 0X00000077
	
	# Update the state colors and draw the LED
	sw $t0, OnColor
	sw $t1, OffColor
	jal DrawLED

	# Epilogue: pop the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra




 # Subprogram: DrawLED
 .text
 DrawLED:
	# Prologue: Good idea to save the $ra just in case
	addi $sp, $sp, -28 # Make room for return address on stack
	sw $ra, 0($sp) # Store return address on stack
	sw $s0, 4($sp) # Store s registers
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	lw $s0, BaseAddress # Address of heap 
	lw $s1, State # Current state
	lw $s2, Start # Starting location for the LED drawing on the bitmap
	
	# Check the current state
	beq $s1, $zero, Draw_Off
	
	# If light is on, load bright colors
	lw $s3, OnColor
	lw $s4, OnGrey
	lw $s5, White
	b End_Draw_If
	
	# Else if light is off, load dark colors
	Draw_Off:
		lw $s3, OffColor
		lw $s4, OffGrey
		lw $s5, Black
	End_Draw_If:
	
	li $t0, 0 # Unit counter
	li $t2, 4096 # Max units in bitmap
	
	# Blanks the entire bitmap to either black or white
	Reset_Bitmap:
		sw $s5, 0($s0)	# Black or white
		addi $s0, $s0, 4 # Next column
		addi $t0, $t0, 1 # Increment counter
		beq $t0, $t2, End_Reset_Bitmap
		b Reset_Bitmap
	End_Reset_Bitmap:
	
	lw $s0, BaseAddress # Address of heap 
	add $s0, $s0, $s2 # Add starting address to heap address
	
	li $t0, 0 # Row counter
	li $t1, 0 # Column counter
	li $t2, 8 # Max column/row
	
	# Draw a square where the LED will be
	Draw:
		li $t1, 0 # Reset column counter
		
		Draw_Row:
			sw $s3, 0($s0)	# Red
			addi $t1, $t1, 1 # Increment column counter
			beq $t1, $t2, End_Draw_Row
			addi $s0, $s0, 4 # Next column
			b Draw_Row
		End_Draw_Row:
		
		addi $t0, $t0, 1 # Increment row counter
		beq $t0, $t2, End_Draw
		addi $s0, $s0, 228 # Next row
		b Draw
	End_Draw:
	
	# Draw the details of the LED
	lw $s0, BaseAddress # Reset address of heap
	add $s0, $s0, $s2 # Add starting address to heap address
	sw $s5, 0($s0)	# Black or white
	sw $s5, 4($s0)
	sw $s5, 24($s0)
	sw $s5, 28($s0)
	addi $s0, $s0, 256 # Go to second row
	sw $s5, 0($s0)
	sw $s5, 28($s0)
	addi $s0, $s0, 256 # Go to third row
	sw $s5, 0($s0)
	sw $s5, 28($s0)
	addi $s0, $s0, 768 # Go to sixth row
	sw $s4, 8($s0) # Grey
	sw $s4, 12($s0)
	sw $s4, 16($s0)
	sw $s4, 20($s0)
	addi $s0, $s0, 256 # Go to seventh row
	sw $s4, 8($s0)
	sw $s4, 20($s0)
	addi $s0, $s0, 256 # Go to eighth row
	sw $s4, 8($s0)
	sw $s4, 20($s0)
	
	# Draw the color state markers - NEW
	lw $s0, BaseAddress # Reset address of heap
	andi $t3, $s3, 0x00ff0000
	andi $t4, $s3, 0x0000ff00
	andi $t5, $s3, 0x000000ff
	sw $t3, 0($s0)
	sw $t4, 256($s0)
	sw $t5, 512($s0)
	
	# Epilogue: pop the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra
