#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Christian Sas, 1007997651, saschris, chris.sas@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health system (2 marks)
# 2. Fail Condition (1 mark)
# 3. Win Condition (1 mark)
# 4. Moving minecart (2 marks)
# 5. Disappearing platform (1 mark)
# 6. Different levels (2 marks)
# 
#
# Link to video demonstration for final submission:
# - https://youtu.be/2xz17oNKD2I
#
# Are you OK with us sharing the video with people outside course staff?
# - yes
# github: https://github.com/Chris-Sas/b58FinalProject
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
.eqv BASE_ADDRESS 0x10008000
.eqv GREEN 0x00ff00
.eqv RED 0xff0000
.eqv BLACK 0x000000
.eqv GRAY 0x484848
.eqv WHITE 0xffffff
.eqv BROWN 0x5d2b00
.eqv BLUE 0x060e57
.eqv LIGHTBLUE 0x9cfadb
.eqv TAN 0xd1b69e
.eqv DIRT 0x231204
.eqv PLATFORM 0xda873f
.eqv SOLIDPLATFORM 0x999999
.eqv LADDER 0x885225
.eqv BOOTS 0x550861
.eqv ORANGE 0xf48d31
.eqv YELLOW 0xffec1f
.eqv GRASS 0x99ff00
.eqv DRESS 0xf79aff

.data
	CHAR_LOCATION: 0x10008000
	CART_LOCATION: 0x10008000
	END: .word 1
.text
# $s3 is number of lives
# $s4 is boots
# $s5 is background colour
# $s6 is number of jumps
# $s7 is level
start0:
	li $t7, 7580 # $t7 is moving platform for level 1
	li $t6, -4
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $s5, DIRT 
	la $t1, ($s5)
	li $t2, 4
	addi $t3, $t0, 16384
	jal fill
	
	lw $t0, CHAR_LOCATION
	addi $t0, $t0, 16128
	sw $t0, CHAR_LOCATION
	
	jal draw_char
	li $s7, 0	# $s7 holds value of current level
	li $s3, 3
	j main
start1:
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $s5, 0x372515
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	
	lw $t0, CART_LOCATION
	addi $t0, $t0, 9612
	sw $t0, CART_LOCATION
	
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 16128
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $s7, 1	# $s7 holds value of current level
	
	beq $s4 $zero, spawnBoots
	j main
start2:
	li $t7, 20 # $t7 is disappearing platform for level 3
	li $t6, 1
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $s5, 0x282828 
	la $t1, ($s5)
	li $t2, 4
	addi $t3, $t0, 16384
	jal fill
	
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 16128
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $s7, 2	# $s7 holds value of current level
	j main
start3:
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $s5, 0x44eaff 
	la $t1, ($s5)
	li $t2, 4
	addi $t3, $t0, 16384
	jal fill
	
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 16128
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $s7, 3	# $s7 holds value of current level
	j main
spawnBoots:
	li $t0, BASE_ADDRESS
	jal draw_boots
	j main
main:
	lw $t1, END
	beqz $t1, EXIT
	
	beq $s7, 0, lvl1
	beq $s7, 1, lvl2
	beq $s7, 2, lvl3
	beq $s7, 3, lvl4
key:	
	lw $t1, 4($t9)
	beq $t1, 100, moveRight 
	beq $t1, 97, moveLeft 
	beq $t1, 119, moveUp
	beq $t1, 115, moveDown  
	beq $t1, 112, p
	j main

moveUp:
	jal checkExit
	bne $t1, 119, moveLeft
	bne $s1, $zero, moveLeft
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5888
	blt $t0, $t3, moveLeft
	subi $t0, $t0, 3072
	sw $t0, CHAR_LOCATION
	
	sw $s5, -2020($t0)
	sw $s5, -2276($t0)
	sw $s5, 256($t0)
	sw $s5, 260($t0)
	sw $s5, 264($t0)
	sw $s5, 268($t0)
	sw $s5, 272($t0)
	sw $s5, 276($t0)
	sw $s5, 280($t0)
	sw $s5, 512($t0)
	sw $s5, 516($t0)
	sw $s5, 520($t0)
	sw $s5, 524($t0)
	sw $s5, 528($t0)
	sw $s5, 532($t0)
	sw $s5, 536($t0)
	sw $s5, 768($t0)
	sw $s5, 772($t0)
	sw $s5, 776($t0)
	sw $s5, 780($t0)
	sw $s5, 784($t0)
	sw $s5, 788($t0)
	sw $s5, 792($t0)
	sw $s5, 1024($t0)
	sw $s5, 1028($t0)
	sw $s5, 1032($t0)
	sw $s5, 1036($t0)
	sw $s5, 1040($t0)
	sw $s5, 1044($t0)
	sw $s5, 1048($t0)
	sw $s5, 1280($t0)
	sw $s5, 1284($t0)
	sw $s5, 1288($t0)
	sw $s5, 1292($t0)
	sw $s5, 1296($t0)
	sw $s5, 1300($t0)
	sw $s5, 1304($t0)
	sw $s5, 1536($t0)
	sw $s5, 1540($t0)
	sw $s5, 1544($t0)
	sw $s5, 1548($t0)
	sw $s5, 1552($t0)
	sw $s5, 1556($t0)
	sw $s5, 1560($t0)
	sw $s5, 1564($t0)
	sw $s5, 1792($t0)
	sw $s5, 1796($t0)
	sw $s5, 1800($t0)
	sw $s5, 1804($t0)
	sw $s5, 1808($t0)
	sw $s5, 1812($t0)
	sw $s5, 1816($t0)
	sw $s5, 1820($t0)
	sw $s5, 2048($t0)
	sw $s5, 2052($t0)
	sw $s5, 2056($t0)
	sw $s5, 2060($t0)
	sw $s5, 2064($t0)
	sw $s5, 2068($t0)
	sw $s5, 2072($t0)
	sw $s5, 2076($t0)
	sw $s5, 3072($t0)
	sw $s5, 3076($t0)
	sw $s5, 3080($t0)
	sw $s5, 3084($t0)
	sw $s5, 3088($t0)
	sw $s5, 3092($t0)
	sw $s5, 3096($t0)
	sw $s5, 3100($t0)
	sw $s5, 2560($t0)
	sw $s5, 2564($t0)
	sw $s5, 2568($t0)
	sw $s5, 2572($t0)
	sw $s5, 2576($t0)
	sw $s5, 2580($t0)
	sw $s5, 2584($t0)
	sw $s5, 2588($t0)
	sw $s5, 2816($t0)
	sw $s5, 2820($t0)
	sw $s5, 2824($t0)
	sw $s5, 2828($t0)
	sw $s5, 2832($t0)
	sw $s5, 2836($t0)
	sw $s5, 2840($t0)
	sw $s5, 2844($t0)
	sw $s5, 2304($t0)
	sw $s5, 2308($t0)
	sw $s5, 2312($t0)
	sw $s5, 2316($t0)
	sw $s5, 2320($t0)
	sw $s5, 2324($t0)
	sw $s5, 2328($t0)
	beq $s4, 1, highJump
	j moveLeft
