# Lab4.asm
# UCSC CE 12 - Assembly & Computer systems
# 11/12/2017
# Written by: Kyle O'Rourke

# Program description:
# Allow user to input a positive unisgined number from 3 to n.
# Program will then find all prime numbers leading up to that number.
# EX: Input:12 Output: 2,3,5,7,11

# NOTE: USER INPUT OCCURS INSIDE THE I/O TERMINAL!!!

.data
welcome_msg:     .asciiz "PRIME NUMBER FINDER v.32U\n"						# Too cheeky?
num_enter_msg:   .asciiz "Please enter an integer greater than 2 & less than 4,294,967,296: "	# Text to tell user what to enter.
cheeky_retort_1: .asciiz "A fine choice!"							# Cheekyness!
cheeky_retort_2: .asciiz " I shall provide the desired information post haste!\n"		# More cheekyness!
cheeky_retort_3: .asciiz "."									# To show seriousness 
cheeky_retort_4: .asciiz "You had one job!"							# You messed up somehow.
cheeky_retort_5: .asciiz " Try again."								# You messed up somehow.
cheeky_retort_6: .asciiz "\n"									# You messed up somehow.
comma_msg:	 .asciiz ", "
.text


main:
	# Print introduction.
	jal intro_msg
	
	# Get user int. input and give a cheeky reply.
	jal get_user_input	# User input stored in $s0 using the I/O terminal
	
	# Print primes up to number.
	jal find_primes
 	ph2:
	# END PROGRAM
	li	 $v0, 10 	# 10 = Exit syscall.
	syscall
# END

find_primes:
	# n = 2
	# x = 2
	#while(n <= user input){
		#if n >= user_input/2 - exit
		#if n/x has no remainder and n != x then n is not a prime.
			#x=2 , n++
			#jump to start of loop.
		#if n/x has no remainder and n=x then n is a prime.
			#print value.
			#x=2, n++
		#else x++
	

	addiu	$t2, $zero, 2		# Number to test.
	# 2 Will always be printed if given input is correct.
	la	$a0, ($t2)
	li	$v0, 1
	syscall
	addiu	$t2, $t2, 1
	
	# t2 = Current integer to test.
	# t0 = Increasing divisor.
	# t1 = Half of input.
	ph1:
	addiu	$t0, $zero, 2		# t0 = 2. t0 will be the increasing divisor.
	divu 	$t1, $t2, $t0		# t1 = input/2
	prime_loop:
		bgt	$t0, $t1, is_prime_exit 	# Exit loop if $t0 is greater than half of input num. Number is prime.
		
		rem	$t3, $t2, $t0			# $t2 = $s0 % $t0
		beqz	$t3, not_prime_exit		# Number is divisable. Not prime, exit.
		
		addiu	$t0, $t0, 1			# Increase divisor value.
		
		j prime_loop				# Return to top of loop.
		
	is_prime_exit:
		# Print out comma sep.
		la	 $a0, comma_msg 	# Load the string into $a0.
		li	 $v0, 4		  	# Print the msg.
		syscall
		# Print int. and move on to next value or end loop.
		la	$a0, ($t2)
		li	$v0, 1
		syscall
		# Check if number is equal to user input value. 
		bge	$t2, $s0, ph2
		# Since number is not yet equal, increase by one.
		addiu	$t2, $t2, 1
		j 	ph1
		
	not_prime_exit:
		# Check if number is equal to user input value. 
		bge	$t2, $s0, ph2
		# Since number is not yet equal, increase by one.
		addiu	$t2, $t2, 1
		j 	ph1

	
intro_msg:
	la	 $a0, welcome_msg 	# Load the string into $a0.
	li	 $v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	jr	 $ra			# Return.
	
three_dot_print:
	# Save to the stack all registers used in function.
	addi	$sp, $sp, -8		# Make room on the stack for one object.
	sw	$t0, 4($sp)		# Save t0 to stack.
	sw	$t1, 0($sp)		# Save t1 to stack.
	
	# After registers are saved, do operations.
	addiu	$t0, $zero, 0
	addiu	$t1, $zero, 3
	
	dot_loop:
 	# Print "."
	la	 $a0, cheeky_retort_3 	# Load the string into $a0.
	li 	 $v0, 4		  	# Print the msg.
	syscall
	
	# Sleep for dramatic affect.
	li	$a0, 100
 	li	$v0, 32
 	syscall
	
	# Add 1 to the loop counter and check if it is time to leave loop.
 	addiu	$t0, $t0, 1
 	blt	$t0, $t1, dot_loop	#  branch to target if  $t0 < $t1

	# Sleep for dramatic affect.
	li	$a0, 400
 	li	$v0, 32
 	syscall
	
	# Return registers and stack to previous state.
	lw	$t1, 0($sp)
	lw	$t0, 4($sp)
	addi	$sp, $sp, 8		# Return stack to previous location
	jr	$ra

get_user_input:
	la	 $a0, num_enter_msg 	# Load the string into $a0.
	li	 $v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# Aquire number from user via the I/O terminal.
	li	 $v0, 5
	syscall
	addu	 $s0, $v0, $zero
	
	# Check if input is below 2.
	addiu	$t0, $zero, 1
	ble	$s0, $t0, you_goof	#  branch to target if  $t0 <= $t1
	
	jr $ra				# Return.
	
	# You had one job!!
	you_goof:
		jal	three_dot_print		# For seriousness
	
		la	 $a0, cheeky_retort_4 	# "You had one job!"
		li 	 $v0, 4		  	# Print the msg.
		syscall
		
		# Delay
 		li	$a0, 800
 		li	$v0, 32
 		syscall
 		
 		la	 $a0, cheeky_retort_5 	# "Try again..."
		li 	 $v0, 4		  	# Print the msg.
		syscall
		
		# Delay
 		li	$a0, 1000
 		li	$v0, 32
 		syscall
		
		# Clear the I/O port a tad bit since program is looping back to main.
		la	 $a0, cheeky_retort_6 	# NEW LINE. \n
		li 	 $v0, 4		  	# Print the msg.
		syscall
		la	 $a0, cheeky_retort_6 	# NEW LINE. \n
		li 	 $v0, 4		  	# Print the msg.
		syscall
		
		j	main
