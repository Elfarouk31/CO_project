.data
	op1: .asciiz "operation 1\n"
	op2: .asciiz "All list are destroyed\n"
	op3: .asciiz "operation 3\n"
	op4: .asciiz "mix all list in one is done\n"
	op5: .asciiz "operation 5\n"
	op6: .asciiz "operation 6\n"
	op7: .asciiz "operation 7\n"
	op8: .asciiz "operation 8\n"
	sort: .asciiz "All lists were sorted\n"
	sortByRq: .asciiz "Sort By Request\n"
	oneListDest: .asciiz " is idx of destroyed list\n"
	test1: .asciiz " is the actual value in actual_size["
	test2:  .asciiz "]\n"
	test3: .asciiz " is the actual value in last_idx["
	test4: .asciiz "]\n\n"
	

	str: .space 20
	.align 2
	pr: .word
	.align 2
	n: .word
	actual_size: .space 16
	last_idx: .space 16
	
.text

	main:
		
		# get user operation and store it in $t0
		jal scanUserOperation
		
		# while loop in the main function
		while:
			beq $t0, -1, exit
			beq $t0, 1, operation1
			beq $t0, 2, operation2
			beq $t0, 3, operation3
			beq $t0, 4, operation4
			beq $t0, 5, operation5
			beq $t0, 6, operation6
			beq $t0, 7, operation7
			beq $t0, 8, operation8
			
			continue:
				jal sort_all_lists
				jal scanUserOperation
				j while
		
		# if the user entered -1 then end the program		
		exit:
			li $v0, 10
			syscall
			

###################################################################################################	
	scanUserOperation:
		li $v0, 5
		syscall
		move $t0, $v0
		jr $ra	
###################################################################################################
	operation1:
		
		# scan an integer and store it in $a0
		li $v0, 5
		syscall
		move $a0, $v0
		sub $a0, $a0, 1  # first argument (x-1)
		
		# scan an integer and store it in $a1
		li $v0, 5
		syscall
		move $a1, $v0
		sub $a1, $a1, 1	# second argument (y-1)
		
		jal join_list_to_list
										
		j continue
###################################################################################################		
	operation2:
		jal destroy_all_list
		j continue
###################################################################################################		
	operation3:
		
		# scan the user request as text and store it in 'str'
		jal scanRequest
		
		# store the value of str[0] in $a0
		lbu $a0, str+0
		
		# scan an integer 'pr' and store it in $a2
		li $v0, 5
		syscall
		move $a2, $v0
		
		# get the exact length of the user request and store it in 'n'
		jal getlen
		
		# store the value of 'n' in $a1
		lw $a1, n
		
		jal update_request_data

		j continue
###################################################################################################		
	operation4:
		
		# scan the user request as text and store it in 'str'
		jal scanRequest
		
		# get the exact length of the user request and store it in 'n'
		jal getlen
		
		jal mix_all_list_in_one
		
		# store the value of str[0] in $a0
		lbu $a0, str+0
		
		# store the value of 'n' in $a1
		lw $a1, n
		
		jal find_with_request_usingBS
		
		j continue
###################################################################################################		
	operation5:
		
		# scan an integer 'pr' and store it in $a0
		li $v0, 5
		syscall
		move $a1, $v0
		
		jal mix_all_list_in_one
		
		move $a0, $a1
		
		jal find_with_priority_usingBF
		
		j continue
###################################################################################################		
	operation6:
		
		# scan the user request as text and store it in 'str'
		jal scanRequest
		
		# scan an integer 'pr' and store it in $a3
		li $v0, 5
		syscall
		move $a3, $v0
		
		# get the exact length of the user request and store it in 'n'
		jal getlen
		
		jal mix_all_list_in_one
		
		move $a0, $a3
		
		# store the value of str[0] in $a1
		lbu $a1, str+0
		
		# store the value of 'n' in $a2
		lw $a2, n
		
		jal find_with_priority_and_req_usingBF
		
		j continue
###################################################################################################		
	operation7:
		
		#scan a character from the user and store it in $a0
		li $v0, 12
		syscall
		move $a0, $v0
		
		#scan a character from the user for 'Enter' press
		li $v0, 12
		syscall
		
		jal erase_all_requests
		
		jal sort_list_by_priority
		
		jal print_all_requests
		
		j continue
###################################################################################################		
	operation8:
		
		# scan the user request as text and store it in 'str'
		jal scanRequest
		
		# scan an integer 'pr' and store it in $a2
		li $v0, 5
		syscall
		move $a2, $v0
		
		jal getlen
		
		# store the value of str[0] in $a0
		lbu $a0, str+0
		
		# store the value of 'n' in $a1
		lw $a1, n
		
		jal push
		
		j continue
###################################################################################################	
	join_list_to_list:
	
		# print x-1
		li $v0, 1
		syscall
		
		# print y-1
		li $v0, 1
		move $a0, $a1
		syscall
		
		jr $ra
	