highJump:
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5888
	blt $t0, $t3, moveLeft
	subi $t0, $t0, 2048
	sw $t0, CHAR_LOCATION
	sw $s5, 256($t0)
	sw $s5, 260($t0)
	sw $s5, 264($t0)
	sw $s5, 268($t0)
	sw $s5, 272($t0)
	sw $s5, 276($t0)
	sw $s5, 280($t0)
	sw $s5, 512($t0)
	sw $s5, 516($t0)
	sw $s5, 520($t0)
	sw $s5, 524($t0)
	sw $s5, 528($t0)
	sw $s5, 532($t0)
	sw $s5, 536($t0)
	sw $s5, 540($t0)
	sw $s5, 768($t0)
	sw $s5, 772($t0)
	sw $s5, 776($t0)
	sw $s5, 780($t0)
	sw $s5, 784($t0)
	sw $s5, 788($t0)
	sw $s5, 792($t0)
	sw $s5, 796($t0)
	sw $s5, 1024($t0)
	sw $s5, 1028($t0)
	sw $s5, 1032($t0)
	sw $s5, 1036($t0)
	sw $s5, 1040($t0)
	sw $s5, 1044($t0)
	sw $s5, 1048($t0)
	sw $s5, 1052($t0)
	sw $s5, 1280($t0)
	sw $s5, 1284($t0)
	sw $s5, 1288($t0)
	sw $s5, 1292($t0)
	sw $s5, 1296($t0)
	sw $s5, 1300($t0)
	sw $s5, 1304($t0)
	sw $s5, 1308($t0)
	sw $s5, 1536($t0)
	sw $s5, 1540($t0)
	sw $s5, 1544($t0)
	sw $s5, 1548($t0)
	sw $s5, 1552($t0)
	sw $s5, 1556($t0)
	sw $s5, 1560($t0)
	sw $s5, 1564($t0)
	sw $s5, 1792($t0)
	sw $s5, 1796($t0)
	sw $s5, 1800($t0)
	sw $s5, 1804($t0)
	sw $s5, 1808($t0)
	sw $s5, 1812($t0)
	sw $s5, 1816($t0)
	sw $s5, 1820($t0)
	sw $s5, 2048($t0)
	sw $s5, 2052($t0)
	sw $s5, 2056($t0)
	sw $s5, 2060($t0)
	sw $s5, 2064($t0)
	sw $s5, 2068($t0)
	sw $s5, 2072($t0)
	
moveLeft:
	bne $t1, 97, moveDown
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	sub $t5, $t0, $t3
	li $t4, 256
	div $t5, $t4
	mfhi $t3
	beqz $t3, moveDown
	subi $t0, $t0, 4
	sw $t0, CHAR_LOCATION
	
	sw $s5, 32($t0)
	sw $s5, -224($t0)
	sw $s5, -480($t0)
	sw $s5, -740($t0)
	sw $s5, -996($t0)
	sw $s5, -1252($t0)
	sw $s5, -1508($t0)
	sw $s5, -1764($t0)
	sw $s5, -2020($t0)
	sw $s5, -2276($t0)
	sw $s5, -2532($t0)
	sw $s5, -2788($t0)
	sw $s5, -3044($t0)
	sw $s5, -3300($t0)
	sw $s5, -3556($t0)
	sw $s5, -3816($t0)
	sw $s5, -4076($t0)
	sw $s5, -4328($t0)
	sw $s5, -4580($t0)
	sw $s5, -4836($t0)
	sw $s5, -5088($t0)
	sw $s5, -5344($t0)
	sw $s5, -5604($t0)
	
moveDown:
	jal checkSolidPlatformVertical
	beq $s7, 3, moveRight
	bne $t1, 115, moveRight
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 16124
	bgt $t0, $t3, moveRight
	
	sw $s5, -3836($t0)
	sw $s5, -3820($t0)
	sw $s5, -3584($t0)
	sw $s5, -3560($t0)
	sw $s5, -484($t0)
	sw $s5, -5376($t0)
	sw $s5, -5628($t0)
	sw $s5, -5624($t0)
	sw $s5, -5620($t0)
	sw $s5, -5616($t0)
	sw $s5, -5612($t0)
	sw $s5, -5608($t0)
	sw $s5, -5348($t0)
	addi $t0, $t0, 256
	sw $t0, CHAR_LOCATION
	
moveRight:
	jal checkSolidPlatformHorizontal
	bne $t1, 100, p
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	sub $t5, $t0, $t3
	addi $t5, $t5, 32
	li $t4, 256
	div $t5, $t4
	mfhi $t3
	beqz $t3, draw_char_main
	
	sw $s5, 0($t0)
	sw $s5, -256($t0)
	sw $s5, -512($t0)
	sw $s5, -768($t0)
	sw $s5, -1024($t0)
	sw $s5, -1280($t0)
	sw $s5, -1536($t0)
	sw $s5, -1792($t0)
	sw $s5, -2048($t0)
	sw $s5, -2304($t0)
	sw $s5, -2560($t0)
	sw $s5, -2816($t0)
	sw $s5, -3072($t0)
	sw $s5, -3328($t0)
	sw $s5, -3584($t0)
	sw $s5, -3840($t0)
	sw $s5, -3836($t0)
	sw $s5, -4096($t0)
	sw $s5, -4092($t0)
	sw $s5, -4088($t0)
	sw $s5, -4352($t0)
	sw $s5, -4608($t0)
	sw $s5, -4864($t0)
	sw $s5, -5120($t0)
	sw $s5, -5376($t0)
	sw $s5, -5632($t0)
	sw $s5, -5628($t0)
	
	addi $t0, $t0, 4
	sw $t0, CHAR_LOCATION
