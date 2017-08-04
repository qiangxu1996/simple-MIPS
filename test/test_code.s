# To test the pipelined mips

			.text
			addi $s1, $zero, 10
			add $s2, $s1, $s1
			addiu $s3, $s1, 15
			and $s4, $s2, $s3
			sltu $t1, $s2, $s1
			andi $s2, $s2, 0x1111
			nor $s0, $s2, $s4
br2:		slt $t0, $s1, $s2
			bne $t0, $zero, br1
			or $s5, $s1, $s3
br1:		ori $s5, $s1, 0x2345
			sll $s6, $s2, 3
			sllv $s7, $s3, $s6
			slti $t2, $s5, 45
			bgtz $zero, br2
			sra $s4, $s5, 5
			srav $s0, $s1, $s2
			sltiu $t3, $s5, -7
			srl $s2, $s4, 2
			beq $s2, $s2, br3
br3:		srlv $s3, $s3, $s3
			sub $s3, $s3, $s3
			subu $s4, $s5, $s7
			xor $s5, $s1, $s0
			xori $s0, $s1, 100
repeat:		j repeat
