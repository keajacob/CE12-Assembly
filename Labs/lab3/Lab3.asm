# Edited by Kyle O'Rourke
# 10/28/2017
# Lab 3 - First assembly project.

# Notes: DO NOT use syscalls 5 and 35!!

# Program data goes here.
.data
welcome_msg: .asciiz "Welcome to a snazzy converter program!\n"
input_number_msg: .asciiz "Input Number: "
output_number_msg: .asciiz "\nOutput Number: "
negative_true: .asciiz " Value is negative."

# Language instructions
.text


## Main program starts here. ##
main:
	# Grab input argument from text segment.
	move	 $s0, $a1
	lw	 $s0, ($s0)
	
	# Display introduction message: "Welcome to a snazzy converter program!"
	jal intro_msg_procedure
	
	# Display input message: "Input Number: "
	jal input_msg_procedure
	
	# Display input number:
	jal display_input_num
	
	# FIND STRING LENGTH
	li $s7, 0					# This number will hold the amount of characters in the input.
	find_string_len:
		add 	$t1, $s0, $s7	 		#This number is the location that will be checked
		lb   	$t0, 0($t1)			# Store char into temp address.
		beq	$t0, $zero, exit_string_len	# If at end of string, exit loop.
		addi	$s7, $s7, 1			# Add 1 to the # of char register.
	j find_string_len				#Loop back to top of procedure.	
	exit_string_len:
		#move   	$a0, $s7	#Print out the number of chars in string.
		#li   		$v0, 1
		#syscall


	# CHECK IF STRING HAS A '-' in the beginning. ASCII val 45
	lb 	$t0, 0($s0)
	addi	$t1, $zero, 45
	beq	$t0, $t1, is_negative
	is_positive:
		addi	$s6, $zero, 0	#Making s6 hold the string length minus one because the total length starts from 0.
		j j1
	is_negative:
		addi 	$s6, $zero, 1	# Put string len count into temp 0 minus one value for the negative sign.
		
	j1:
	
	# Conver number from string to binary 32 bits (So 32 1's & 0's)
	# ASCII conv. 48 - 57 = 0 - 9
	# We know the length of the string.
	# 1 - Start at the back of the string.
	# 2 - Add each number together iterating from the last to the first-1.
	# 3 - If $s6 is 1 then number is negative - take 2's comp.
	
	subi	$s4, $s7, 1		# Register that holds the current position in string for loop. Minus 1 because the address is 0 index. 
	li 	$s5, 0			# Register that holds the final int value.
	add	$t3, $s7, $zero		# Register that holds overall value for multiplying by ten.
	main_string_to_int_loop:
		add	$t1, $s0, $s4	#Add the register location to t1
		lb 	$t2, 0($t1)	#Load the register location at t1 by value into t2.
		subi	$t2, $t2, 48	#Convert ascii to int. by subtracting 48
		#addi	$t5, $t2, 0
		# $t2 & $t5 - Current in location int value.
		
		# Check if the value is in a place less than 0.
		addi 	$s4, $s4, 1	# Because the object is zero indexed we need to add 1 temporarily to do position math.
		sub	$t4, $t3, $s4	# Number of times to multiply value by 10.
		subi 	$s4, $s4, 1
		multiply_by_ten_loop:
			#Check if it needs to be multiplied else leave loop.
			beq	$t4, $zero, j2
			
			#To multiply by ten shift n*10 = n*8 + n*2 = n << 3 + n << 1
			sll $t5, $t2, 1
			sll $t6, $t2, 3
			add $t2, $t5, $t6

			subi	$t4, $t4, 1
		j multiply_by_ten_loop
		j2:
		
		addu	$s5, $s5, $t2		#Add value to the final holder.
		
		# IF VALUE IS POSITIVE:
		li	$t7, 1			#Put 1 in t7
		beq	$s6, $t7, j3		#If s6 is true, jump to negative section.
		beq	$s4, $zero, j4		#If the position is at the last point, exit.
		j j5
		
		# IF VALUE IS NEGATIVE:
		j3:
		beq	$s4, $s6, j4
		
		j5:
		subi	$s4, $s4, 1		#Increment the position up.
		
	j main_string_to_int_loop
	j4:
	
	# Display output message: "Output Number: "
	jal output_msg_procedure
	
	#$s5 holds the current value as a positive integer.
	#If the number is negative change the int to a negative.
	li	$t7, 0			#Put 1 in t7
	beq	$s6, $t7, j6		#If s6 is true, jump to negative section.
	mul	$s5, $s5, -1		#Much lazy...
	j6:
	#move   	$a0, $s5
	#li  	 	$v0, 35
	#syscall
	
	#Now print the integer in binary.
	move	$t0, $s5			#Store our int value in t0
	addi	$s1, $zero, 32			#create a counter for all 32 bits
	binary_print_loop:
		rol	$t0, $t0, 1		#shift through bits by one.
		and	$t1, $t0, 1		#compare each bit to 1 with an AND.
		addi	$t1, $t1, 48		#Since ascii code 48 is 0, we need to add 48 to get 0.
		subi	$s1, $s1, 1		#increment by 1.
		
		# PRINT THE VALUE
		move	$a0, $t1
		li	$v0, 11
		syscall
		
		beq	$s1, $zero, j7
		j binary_print_loop
	j7:
	# End program.
	li	 $v0, 10 # 10 is the exit syscall.
	syscall 	 # do the syscall.

## END OF MAIN. ##

# LOOK AT FIRST CHARACTER IN STRING AND PRINT IT
first_char_find:
	addi $s1, $s0, 0 #This number is the location that will be printed.
	lb   $a0, 0($s1)
	li   $v0, 11
	syscall
	jr $ra

is_negative_true:
		la	 $a0, negative_true 	# Load the addr into $a0.
		li 	 $v0, 4		  	# Print the msg.
		syscall 		 	# Do the syscall.
		jr $ra


# DISPLAY INTRODUCTION MESSAGE
intro_msg_procedure:
	la	 $a0, welcome_msg # Load the addr of hello_msg into $a0.
	li 	 $v0, 4		  # Print the msg.
	syscall 		  # Do the syscall.
	jr $ra			  # Return to previous function.

# DISPLAY INPUT MESSAGE
input_msg_procedure:
	la 	 $a0, input_number_msg	# Load the addr of input_number_msg into $a0.
	li	 $v0, 4			# Print the msg.
	syscall 			# Do the syscall.
	jr $ra				# Return to previous function.

# DISPLAY INPUT NUMBER
display_input_num:
	move	$a0, $s0
	li	$v0, 4
	syscall
	jr $ra

# DISPLAY OUPUT MESSASGE
output_msg_procedure:
	la 	 $a0, output_number_msg
	li	 $v0, 4
	syscall
	jr $ra


# end hello.asm
