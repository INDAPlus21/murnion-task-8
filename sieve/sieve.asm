### Data Declaration Section ###

.data

primes:		.space  1000            # reserves a block of 1000 bytes in application memory
err_msg:	.asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"
space:		.asciiz "\n"

### Executable Code Section ###

.text

main:
    # get input
    li      $v0,5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0

    # validate input
    li 	    $t0,1001                # $t0 = 1001
    slt	    $t1,$v0,$t0		        # $t1 = input < 1001
    beq     $t1,$zero,invalid_input # if !(input < 1001), jump to invalid_input
    nop
    li	    $t0,1                   # $t0 = 1
    slt     $t1,$t0,$v0		        # $t1 = 1 < input
    beq     $t1,$zero,invalid_input # if !(1 < input), jump to invalid_input
    nop
    
    # initialise primes array
    la	    $t0,primes              # $s1 = address of the first element in the array
    li 	    $t1,999
    li 	    $t2,0
    li	    $t3,1
init_loop:
    sb	    $t3, ($t0)              # primes[i] = 1
    addi    $t0, $t0, 1             # increment pointer
    addi    $t2, $t2, 1             # increment counter
    bne	    $t2, $t1, init_loop     # loop if counter != 999
    nop
    
    li $t1, 2 #counter for the first loop, also the number to print
    li $t2, 0 #counter for the second loop
    li $t3, 1 #used to compare and confirm primes
    move $v1, $v0 #i need v0 to syscall..
    
loop: #start of loop
	la $t0, primes
	add $t0, $t0, $t1
	lb $t0, ($t0)
	beq $t0, $0, eol #if this number isnt a prime, no need to sieve it
	move $a0, $t1 #set the arg0 to the current prime
	li $v0, 1
	syscall #print the prime
	la $a0, space
	li $v0, 4
	syscall
	move $t2, $t1 #set the second loop counter to our current prime
	nested:
		add $t2, $t2, $t1 #increment by the prime
		bgt $t2, $v1, eol #if the counter is greater than our input number, end the loop
		la $t0, primes
		add $t0, $t0, $t2
		sb $0, ($t0) #set the prime at the counter to 0, because its NOT A PRIME!
		j nested #jump to nested :)
eol: # "end of loop", but like, end of nested loop lol
	addi $t1, $t1, 1 #increment the prime counter
	bgt $t1, $v1, exit_program #if our counter is greater, then we've reached the end!
	j loop #otherwise, loop :)
	
    j       exit_program
    nop

invalid_input:
    # print error message
    li      $v0, 4                  # set system call code "print string"
    la      $a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message to standard output stream

exit_program:
    # exit program
    li $v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program