###################################################################################################		
	getlen:
		
		addi $s0, $zero, 0 		# $s0 = 0
		    
		for:
			lbu $s1, str($s0) 	# $s1 = str[$s0]
			sge $s2, $s1, 97		# $s2 = ( str[$s0] >= 'a')
			sle $s3, $s1, 122		# $s3 = ( str[$s0] <= 'z')
			and $s2, $s2, $s3 	# $s2 = ($s2 && $s3)
			beq $s2, 0, endFor	# if($S2 == 0) go to 'endFor'
			addi $s0, $s0, 1		# $s0 = $s0 + 1 
			j for								# go to 'for'
			
			endFor:
				sw $s0, n
				jr $ra			
			
###################################################################################################				
	update_request_data:
		
		# print str[0]
		li $v0, 4
		la $a0, str($zero)
		syscall
		
		# print 'n'
		li $v0, 1
		move $a0, $a1
		syscall
		
		# print 'pr'
		li $v0, 1
		move $a0, $a2
		syscall
			
		jr $ra	
###################################################################################################								
	mix_all_list_in_one:
		li $v0, 4
		la $a0, op4
		syscall
		jr $ra
###################################################################################################																	
	find_with_request_usingBS:			
		# print str[0]
		li $v0, 4
		la $a0, str($zero)
		syscall
		
		# print 'n'
		li $v0, 1
		move $a0, $a1
		syscall
		
		jr $ra
###################################################################################################		
	find_with_priority_usingBF:
		
		# print 'pr'
		li $v0, 1
		syscall
		
		jr $ra
###################################################################################################				
	find_with_priority_and_req_usingBF:
		
		# print 'pr'
		li $v0, 1
		syscall
		
		# print str[0]
		li $v0, 4
		la $a0, str($zero)
		syscall
		
		# print 'n'
		li $v0, 1
		move $a0, $a2
		syscall
		
		jr $ra
###################################################################################################						
	erase_all_requests:
		
		li $v0, 1
		syscall
		jr $ra
	
###################################################################################################								
	sort_list_by_priority:
		
		li $v0, 4
		la $a0, op7
		syscall
		jr $ra
###################################################################################################									
	print_all_requests:
		
		li $v0, 4
		la $a0, op7
		syscall
		jr $ra
###################################################################################################												
		push:
			li $v0, 1
			syscall
			
			# print 'n'
			li $v0, 1
			move $a0, $a1
			syscall
			
			# print 'pr'
			li $v0, 1
			move $a0, $a2
			syscall
			
			jr $ra
		
###################################################################################################	
	scanRequest:
	
		li $v0, 8
		la $a0, str
		li $a1, 20
		syscall
		
		jr $ra
		
###################################################################################################	

sort_all_lists:
 
	addi $sp,$sp,-4
	sw $ra , 0($sp)
 
	addi $a0, $zero, 0
	jal sort_list_by_requsts
	addi $a0, $zero, 1
	jal sort_list_by_requsts
	addi $a0, $zero, 2
	jal sort_list_by_requsts
	addi $a0, $zero, 3
	jal sort_list_by_requsts
 
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
###################################################################################################	
	sort_list_by_requsts:
		li $v0, 4
		la $a0, sortByRq
		syscall
		jr $ra
###################################################################################################	

destroy_all_list:
	addi $sp,$sp,-4
	sw $ra , 0($sp)
 
	addi $a0, $zero, 0
	jal destroy_list
	addi $a0, $zero, 1
	jal destroy_list
	addi $a0, $zero, 2
	jal destroy_list
	addi $a0, $zero, 3
	jal destroy_list
 	
 
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
###################################################################################################	

destroy_list:
	addi $sp,$sp,-4
	sw $ra , 0($sp)
	
	mul $a0, $a0, 4							# multiplie idx by 4 to access actual_size properly
	
	sw $zero, actual_size($a0)	# actual_size[idx] = 0 
		
#testing1-------------------------------------------------
 	# store value of $a0 temporary
 	move $t1, $a0
 	# put value actual_size[idx] in $t2
 	lw $t2, actual_size($a0)
 	# print actual_size[idx]
 	li $v0, 1
	addi $a0, $t2, 0 	
	syscall
 	# print string
 	li $v0, 4
	la $a0, test1 
	syscall
	# print value of idx multiplied by 4
	li $v0, 1
	addi $a0, $t1, 0 	
	syscall
 	# print string
 	li $v0, 4
	la $a0, test2
	syscall
	# returing value of idx to $a0 
	move $a0, $t1
#-------------------------------------------------	
	
	sw $zero, last_idx($a0)	# last_idx[idx] = 0
 
#testing2-------------------------------------------------
 	# store value of $a0 temporary
 	move $t1, $a0
 	# put value last_idx[idx] in $t2
 	lw $t2, last_idx($a0)
 	# print last_idx[idx]
 	li $v0, 1
	addi $a0, $t2, 0 	
	syscall
 	# print string
 	li $v0, 4
	la $a0, test3 
	syscall
	# print value of idx multiplied by 4
	li $v0, 1
	addi $a0, $t1, 0 	
	syscall
 	# print string
 	li $v0, 4
	la $a0, test4
	syscall
#--------------------------------------------------	
 	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
	
###################################################################################################	