p:
	bne $t1, 0x70, draw_char_main
	li $s4, 0
	li $t0, BASE_ADDRESS
	sw $t0, CART_LOCATION
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	j start0
	
draw_char_main:
	lw $t0, CHAR_LOCATION
	li $s0, 0
	jal draw_char
	li $t3, 128

loopmain:
	li $v0, 32
	li $a0, 32
	syscall
	
	li $t0, BASE_ADDRESS
	bge $s3, 1, life1
	j gameover
life1:
	jal draw_heart
	bge $s3, 2, life2
	j displayedLives
life2:
	addi $t0, $t0, 24
	jal draw_heart
	bge $s3, 3, life3
	j displayedLives
life3:
	addi $t0, $t0, 24
	jal draw_heart
displayedLives:	
	li $s1, 0
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 16124
	bgt $t0, $t3, main
loop0:
	bne $s7, 0, loop1
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13872
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 11884
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 9784
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	li $s6, 0
	subi $s6, $t7, 272
	add $t3, $t3, $s6
	li $t1, 100
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5804
	li $t1, 64
	jal checkPlatform
loop1:
	bne $s7, 1, loop2
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13872
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 9468
	li $t1, 256
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5680
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5804
	li $t1, 64
	jal checkPlatform
loop2:
	bne $s7, 2, loopEnd
	bge $t7, 20, platformExists
	j platformDne
platformExists:
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13888
	li $t1, 100
	jal checkPlatform
platformDne:
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13840
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 10868
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5796
	li $t1, 64
	jal checkPlatform
	
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 7808
	li $t1, 64
	jal checkPlatform
loopEnd:
	li $s1, 1
	sw $s5, -3836($t0)
	sw $s5, -3820($t0)
	sw $s5, -3584($t0)
	sw $s5, -3560($t0)
	sw $s5, -484($t0)
	sw $s5, -5376($t0)
	sw $s5, -5628($t0)
	sw $s5, -5624($t0)
	sw $s5, -5620($t0)
	sw $s5, -5616($t0)
	sw $s5, -5612($t0)
	sw $s5, -5608($t0)
	sw $s5, -5348($t0)
	addi $t0, $t0, 256
	sw $t0, CHAR_LOCATION
	jal draw_char
	
	j main

fill:
	beq $t0, $t3, return
	sw $t1, 0($t0)
	add $t0, $t0, $t2
	j fill
	
fillLong:
	beq $t0, $t3, return
	li $v0, 32
	li $a0, 1
	syscall
	sw $t1, 0($t0)
	add $t0, $t0, $t2
	j fillLong

checkCartCollision:
	lw $t0, CHAR_LOCATION
	lw $t1, CART_LOCATION
	addi $t0, $t0 24
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	
	lw $t0, CHAR_LOCATION
	lw $t1, CART_LOCATION
	addi $t1, $t1, 36
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, -512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 512
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 512
	beq $t0, $t1, resetLevel1

	lw $t0, CHAR_LOCATION
	lw $t1, CART_LOCATION
	addi $t1, $t1, -2048
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	
	lw $t0, CHAR_LOCATION
	addi $t0, $t0, 24
	lw $t1, CART_LOCATION
	addi $t1, $t1, -2048
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	
	lw $t0, CHAR_LOCATION
	lw $t1, CART_LOCATION
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1
	addi $t1, $t1, 4
	beq $t0, $t1, resetLevel1

	lw $t0, CHAR_LOCATION
	subi $t7, $t7, 256 
	subi $t0, $t0, 256
	sw $t0, CHAR_LOCATION
	bne $t7, 0, checkCartCollision
	lw $t0, CHAR_LOCATION
	addi $t0, $t0, 5888
	sw $t0, CHAR_LOCATION
	j noReset1

checkSolidPlatformHorizontal:
	bne $s7, 2, return
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 16144
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13940
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 10916
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	subi $t3, $t3, 256
	beq $t0, $t3, lvl3
	j return
checkSolidPlatformVertical:
	bne $s7, 2, return
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13840
	bge $t0, $t3, checkFirst
	j checkSecond
checkFirst:
	addi $t3, $t3, 64
	ble $t0, $t3, lvl3
checkSecond:
	ble $t7, 19, checkThird 
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 13888
	ble $t0, $t3, checkThird
	addi $t3, $t3, 100
	bge $t0, $t3, checkThird
	j lvl3
checkThird:
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 10868
	ble $t0, $t3, checkFourth
	addi $t3, $t3, 64
	bge $t0, $t3, checkFourth
	j lvl3
checkFourth:
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 5796
	ble $t0, $t3, return
	addi $t3, $t3, 64
	bge $t0, $t3, return
	j lvl3

checkPlatform:
	beq $t1, $zero, return
	addi $t3, $t3, 4 
	subi $t1, $t1, 4
	beq $t0, $t3, main
	j checkPlatform

checkBoots:
	beq $s4, 1, noBoots
	lw $t0, CHAR_LOCATION
	bge $t0, 268484500, checkBootsTrue
	j boots
checkBootsTrue:
	bge $t0, 268484576, return
	li $s4, 1
	li $t0, BASE_ADDRESS 
	li $s5, WHITE
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	li $v0, 32
	li $a0, 200
	syscall
	li $t0, BASE_ADDRESS 
	li $s5, 0x372515
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	j boots
	
checkExit:
	beq $s7, 0, check1
	beq $s7, 1, check1
check1:
	lw $t0, CHAR_LOCATION
	bge $t0, 268474048, checkTrue
	j return
checkTrue:
	bge $t0, 268474080, return
	j nextLevel
	
flip:
	mul $t6, $t6, -1 
	mflo $t6
	j main
	
return: jr $ra

nextLevel:
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $t1, BLACK 
	li $t2, 4
	addi $t3, $t0, 16384
	jal fillLong
	
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	lw $t0, CHAR_LOCATION
	addi $t0, $t0, 16384
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 5376
	li $t4, 5376 
charSlide:
	beq $t4, 0, nextLevelFinish
	li $v0, 32
	li $a0, 2
	syscall
	subi $t4, $t4, 256
	subi $t0, $t0, 256
	jal draw_char
	j charSlide
