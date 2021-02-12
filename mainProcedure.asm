.data
	last_idx: .space 16	#an array have four integer 'last_idx[4] -> C++'
	arr_of_str: .space 960#i->row & j-> col f(x)('i * size_0f_row' + 'j * size_0f_col')
	NL: .asciiz "\n" #New line
.text
update_request_data:	#char ch -> $a0 \| int s -> $a1  || int pID ->$a2
	li $t0, 0 # i = 0
	li $t1, 0 # j = 0
	la $t3, last_idx # array la last index last_idx[$t4]
	la $t5, arr_of_str
	
	first_loop:
	blt	$t0, 4, exit_loop
		sll $t4, $t0, 2
		addu $t4, $t4, $t3 # offset for "'i'.'last_index'" array.
		
		scound_loop:
		lw $s0, 0($t4) 
		blt	$t1, $s0, exit_loop
		
			mulo $t6, $t0, 240 #f(i) = (i * size_0f_row) =--> X
			mulo $t7, $t1, 12  #f(j) = (j * size_0f_col) =--> Y
			add $t8, $t6, $t7  #f(X,Y) = (X + Y) =--> Z
			addu $t8, $t8, $t5 # ( &arr_of_str[i][j] + Z ) =-->Z
			
			lw $s1, 0($t8)
			bne $s1, $a0, exit_loop
			
			lw $s2, 4($t8) 
			bne $s2, $a1, exit_loop
			sw $a2, 8($t8)
		j scound_loop
	j first_loop
			
#--------------------------------------------------------------
find_with_priority_usingBF:   # int pid -> $a0
	li $t0, 0 # i = 0
	li $t1, 0 # j = 0
	la $t3, last_idx # array la last index last_idx[$t4]
		
	f_loop:
	blt	$t0, 4, exit_loop
	
		li $v0, 1
		addi $a1, $t0, 0 
		syscall
		
		sll $t4, $t0, 2
		addu $t4, $t4, $t3 # offset for "'i'.'last_index'" array.
		
		s_loop:
		lw $s0, 0($t4) 
		blt	$t1, $s0, exit_loop
		
			mulo $t6, $t0, 240 #f(i) = (i * size_0f_row) =--> X
			mulo $t7, $t1, 12  #f(j) = (j * size_0f_col) =--> Y
			add $t8, $t6, $t7  #f(X,Y) = (X + Y) =--> Z
			addu $t8, $t8, $t5 # ( &arr_of_str[i][j] + Z ) =-->Z
			
			lw $s1, 8($t8) 
			bne $s1, $a0, exit_loop
			
			li $v0, 1
			addi $a2, $t8, 1
			syscall
			
			li $v0, 4
			la $a3, NL
			syscall
		j s_loop
		li $v0, 4
		la $a3, NL
		syscall
	j f_loop
	
#-----------------------------------------------------------
find_with_priority_and_req_usingBF: # int pid -> $a2 , char ch --> $a0  int s --> $a1
		li $t0, 0 # i = 0
		li $t1, 0 # j = 0
		la $t3, last_idx # array la last index last_idx[$t4]
		
		fir_loop:
		blt	$t0, 4, exit_loop
		
			li $v0, 1
			addi $a1, $t0, 0 
			syscall
			
			sll $t4, $t0, 2
			addu $t4, $t4, $t3 # offset for "'i'.'last_index'" array.
			
			sco_loop:
			lw $s0, 0($t4) 
			blt	$t1, $s0, exit_loop
			
				mulo $t6, $t0, 240 #f(i) = (i * size_0f_row) =--> X
				mulo $t7, $t1, 12  #f(j) = (j * size_0f_col) =--> Y
				add $t8, $t6, $t7  #f(X,Y) = (X + Y) =--> Z
				addu $t8, $t8, $t5 # ( &arr_of_str[i][j] + Z ) =-->Z
				
				lw $s1, 0($t8)
				bne $s1, $a0, exit_loop
				
				lw $s2, 4($t8) 
				bne $s2, $a1, exit_loop
				
				lw $s3, 8($t8)
				bne $s3, $a2, exit_loop
				sw $a2, 8($t8)
				
				li $v0, 1
				addi $a2, $t1, 1
				syscall
			j sco_loop
			li $v0, 4
			la $a3, NL
			syscall
		j fir_loop
	
exit_loop:
