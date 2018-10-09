# Created by Kyle O'Rourke
# 11/26/2017
# Lab 5 - Cypher Assembly project.


# Program data goes here.
.data
given_key_msg: .asciiz "The given key is: "
given_text_msg: .asciiz "The given text is: "
encrypted_text_msg: .asciiz "The encrypted text is: "
decrypted_text_msg: .asciiz "The decrypted text is: "
newline_msg: .asciiz "\n"
space_msg: .asciiz " "
encrypted_output: .space 100
clear_text_output: .space 100

# Language instructions
.text

# MAIN STARTS HERE #
main:
	# Move program arguments to save locations. (a0-a3 are for function arguments)
	move	$s0, $a0	# $s0 holds the number of strings given.
	move	$s1, $a1	# Set $s1 equal to contents of $a1
	addi	$s7, $zero, 126
	addi	$s6, $zero, 32
	
	
	# Print key string pre message.
	la	$a0, given_key_msg 	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# Get key string & print.
	lw	$t0, 0($s1)		# Since the first string will be the KEY we need to grab word at position 0.
	la	$a0, 0($t0) 		# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.

	# Print newline:
	jal print_newln

	# Print message string pre message.
	la	$a0, given_text_msg 	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.

	# Print non key string.
	lw	$t0, 4($s1)
	la	$a0, ($t0)
	li	$v0, 4
	syscall
	
	# Print newline:
	jal print_newln
	
	# Encode Strings
	lw	$a0, 0($s1)		# Load key into $a0	KEY
	lw	$a1, 4($s1)		# Load string into $a1  CLEAR TEXT
	la	$a2, encrypted_output	# Load clear into a2.	CIPHER TEXT
	jal encode
	
	# Print encoded message pre text.
	la	$a0, encrypted_text_msg	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# Get encrypted string & print.
	la	$a0, encrypted_output	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# Print newline:
	jal print_newln
	
	# Decode String
	lw	$a0, 0($s1)		# Load key into $a0		KEY
	la	$a1, encrypted_output	# Load encrypted into a2.	CIPHER TEXT
	la	$a2, clear_text_output	# Address for clear text.	CLEAR TEXT
	jal decode
	
	# Print decoded message pre text.
	la	$a0, decrypted_text_msg	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# Get decrypted string & print.
	la	$a0, clear_text_output	# Load the string into $a0.
	li	$v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	
	# End program.
	li	 $v0, 10 # 10 is the exit syscall.
	syscall 	 # do the syscall.
	
# END OF MAIN. #

# Function variables: (address of cipher key, address of cipher, text address of clear text)
decode:
	# $a0 - KEY
	# $a1 - CIPHER TEXT 
	# $a2 - CLEAR TEXT
	
	la	$t0, 0($a0)	# $t0 now holds KEY
	la	$t1, 0($a1)	# $t1 now holds CIPHER ADDRESS
	la	$t2, 0($a2)	# $t2 now holds CLEAR ADDRESS
	
	# Loop that iterates through $t0 to get number values to add to $t1.
	li	$t5, 0		# $t5 is our string clear message incrementor.
	li	$t7, 0		# $t7 is our cipher message incrementor.
	key_location_rst_d:
	li	$t3, 0		# $t3 is our incrementor for our KEY string.
	decode_loop_1:
	add	$t4, $t0, $t3	# $t4 now holds register location for current KEY char location.
	lb	$t4, 0($t4)	# $t4 now holds bit at current key location.
	beqz	$t4, key_location_rst_d
	addi	$t3, $t3, 1	# Increment $t3 for next key value.
	
	add	$t6, $t1, $t5			# $t6 now holds register location for current string char.
	lb	$t6, 0($t6)			# $t6 now holds bit at current key location.
	beqz	$t6, exit_decode_loop		# End of string. Exit.
	sub	$t6, $t6, $t4			# $t6 now holds (e - k)
	bgt	$t6, 32, decode_offset_jump 	# $t6 = decrypted value.
	sub	$t6, $s6, $t6			# 32 - value.
	sub	$t6, $s7, $t6			# Final manipulation for correct value out.
	
	decode_offset_jump:	#$t6 = decrypted value.
	addi	$t5, $t5, 1	# Increment string location by one.
	
	# Add new value to encrypted string.
	sb	$t6, 0($a2)	# $t6 stores new cipher char at new address.
	addi	$a2, $a2, 1	# Update current register location for cipher address.
	
	j decode_loop_1		# Return to top of loop.
	
	exit_decode_loop:
	sb	$zero, 0($a2)	# Terminate the string.
	jr	$ra		# Return to main.

# Function variables: (address of cipher key, address of clear text, address of cipher text)
encode:
	# $a0 - KEY
	# $a1 - CLEAR TEXT
	# $a2 - CIPHER TEXT
	
	# NOTE: 32 to 126 are our maximum range of ascii values.
	# So we will want to mod our added shift value with 126 
	# and then set the final char to that.
	
	la	$t0, 0($a0)	# $t0 now holds KEY
	la	$t1, 0($a1)	# $t1 now holds CLEAR
	la	$t2, 0($a2)	# $t2 now holds CIPHER ADDRESS
	
	# Loop that iterates through $t0 to get number values to add to $t1.
	li	$t5, 0		# $t5 is our string clear message incrementor.
	li	$t7, 0		# $t7 is our cipher message incrementor.
	key_location_rst_e:
	li	$t3, 0		# $t3 is our incrementor for our KEY string.
	encode_loop_1:
	add	$t4, $t0, $t3	# $t4 now holds register location for current KEY char location.
	lb	$t4, 0($t4)	# $t4 now holds bit at current key location.
	beqz	$t4, key_location_rst_e
	addi	$t3, $t3, 1	# Increment $t3 for next key value.
	
	add	$t6, $t1, $t5	# $t6 now holds register location for current string char.
	lb	$t6, 0($t6)	# $t6 now holds bit at current key location.
	beqz	$t6, exit_encode_loop	# End of string. Exit.
	add	$t6, $t6, $t4	# $t6 now holds encrypted char value that could be outside of bounds.
	
	addi	$t8, $t6, 0	# $t8 will be a check value for modulo.
	
	div	$t6, $s7	# Divide value by 126 for modulo operation.
	mfhi	$t6		# $t6 now is the modulo of the above.
	
	# If $t8 and $t6 are no longer the same then we need to add 32.
	beq	$t6, $t8, en_offset_skip
	addi	$t6, $t6, 32	# Since $t6 is just an offset value?
	en_offset_skip:
	
	addi	$t5, $t5, 1	# Increment string location by one.
	
	# Add new value to encrypted string.
	sb	$t6, 0($a2)	# $t6 stores new cipher char at new address.
	addi	$a2, $a2, 1	# Update current register location for cipher address.
	
	j	encode_loop_1	# Return to top of loop.
	
	exit_encode_loop:
	sb	$zero, 0($a2)	# Terminate the string.
	jr	$ra		# Return to main.

# Prints new line.
print_newln:
	la	 $a0, newline_msg	# Load the string into $a0.
	li	 $v0, 4		  	# Print the msg.
	syscall 		 	# Run syscall.
	jr	$ra
	
	