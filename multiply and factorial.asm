.globl multiply
.globl factorial

main:
	li $a0, 10
	li $a1, 5
	
	jal factorial
	nop
	
	addi $a0, $v1, 0x0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

multiply:
	add $t0, $0, $a0
	add $t1, $0, $0
	ml1:
	add $t1, $t1, $a1
	subi $t0, $t0, 1
	bne $0, $t0, ml1
	nop
	addi $v0, $t1, 0x0
	jr $ra
	nop
	
factorial:
	add $t2, $0, $a0
	add $v1, $0, $a0
	add $t7, $ra, 0x0
	fc1:
	subi $t2, $t2, 1
	beq $t2, 0x0, end
	nop
	addi $a0, $t2, 0
	addi $a1, $v1, 0
	jal multiply
	nop
	addi $v1, $v0, 0 
	j fc1
	nop
	end:
	jr $t7
	
	