nextLevelFinish:
	subi $t0, $t0, 1024
	jal draw_char
	addi $s7, $s7, 1
	beq $s7, 1, start1
	beq $s7, 2, start2
	beq $s7, 3, start3
	
lvl1:
	li $t0, BASE_ADDRESS # platform 1
	addi $t0, $t0, 14144
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	li $t0, BASE_ADDRESS # platform 2
	addi $t0, $t0, 12156
	addi $t3, $t0, 64
	jal fill
	
	li $t0, BASE_ADDRESS # platform 3
	addi $t0, $t0, 10056
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	# moving platform
	add $t7, $t7, $t6
	beq $t7, 7584, flip
	beq $t7, 7420, flip
	li $t0, BASE_ADDRESS
	add $t0, $t0, $t7
	sw $s5, -4($t0)
	sw $s5, 100($t0)
	li $t0, BASE_ADDRESS 
	add $t0, $t0, $t7
	li $t1, PLATFORM
	addi $t3, $t0, 100
	jal fill
	
	li $t0, BASE_ADDRESS # platform 4
	addi $t0, $t0, 6080
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	# ladder
	li $t0, BASE_ADDRESS
	li $t1, LADDER
	
	li $t2, 256
	addi $t0, $t0, 204
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 232
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	li $t2, 4
	addi $t0, $t0, 5068
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 3532
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 1996
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 460
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	# character
	lw $t0, CHAR_LOCATION
	sw $t0, CHAR_LOCATION
	jal draw_char
	
	# look for user input
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, key
	beq $t8, 0, loopmain
	
lvl2:
	li $t0, BASE_ADDRESS # platform 1
	addi $t0, $t0, 14144
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	li $t0, BASE_ADDRESS # platform 2
	addi $t0, $t0, 9728
	li $t1, PLATFORM
	addi $t3, $t0, 256
	jal fill
	
	li $t0, BASE_ADDRESS # platform 3
	addi $t0, $t0, 5952
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	li $t0, BASE_ADDRESS # platform 4
	addi $t0, $t0, 6080
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	# ladder
	li $t0, BASE_ADDRESS
	li $t1, LADDER
	
	li $t2, 256
	addi $t0, $t0, 204
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 232
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	li $t2, 4
	addi $t0, $t0, 5068
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 3532
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 1996
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 460
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 

	beqz $s4, checkBoots
	j noBoots
boots:
	jal draw_boots
noBoots:
	#cart
	lw $t0, CART_LOCATION
	add $t0, $t0, $t6
	beq $t6, -4, cartLeft
	sw $s5, 0($t0)
	sw $s5, 24($t0)
	sw $s5, -232($t0)
	sw $s5, -256($t0)
	sw $s5, -516($t0)
	sw $s5, -772($t0)
	sw $s5, -1028($t0)
	sw $s5, -1284($t0)
	sw $s5, -1540($t0)
	sw $s5, -1796($t0)
	sw $s5, -2052($t0)
	j cartRight
cartLeft:
	sw $s5, 16($t0)
	sw $s5, -240($t0)
	sw $s5, 40($t0)
	sw $s5, -216($t0)
	sw $s5, 44($t0)
	sw $s5, -212($t0)
	sw $s5, -468($t0)
	sw $s5, -724($t0)
	sw $s5, -980($t0)
	sw $s5, -1236($t0)
	sw $s5, -1492($t0)
	sw $s5, -1748($t0)
	sw $s5, -2004($t0)
cartRight:
	sw $t0, CART_LOCATION
	li $t1, BASE_ADDRESS
	addi $t1, $t1, 9468
	beq $t0, $t1, flip
	li $t1, BASE_ADDRESS
	addi $t1, $t1, 9684
	beq $t0, $t1, flip
	jal draw_cart
	# character
	lw $t0, CHAR_LOCATION
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $t7, 5888
	j checkCartCollision
resetLevel1:
	li $t0, BASE_ADDRESS 
	li $t1, RED
	addi $t3, $t0, 16384
	jal fill
	li $v0, 32
	li $a0, 200
	syscall
	li $t0, BASE_ADDRESS 
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 15872
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $t0, BASE_ADDRESS
	sw $t0, CART_LOCATION
	subi $s3, $s3, 1
	j start1
noReset1:
	# look for user input
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, key
	beq $t8, 0, loopmain

lvl3:
	li $t0, BASE_ADDRESS # platform 1
	addi $t0, $t0, 14124
	li $t1, SOLIDPLATFORM
	addi $t3, $t0, 40
	jal fill
	
	li $t0, BASE_ADDRESS # platform 2
	addi $t0, $t0, 11152
	li $t1, SOLIDPLATFORM
	addi $t3, $t0, 40
	jal fill
	
	li $t0, BASE_ADDRESS # platform 3
	addi $t0, $t0, 6080
	li $t1, SOLIDPLATFORM
	addi $t3, $t0, 64
	jal fill
	
	li $t0, BASE_ADDRESS # platform 4
	addi $t0, $t0, 8080
	li $t1, PLATFORM
	addi $t3, $t0, 64
	jal fill
	
	# disappearing platform
	beq $t7, 40, change
	beq $t7, 0, change
	j add1
change:
	mul $t6, $t6, -1 
	mflo $t6 
add1:
	add $t7, $t7, $t6
	bge $t7, 20, drawDisappearingPlatform
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 14164
	la $t1, ($s5)
	addi $t3, $t0, 100
	jal fill
	j disappeared
drawDisappearingPlatform:
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 14164
	li $t1, SOLIDPLATFORM
	addi $t3, $t0, 100
	jal fill
disappeared:	
	# ladder
	li $t0, BASE_ADDRESS
	li $t1, LADDER
	
	li $t2, 256
	addi $t0, $t0, 204
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 232
	addi $t3, $t0, 5888
	jal fill
	li $t0, BASE_ADDRESS 
	
	li $t2, 4
	addi $t0, $t0, 5068
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 3532
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 1996
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	addi $t0, $t0, 460
	addi $t3, $t0, 32
	jal fill
	li $t0, BASE_ADDRESS 
	
	# character
	lw $t0, CHAR_LOCATION
	sw $t0, CHAR_LOCATION
	jal draw_char
	
	#lava
	li $t0, BASE_ADDRESS
	li $t1, DIRT
	sw $t1, 16208($t0)
	sw $t1, 15952($t0)
	sw $t1, 15696($t0)
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 16212
	li $t1, ORANGE
	addi $t3, $t0, 172
	jal fill
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 15956
	li $t1, YELLOW
	addi $t3, $t0, 172
	jal fill
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 15700
	li $t1, RED
	addi $t3, $t0, 172
	jal fill
	
	lw $t0, CHAR_LOCATION
	li $t1, BASE_ADDRESS 
	addi $t1, $t1, 16184
	bge $t0, $t1, resetLevel2
	j noReset2
