.data

	last_idx_res: .word
										0											12										24											36
	res: .space 960 # |4 byte 4 byte 4 byte | 4 byte 4 byte 4 byte | 4 byte 4 byte 4 byte |.....|
									# char 		int 		int

.text


	find_with_request_usingBS:

		addi $t1, $zero, 0				# lo = 0
		lw $t2, last_idx_res			#	hi = last_idx_res

		addi $t3, $zero, 0				# med = 0 // med multiplied by 4 for memory access
		addi $t7, $zero, 0				# med = 0 // normal med

		addi $t4, $zero, 0 				# first_occcurece = 0
		addi $t5, $zero, -1				#last_occcurece = -1

		#-----------------------------------------------
		while1:
			bgt $t1, $t2, whileEnd1
			# checking for first if---------------------------------------------------------
			add $t6, $t1, $t2		# $t6 = lo + hi
			div $t3, $t6, 2			# med = $t6/2
			div $t7, $t6, 2			# med = $t6/2
			la $t6, res					# $t6 = res
			mul $t3, $t3, 12		# med = med * 12
			add $t6, $t6, $t3		# $t6 = res[med]
			move $s6, $t6				# $s6 = $t6 = res[med]
			lw $t6, 0($t6)			# $t6 = res[med].c  // derefrancing from pointer to value

			sgt $s0, $t6, $a0		# $s0 = (res[med].c > ch)
			seq $s1, $t6, $a0		# $s1 = (res[med].c	== ch)
			move $t6, $s6				# $t6 = $s6 = res[med] // derefrancing from value to pointer
			lw $t6, 4($t6)			# $t6 = res[med].nofc
			sgt $s2, $t6, $a1		# $s2 = (res[med].nofc > s)
			and $s3 ,$s2, $s1		#	$s3 = (res[med].c	== ch) && (res[med].nofc > s)
			or $s4, $s0, $s3 		# $s4 = (res[med].c > ch) }} (res[med].c	== ch) && (res[med].nofc > s)
			not $s4, $s4				# $s4 = ! $s4
			beq $s4, $zero, assignHigh
				assignHigh:
					addi $t2, $t7, -1
					j while1
			# end of checking for first if---------------------------------------------------------
			# checking for second if---------------------------------------------------------
			add $t6, $t1, $t2		# $t6 = lo + hi
			div $t3, $t6, 2			# med = $t6/2
			div $t7, $t6, 2			# med = $t6/2
			la $t6, res					# $t6 = res
			mul $t3, $t3, 12		# med = med * 12
			add $t6, $t6, $t3		# $t6 = res[med]
			move $s6, $t6				# $s6 = $t6 = res[med]
			lw $t6, 0($t6)			# $t6 = res[med].c  // derefrancing from pointer to value

			slt $s0, $t6, $a0		# $s0 = res[med].c<ch
			seq $s1, $t6, $a0		# $s1 = (res[med].c	== ch)
			move $t6, $s6				# $t6 = $s6 = res[med] // derefrancing from value to pointer
			lw $t6, 4($t6)			# $t6 = res[med].nofc
			slt $s2, $t6, $a1		# $s2 = res[med].nofc<s
			and $s3 ,$s2, $s1		#	$s3 = (res[med].c	== ch) && res[med].nofc<s
			or $s4, $s0, $s3 		# $s4 = (res[med].c<ch||(res[med].c==ch&&res[med].nofc<s))
			not $s4, $s4				# $s4 = ! $s4
			beq $s4, $zero, assignlo
				assignlo:
					addi $t1, $t7, 1
					j while1
			# end of checking for second if---------------------------------------------------------
			# else
				add $t4, $zero, $t7
				assignH:
					addi $t2, $t7, -1
					j while1
			# end of checking for else---------------------------------------------------------
#-----------------------------------------------
#-----------------------------------------------
#-----------------------------------------------
#-----------------------------------------------
#-----------------------------------------------


		
		#-----------------------------------------------
		while2:
			bgt $t1, $t2, whileEnd2
			# checking for first if---------------------------------------------------------
			add $t6, $t1, $t2		# $t6 = lo + hi
			div $t3, $t6, 2			# med = $t6/2
			div $t7, $t6, 2			# med = $t6/2
			la $t6, res					# $t6 = res
			mul $t3, $t3, 12		# med = med * 12
			add $t6, $t6, $t3		# $t6 = res[med]
			move $s6, $t6				# $s6 = $t6 = res[med]
			lw $t6, 0($t6)			# $t6 = res[med].c  // derefrancing from pointer to value

			sgt $s0, $t6, $a0		# $s0 = (res[med].c > ch)
			seq $s1, $t6, $a0		# $s1 = (res[med].c	== ch)
			move $t6, $s6				# $t6 = $s6 = res[med] // derefrancing from value to pointer
			lw $t6, 4($t6)			# $t6 = res[med].nofc
			sgt $s2, $t6, $a1		# $s2 = (res[med].nofc > s)
			and $s3 ,$s2, $s1		#	$s3 = (res[med].c	== ch) && (res[med].nofc > s)
			or $s4, $s0, $s3 		# $s4 = (res[med].c > ch) }} (res[med].c	== ch) && (res[med].nofc > s)
			not $s4, $s4				# $s4 = ! $s4
			beq $s4, $zero, assignhhh
				assignhhh:
					addi $t2, $t7, -1
					j while2
			# end of checking for first if---------------------------------------------------------
			# checking for second if---------------------------------------------------------
			add $t6, $t1, $t2		# $t6 = lo + hi
			div $t3, $t6, 2			# med = $t6/2
			div $t7, $t6, 2			# med = $t6/2
			la $t6, res					# $t6 = res
			mul $t3, $t3, 12		# med = med * 12
			add $t6, $t6, $t3		# $t6 = res[med]
			move $s6, $t6				# $s6 = $t6 = res[med]
			lw $t6, 0($t6)			# $t6 = res[med].c  // derefrancing from pointer to value

			slt $s0, $t6, $a0		# $s0 = res[med].c<ch
			seq $s1, $t6, $a0		# $s1 = (res[med].c	== ch)
			move $t6, $s6				# $t6 = $s6 = res[med] // derefrancing from value to pointer
			lw $t6, 4($t6)			# $t6 = res[med].nofc
			slt $s2, $t6, $a1		# $s2 = res[med].nofc<s
			and $s3 ,$s2, $s1		#	$s3 = (res[med].c	== ch) && res[med].nofc<s
			or $s4, $s0, $s3 		# $s4 = (res[med].c<ch||(res[med].c==ch&&res[med].nofc<s))
			not $s4, $s4				# $s4 = ! $s4
			beq $s4, $zero, assignlooo
				assignlooo:
					addi $t1, $t7, 1
					j while2
			# end of checking for second if---------------------------------------------------------
			# else
				add $t4, $zero, $t7
				assignloooooo:
					addi $t2, $t7, +1
					j while2
			# end of checking for else---------------------------------------------------------

whileEnd1:
		addi $t1, $zero, 0				# lo = 0
		lw $t2, last_idx_res			#	hi = last_idx_res
		addi $t3, $zero, 0				# med = 0 // med multiplied by 4 for memory access
		addi $t7, $zero, 0				# med = 0 // normal med
		addi $t4, $zero, 0 				# first_occcurece = 0
		addi $t5, $zero, -1				#last_occcurece = -1
		j while2
	
whileEnd2:
	jr $ra
