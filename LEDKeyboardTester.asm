# File:			LEDKeyboardTesterExtraCredit.asm
# Author:		Aidan Zamboni
# Date:			11/26/2020
# Purpose:	Reads the user input and calls the corresponding function.
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
#						IMPORTANT:	Only works with keyboard and display MMIO simulator.
#						IMPORTANT:	Because I used the keyboard instead of the keypad, it
#												made more sense to change to the following input keys:
#												1 – Turn off LED
#												2 – Turn on LED
#												3 – Toggle LED
#												w – Move the LED up 4 pixels
#												a – Move the LED left 4 pixels
#												s – Move the LED down 4 pixels
#												d – Move the LED right 4 pixels
#												r – Toggles the red color of the LED - NEW
#												g – Toggles the green color of the LED - NEW
#												b – Toggles the blue color of the LED - NEW

.eqv	ONE_KEY				0x00000031
.eqv	TWO_KEY				0x00000032
.eqv	THREE_KEY			0x00000033
.eqv	W_KEY					0x00000077
.eqv	A_KEY					0x00000061
.eqv	S_KEY					0x00000073
.eqv	D_KEY					0x00000064
.eqv	R_KEY					0x00000072
.eqv	G_KEY					0x00000067
.eqv	B_KEY					0x00000062

.text
Main:
	jal InitializeLED
	
	# Load keyboard values
	li $s0, ONE_KEY
	li $s1, TWO_KEY
	li $s2, THREE_KEY
	li $s3, W_KEY
	li $s4, A_KEY
	li $s5, S_KEY
	li $s6, D_KEY
	li $t7, R_KEY
	li $t8, G_KEY
	li $t9, B_KEY
	
Loop:
	# Get key pressed
	jal CheckKeyboard
	move $t0, $v0
	
	# Optionally, display key pressed in hexadecimal
	#move $a0, $v0
	#li $v0, 34
	#syscall
	
	# Check what key was pressed
	beq $t0, $s0, Option_1
	beq $t0, $s1, Option_2
	beq $t0, $s2, Option_3
	beq $t0, $s3, Option_W
	beq $t0, $s4, Option_A
	beq $t0, $s5, Option_S
	beq $t0, $s6, Option_D
	beq $t0, $t7, Option_R
	beq $t0, $t8, Option_G
	beq $t0, $t9, Option_B
	
	b Loop
	
	Option_1:
		jal TurnOnLED
		b Loop
		
	Option_2:
		jal TurnOffLED
		b Loop
		
	Option_3:
		jal ToggleLED
		b Loop
		
	Option_W:
		jal MoveUp
		b Loop
		
	Option_A:
		jal MoveLeft
		b Loop
		
	Option_S:
		jal MoveDown
		b Loop
		
	Option_D:
		jal MoveRight
		b Loop
		
	Option_R:
		jal ToggleRed
		b Loop
		
	Option_G:
		jal ToggleGreen
		b Loop
		
	Option_B:
		jal ToggleBlue
		b Loop
		
CheckKeyboard:
	lui $a3, 0x0000ffff # Load keyboard address
	CheckLoop:
		lw $t1, 0($a3) # Load key press
		andi $t1, $t1, 0x1 # Check if new key press
		beqz $t1, CheckLoop # Restart loop if no new key was pressed
		lw $v0, 4($a3) # Load key press value
		jr $ra

.include "LED.asm"