resetLevel2:
	li $t0, BASE_ADDRESS 
	li $t1, RED
	addi $t3, $t0, 16384
	jal fill
	li $v0, 32
	li $a0, 200
	syscall
	li $t0, BASE_ADDRESS 
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 15872
	sw $t0, CHAR_LOCATION
	jal draw_char
	li $t0, BASE_ADDRESS
	sw $t0, CART_LOCATION
	subi $s3, $s3, 1
	j start2
noReset2:
	# look for user input
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, key
	beq $t8, 0, loopmain
lvl4:
	lw $t0, CHAR_LOCATION
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 16256
	bge $t0, $t3, finalScene
	
	li $t0, BASE_ADDRESS
	li $t1, WHITE
	j draw_clouds
lvl4continue:
	
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 10928
	jal draw_girl
	# character
	lw $t0, CHAR_LOCATION
	sw $t0, CHAR_LOCATION
	jal draw_char
	
	# look for user input
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, key
	beq $t8, 0, loopmain
	
gameover:
	li $t0, BASE_ADDRESS 
	li $t1, BLACK
	addi $t3, $t0, 16384
	jal fill
	
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 5224
	li $t1, BROWN
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 540($t0)
	sw $t1, 544($t0)
	sw $t1, 548($t0)
	sw $t1, 552($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 796($t0)
	sw $t1, 800($t0)
	sw $t1, 804($t0)
	sw $t1, 808($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1056($t0)
	sw $t1, 1060($t0)
	sw $t1, 1064($t0)
	sw $t1, 1280($t0)
	sw $t1, 1316($t0)
	sw $t1, 1320($t0)
	sw $t1, 1536($t0)
	sw $t1, 1572($t0)
	sw $t1, 1576($t0)
	sw $t1, 1832($t0)
	
	li $t1, TAN
	sw $t1, 532($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1052($t0)
	sw $t1, 1284($t0)
	sw $t1, 1292($t0)
	sw $t1, 1300($t0)
	sw $t1, 1308($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1568($t0)
	sw $t1, 1796($t0)
	sw $t1, 1804($t0)
	sw $t1, 1812($t0)
	sw $t1, 1820($t0)
	sw $t1, 1828($t0)
	sw $t1, 2052($t0)
	sw $t1, 2052($t0)
	sw $t1, 2056($t0)
	sw $t1, 2060($t0)
	sw $t1, 2064($t0)
	sw $t1, 2068($t0)
	sw $t1, 2072($t0)
	sw $t1, 2076($t0)
	sw $t1, 2080($t0)
	sw $t1, 2084($t0)
	sw $t1, 2308($t0)
	sw $t1, 2312($t0)
	sw $t1, 2316($t0)
	sw $t1, 2320($t0)
	sw $t1, 2324($t0)
	sw $t1, 2328($t0)
	sw $t1, 2332($t0)
	sw $t1, 2336($t0)
	sw $t1, 2340($t0)
	sw $t1, 2564($t0)
	sw $t1, 2568($t0)
	sw $t1, 2572($t0)
	sw $t1, 2576($t0)
	sw $t1, 2584($t0)
	sw $t1, 2588($t0)
	sw $t1, 2592($t0)
	sw $t1, 2596($t0)
	sw $t1, 2828($t0)
	sw $t1, 2832($t0)
	sw $t1, 2836($t0)
	sw $t1, 2840($t0)
	sw $t1, 2844($t0)
	
	li $t1, BLACK
	sw $t1, 1288($t0)
	sw $t1, 1296($t0)
	sw $t1, 1304($t0)
	sw $t1, 1312($t0)
	sw $t1, 1548($t0)
	sw $t1, 1564($t0)
	sw $t1, 1800($t0)
	sw $t1, 1808($t0)
	sw $t1, 1816($t0)
	sw $t1, 1824($t0)
	
	li $t1, RED
	sw $t1, 2580($t0)
	
	addi $t0, $t0, 3824
	li $t1, WHITE
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)
	sw $t1, 304($t0)
	sw $t1, 320($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 544($t0)
	sw $t1, 564($t0)
	sw $t1, 568($t0)
	sw $t1, 580($t0)
	sw $t1, 584($t0)
	sw $t1, 768($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 800($t0)
	sw $t1, 804($t0)
	sw $t1, 808($t0)
	sw $t1, 816($t0)
	sw $t1, 820($t0)
	sw $t1, 824($t0)
	sw $t1, 832($t0)
	sw $t1, 836($t0)
	sw $t1, 840($t0)
	addi $t0, $t0, 1568
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
lost:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	lw $t1, 4($t9)
	beq $t1, 112, p
	beq $t8, 0, lost
	j lost

finalScene:
	li $t0, BASE_ADDRESS 
	li $t1, BLACK
	addi $t3, $t0, 16384
	jal fillLong
	
	li $v0, 32
	li $a0, 500
	syscall
	
	li $t0, BASE_ADDRESS 
	la $t1, ($s5)
	addi $t3, $t0, 16384
	jal fill
	
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 9216
	li $t1, GRASS
	addi $t3, $t0, 512
	jal fill
	
	li $t0, BASE_ADDRESS 
	addi $t0, $t0, 9728
	li $t1, BROWN
	addi $t3, $t0, 6656
	jal fill
	
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 3456
	jal draw_girl
	# character
	li $t0, BASE_ADDRESS
	sw $t0, CHAR_LOCATION
	addi $t0, $t0, 9052
	sw $t0, CHAR_LOCATION
	jal draw_char
	
	li $v0, 32
	li $a0, 1500
	syscall
	
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 1904
	jal draw_heart
	li $t0, BASE_ADDRESS
	li $t1, DRESS
	sw $t1, 4452($t0)
	sw $t1, 4468($t0)
	sw $t1, 4484($t0)
	sw $t1, 4500($t0)
	
	li $v0, 32
	li $a0, 1000
	syscall
	
	li $t0, BASE_ADDRESS
	li $t1, WHITE
	addi $t0, $t0, 11880
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 32($t0)
	sw $t1, 40($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 288($t0)
	sw $t1, 296($t0)
	sw $t1, 516($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 544($t0)
	sw $t1, 552($t0)
	sw $t1, 772($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 800($t0)
	sw $t1, 804($t0)
	sw $t1, 808($t0)	
	sw $t1, 1536($t0)
	sw $t1, 1544($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1568($t0)
	sw $t1, 1572($t0)
	sw $t1, 1576($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1808($t0)
	sw $t1, 1816($t0)
	sw $t1, 1824($t0)
	sw $t1, 1832($t0)
	sw $t1, 2048($t0)
	sw $t1, 2052($t0)
	sw $t1, 2056($t0)
	sw $t1, 2064($t0)
	sw $t1, 2072($t0)
	sw $t1, 2080($t0)
	sw $t1, 2088($t0)
	sw $t1, 2304($t0)
	sw $t1, 2308($t0)
	sw $t1, 2312($t0)
	sw $t1, 2320($t0)
	sw $t1, 2324($t0)
	sw $t1, 2328($t0)
	sw $t1, 2336($t0)
	sw $t1, 2344($t0)	
	
	j EXIT
	
draw_heart:
	li $t1, RED
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)	
	sw $t1, 1032($t0)	
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1292($t0)
	
	j return
draw_cloud:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, -252($t0)
	sw $t1, -248($t0)
	sw $t1, -244($t0)
	sw $t1, -240($t0)
	sw $t1, -236($t0)
	sw $t1, -500($t0)
	sw $t1, -496($t0)
	j return
draw_clouds:
	addi $t0, $t0, 3200
	jal draw_cloud
	addi $t0, $t0, 128
	jal draw_cloud
	addi $t0, $t0, 64
	jal draw_cloud
	addi $t0, $t0, 256
	jal draw_cloud
	addi $t0, $t0, 128
	jal draw_cloud
	addi $t0, $t0, 1000
	jal draw_cloud
	addi $t0, $t0, 100
	jal draw_cloud
	addi $t0, $t0, 80
	jal draw_cloud
	addi $t0, $t0, 164
	jal draw_cloud
	addi $t0, $t0, 900
	jal draw_cloud
	addi $t0, $t0, 1000
	jal draw_cloud
	addi $t0, $t0, 128
	jal draw_cloud
	addi $t0, $t0, 80
	jal draw_cloud
	addi $t0, $t0, 800
	jal draw_cloud
	addi $t0, $t0, 80
	jal draw_cloud
	addi $t0, $t0, 80
	jal draw_cloud
	j lvl4continue
draw_boots:
	li $t1, BLACK
	sw $t1, 15788($t0)
	sw $t1, 15792($t0)
	sw $t1, 15796($t0)
	sw $t1, 15800($t0)
	sw $t1, 15804($t0)
	sw $t1, 15808($t0)
	sw $t1, 15824($t0)
	sw $t1, 15828($t0)
	sw $t1, 15832($t0)
	sw $t1, 15836($t0)
	sw $t1, 15840($t0)
	sw $t1, 15844($t0)
	sw $t1, 15532($t0)
	sw $t1, 15552($t0)
	sw $t1, 15568($t0)
	sw $t1, 15588($t0)
	sw $t1, 15276($t0)
	sw $t1, 15296($t0)
	sw $t1, 15312($t0)
	sw $t1, 15332($t0)
	sw $t1, 15024($t0)
	sw $t1, 15028($t0)
	sw $t1, 15040($t0)
	sw $t1, 15056($t0)
	sw $t1, 15068($t0)
	sw $t1, 15072($t0)
	sw $t1, 14776($t0)
	sw $t1, 14784($t0)
	sw $t1, 14800($t0)
	sw $t1, 14808($t0)
	sw $t1, 14520($t0)
	sw $t1, 14528($t0)
	sw $t1, 14544($t0)
	sw $t1, 14552($t0)
	sw $t1, 14264($t0)
	sw $t1, 14268($t0)
	sw $t1, 14292($t0)
	sw $t1, 14296($t0)
	
	li $t1, WHITE
	sw $t1, 14272($t0)
	sw $t1, 14288($t0)
	sw $t1, 14008($t0)
	sw $t1, 14016($t0)
	sw $t1, 14020($t0)
	sw $t1, 14028($t0)
	sw $t1, 14032($t0)
	sw $t1, 14040($t0)
	
	li $t1, BOOTS
	sw $t1, 15536($t0)
	sw $t1, 15280($t0)
	sw $t1, 15540($t0)
	sw $t1, 15284($t0)
	sw $t1, 15544($t0)
	sw $t1, 15288($t0)
	sw $t1, 15032($t0)
	sw $t1, 15548($t0)
	sw $t1, 15292($t0)
	sw $t1, 15036($t0)
	sw $t1, 14780($t0)
	sw $t1, 14524($t0)
	sw $t1, 15572($t0)
	sw $t1, 15316($t0)
	sw $t1, 15060($t0)
	sw $t1, 14804($t0)
	sw $t1, 14548($t0)
	sw $t1, 15576($t0)
	sw $t1, 15320($t0)
	sw $t1, 15064($t0)
	sw $t1, 15580($t0)
	sw $t1, 15324($t0)
	sw $t1, 15584($t0)
	sw $t1, 15328($t0)
	
	j return

draw_cart:
	li $t1, BLACK
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, -252($t0)
	sw $t1, -244($t0)
	sw $t1, -228($t0)
	sw $t1, -220($t0)
	sw $t1, -512($t0)
	sw $t1, -508($t0)
	sw $t1, -504($t0)
	sw $t1, -500($t0)
	sw $t1, -496($t0)
	sw $t1, -492($t0)
	sw $t1, -488($t0)
	sw $t1, -484($t0)
	sw $t1, -480($t0)
	sw $t1, -476($t0)
	sw $t1, -472($t0)
	sw $t1, -768($t0)
	sw $t1, -728($t0)
	sw $t1, -1024($t0)
	sw $t1, -984($t0)
	sw $t1, -1280($t0)
	sw $t1, -1240($t0)
	sw $t1, -1536($t0)
	sw $t1, -1496($t0)
	sw $t1, -1792($t0)
	sw $t1, -1752($t0)
	sw $t1, -2048($t0)
	sw $t1, -2044($t0)
	sw $t1, -2040($t0)
	sw $t1, -2036($t0)
	sw $t1, -2032($t0)
	sw $t1, -2028($t0)
	sw $t1, -2024($t0)
	sw $t1, -2020($t0)
	sw $t1, -2016($t0)
	sw $t1, -2012($t0)
	sw $t1, -2008($t0)
	
	li $t1, GRAY
	sw $t1, -248($t0)
	sw $t1, -224($t0)
	sw $t1, -764($t0)
	sw $t1, -760($t0)
	sw $t1, -756($t0)
	sw $t1, -752($t0)
	sw $t1, -748($t0)
	sw $t1, -744($t0)
	sw $t1, -740($t0)
	sw $t1, -736($t0)
	sw $t1, -732($t0)
	sw $t1, -1020($t0)
	sw $t1, -1016($t0)
	sw $t1, -1012($t0)
	sw $t1, -1008($t0)
	sw $t1, -1004($t0)
	sw $t1, -1000($t0)
	sw $t1, -996($t0)
	sw $t1, -992($t0)
	sw $t1, -988($t0)
	sw $t1, -1276($t0)
	sw $t1, -1272($t0)
	sw $t1, -1268($t0)
	sw $t1, -1264($t0)
	sw $t1, -1260($t0)
	sw $t1, -1256($t0)
	sw $t1, -1252($t0)
	sw $t1, -1248($t0)
	sw $t1, -1244($t0)
	sw $t1, -1532($t0)
	sw $t1, -1528($t0)
	sw $t1, -1524($t0)
	sw $t1, -1520($t0)
	sw $t1, -1516($t0)
	sw $t1, -1512($t0)
	sw $t1, -1508($t0)
	sw $t1, -1504($t0)
	sw $t1, -1500($t0)
	sw $t1, -1788($t0)
	sw $t1, -1784($t0)
	sw $t1, -1780($t0)
	sw $t1, -1776($t0)
	sw $t1, -1772($t0)
	sw $t1, -1768($t0)
	sw $t1, -1764($t0)
	sw $t1, -1760($t0)
	sw $t1, -1756($t0)
	
	
	j return
draw_girl:
	li $t1, BLACK
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 540($t0)
	sw $t1, 772($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 796($t0)
	sw $t1, 1048($t0)
	sw $t1, 1052($t0)
	sw $t1, 1284($t0)
	sw $t1, 1304($t0)
	sw $t1, 1308($t0)
	sw $t1, 1544($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1564($t0)
	sw $t1, 1796($t0)
	sw $t1, 1816($t0)
	sw $t1, 1820($t0)
	sw $t1, 2052($t0)
	sw $t1, 2072($t0)
	sw $t1, 2076($t0)
	sw $t1, 2308($t0)
	sw $t1, 2320($t0)
	sw $t1, 2328($t0)
	sw $t1, 2332($t0)
	sw $t1, 2564($t0)
	sw $t1, 2576($t0)
	sw $t1, 2584($t0)
	sw $t1, 2820($t0)
	sw $t1, 2840($t0)
	sw $t1, 3076($t0)
	sw $t1, 3096($t0)
	sw $t1, 3332($t0)
	sw $t1, 3352($t0)
	sw $t1, 3588($t0)
	sw $t1, 3608($t0)
	sw $t1, 3840($t0)
	sw $t1, 3868($t0)
	sw $t1, 4100($t0)
	sw $t1, 4108($t0)
	sw $t1, 4120($t0)
	sw $t1, 4356($t0)
	sw $t1, 4364($t0)
	sw $t1, 4376($t0)
	sw $t1, 4612($t0)
	sw $t1, 4620($t0)
	sw $t1, 4632($t0)
	sw $t1, 4868($t0)
	sw $t1, 4876($t0)
	sw $t1, 4888($t0)
	sw $t1, 5120($t0)
	sw $t1, 5128($t0)
	sw $t1, 5144($t0)
	sw $t1, 5376($t0)
	sw $t1, 5384($t0)
	sw $t1, 5400($t0)
	sw $t1, 5632($t0)
	sw $t1, 5636($t0)
	sw $t1, 5640($t0)
	sw $t1, 5644($t0)
	sw $t1, 5648($t0)
	sw $t1, 5652($t0)
	sw $t1, 5656($t0)
	
	li $t1, DRESS
	sw $t1, 1800($t0)
	sw $t1, 1812($t0)
	sw $t1, 2056($t0)
	sw $t1, 2060($t0)
	sw $t1, 2064($t0)
	sw $t1, 2068($t0)
	sw $t1, 2312($t0)
	sw $t1, 2316($t0)
	sw $t1, 2324($t0)
	sw $t1, 2568($t0)
	sw $t1, 2572($t0)
	sw $t1, 2580($t0)
	sw $t1, 2824($t0)
	sw $t1, 2828($t0)
	sw $t1, 3080($t0)
	sw $t1, 3084($t0)
	sw $t1, 3088($t0)
	sw $t1, 3336($t0)
	sw $t1, 3340($t0)
	sw $t1, 3344($t0)
	sw $t1, 3348($t0)
	sw $t1, 3592($t0)
	sw $t1, 3596($t0)
	sw $t1, 3600($t0)
	sw $t1, 3604($t0)
	sw $t1, 3844($t0)
	sw $t1, 3848($t0)
	sw $t1, 3852($t0)
	sw $t1, 3856($t0)
	sw $t1, 3860($t0)
	sw $t1, 3864($t0)
	
	li $t1, WHITE
	sw $t1, 5124($t0)
	sw $t1, 5132($t0)
	sw $t1, 5136($t0)
	sw $t1, 5140($t0)
	sw $t1, 5380($t0)
	sw $t1, 5388($t0)
	sw $t1, 5392($t0)
	sw $t1, 5396($t0)
	
	li $t1, TAN
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 788($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 2832($t0)
	sw $t1, 2836($t0)
	sw $t1, 3092($t0)
	sw $t1, 4104($t0)
	sw $t1, 4112($t0)
	sw $t1, 4116($t0)
	sw $t1, 4360($t0)
	sw $t1, 4368($t0)
	sw $t1, 4372($t0)
	sw $t1, 4616($t0)
	sw $t1, 4624($t0)
	sw $t1, 4628($t0)
	sw $t1, 4872($t0)
	sw $t1, 4880($t0)
	sw $t1, 4884($t0)
	
	j return
draw_char:
	li $t1, BLACK
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, -256($t0)
	sw $t1, -240($t0)
	sw $t1, -228($t0)
	sw $t1, -512($t0)
	sw $t1, -496($t0)
	sw $t1, -484($t0)
	sw $t1, -768($t0)
	sw $t1, -756($t0)
	sw $t1, -744($t0)
	sw $t1, -1024($t0)
	sw $t1, -1012($t0)
	sw $t1, -1000($t0)
	sw $t1, -1280($t0)
	sw $t1, -1268($t0)
	sw $t1, -1256($t0)
	sw $t1, -1536($t0)
	sw $t1, -1524($t0)
	sw $t1, -1512($t0)
	sw $t1, -1792($t0)
	sw $t1, -1768($t0)
	sw $t1, -2048($t0)
	sw $t1, -2044($t0)
	sw $t1, -2032($t0)
	sw $t1, -2028($t0)
	sw $t1, -2024($t0)
	sw $t1, -2304($t0)
	sw $t1, -2280($t0)
	sw $t1, -2560($t0)
	sw $t1, -2552($t0)
	sw $t1, -2548($t0)
	sw $t1, -2544($t0)
	sw $t1, -2536($t0)
	sw $t1, -2816($t0)
	sw $t1, -2808($t0)
	sw $t1, -2800($t0)
	sw $t1, -2792($t0)
	sw $t1, -3072($t0)
	sw $t1, -3064($t0)
	sw $t1, -3056($t0)
	sw $t1, -3048($t0)
	sw $t1, -3328($t0)
	sw $t1, -3320($t0)
	sw $t1, -3304($t0)
	sw $t1, -3584($t0)
	sw $t1, -3560($t0)
	sw $t1, -3836($t0)
	sw $t1, -3820($t0)
	sw $t1, -4852($t0)
	sw $t1, -4840($t0)
	
	beq $s4, 1, newBoots
	li $t1, BROWN
	j continueCharacter
newBoots:
	li $t1, BOOTS
continueCharacter:
	sw $t1, -252($t0)
	sw $t1, -248($t0)
	sw $t1, -244($t0)
	sw $t1, -236($t0)
	sw $t1, -232($t0)
	sw $t1, -508($t0)
	sw $t1, -504($t0)
	sw $t1, -500($t0)
	sw $t1, -492($t0)
	sw $t1, -488($t0)
	li $t1, BROWN
	sw $t1, -4352($t0)
	sw $t1, -4608($t0)
	sw $t1, -4604($t0)
	sw $t1, -4864($t0)
	sw $t1, -4860($t0)
	sw $t1, -5120($t0)
	sw $t1, -5116($t0)
	sw $t1, -5112($t0)
	sw $t1, -5092($t0)
	sw $t1, -5376($t0)
	sw $t1, -5372($t0)
	sw $t1, -5368($t0)
	sw $t1, -5364($t0)
	sw $t1, -5360($t0)
	sw $t1, -5352($t0)
	sw $t1, -5348($t0)
	sw $t1, -5628($t0)
	sw $t1, -5624($t0)
	sw $t1, -5620($t0)
	sw $t1, -5616($t0)
	sw $t1, -5612($t0)
	sw $t1, -5608($t0)
	
	li $t1, BLUE
	sw $t1, -764($t0)
	sw $t1, -760($t0)
	sw $t1, -752($t0)
	sw $t1, -748($t0)
	sw $t1, -764($t0)
	sw $t1, -1020($t0)
	sw $t1, -1016($t0)
	sw $t1, -1008($t0)
	sw $t1, -1004($t0)
	sw $t1, -1276($t0)
	sw $t1, -1272($t0)
	sw $t1, -1264($t0)
	sw $t1, -1260($t0)
	sw $t1, -1532($t0)
	sw $t1, -1528($t0)
	sw $t1, -1520($t0)
	sw $t1, -1516($t0)
	sw $t1, -1788($t0)
	sw $t1, -1784($t0)
	sw $t1, -1780($t0)
	sw $t1, -1776($t0)
	sw $t1, -1772($t0)
	
	li $t1, LIGHTBLUE
	sw $t1, -2300($t0)
	sw $t1, -2284($t0)
	sw $t1, -2556($t0)
	sw $t1, -2540($t0)
	sw $t1, -2812($t0)
	sw $t1, -2804($t0)
	sw $t1, -2796($t0)
	sw $t1, -3068($t0)
	sw $t1, -3060($t0)
	sw $t1, -3052($t0)
	sw $t1, -3324($t0)
	sw $t1, -3316($t0)
	sw $t1, -3312($t0)
	sw $t1, -3308($t0)
	sw $t1, -3580($t0)
	sw $t1, -3576($t0)
	sw $t1, -3572($t0)
	sw $t1, -3568($t0)
	sw $t1, -3564($t0)
	sw $t1, -3832($t0)
	sw $t1, -3828($t0)
	sw $t1, -3824($t0)
	
	li $t1, TAN
	sw $t1, -2040($t0)
	sw $t1, -2036($t0)
	sw $t1, -2296($t0)
	sw $t1, -2292($t0)
	sw $t1, -2288($t0)
	sw $t1, -4088($t0)
	sw $t1, -4084($t0)
	sw $t1, -4080($t0)
	sw $t1, -4348($t0)
	sw $t1, -4344($t0)
	sw $t1, -4340($t0)
	sw $t1, -4336($t0)
	sw $t1, -4332($t0)
	sw $t1, -4600($t0)
	sw $t1, -4596($t0)
	sw $t1, -4592($t0)
	sw $t1, -4588($t0)
	sw $t1, -4584($t0)
	sw $t1, -4856($t0)
	sw $t1, -4848($t0)
	sw $t1, -4844($t0)
	sw $t1, -5108($t0)
	sw $t1, -5104($t0)
	sw $t1, -5100($t0)
	sw $t1, -5096($t0)
	sw $t1, -5356($t0)
	
	j return


EXIT:
	li $v0, 10
	syscall			#terminate program
	
