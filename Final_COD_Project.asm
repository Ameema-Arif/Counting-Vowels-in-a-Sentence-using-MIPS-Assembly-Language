.data	
	msg1: .asciiz "Enter your sentence : "
	msg2: .asciiz "Total no. of A's in the sentence are: "
	msg3: .asciiz "\nTotal no of E's in the sentence are: "
	msg4: .asciiz "\nTotal no of I's in the sentence are: "
	msg5: .asciiz "\nTotal no of O's in the sentence are: "
	msg6: .asciiz "\nTotal no of U's in the sentence are: "
	msg7: .asciiz "\nTotal no. of vowels in the sentence : "
	msg8: .asciiz "\nNo sentence is given as input."
	msg9: .asciiz "\nGiven sentence contain no vowels."
	msg10: .asciiz "\nPress 1 to continue OR Press any other key to Exit : "
	msg11: .asciiz "\nProgram is Ending..."
	vowel_a: .asciiz  "Aa"
	vowel_e: .asciiz "Ee"
	vowel_i: .asciiz  "Ii"
	vowel_o: .asciiz  "Oo"
	vowel_u: .asciiz  "Uu"
	input: .space 300
	

.text
.globl main
.ent main
main:
Loop:
	li $v0,4				#printing msg1 for input
	la $a0,msg1
	syscall		
	
	li $v0,8				#taking string input
	la $a0,input				#string input to be stored in space allocated to "input"
	li $a1,300				#max length of the string input would be 300
	syscall

	move $a2,$a0				#moving input string to $a2
	addi $a3,$a2,0

	jal counting				#calling procedure "counting" for counting the no. of vowels in the given input

	la $t0,input				#loading base address of "input" in $t0 to check that either string input is given or not
	addi $t0,$t0,2				#to make it equal to $s0 when no input is given
	move $t1,$v1				#moving the total no. of vowels from $v0 to $t2

	beq $t1,$t0,No_String_End		#branch to No_String_End when $t0 is equal to the last fetched character's address i.e.$t1 
	beq $t1,$0,No_Vowel_End			#branch to No_Vowel_End when the final ans is 0

	li $v0,4				#printing msg for displaying output
	la $a0,msg7
	syscall		
	
	li $v0,1				#preparing for integer output
	move $a0,$t1
	syscall					#output is displayed on the screen
	j Choice_For_End_or_Rerun		#jump to Choice_For_End_or_Rerun to end the program

No_String_End:
	li $v0,4				#printing msg for that case when no input is given
	la $a0,msg8
	syscall	
	j Choice_For_End_or_Rerun		#jump to Choice_For_End_or_Rerun to end the program

No_Vowel_End:
	li $v0,4				#printing msg for that case when the input sentence has no vowels in it
	la $a0,msg9
	syscall	
	j Choice_For_End_or_Rerun		#jump to Choice_For_End_or_Rerun to end the program

Choice_For_End_or_Rerun:
	li $v0,4				#printing msg to ask that whether the user wants to exit or wants to re-run the program
	la $a0,msg10
	syscall	

	li $v0,5				#taking no. input which defines user's choice
	syscall
	
	move $t2,$v0				#moving no. input to $t2 from $v0				
	addi $t3,$zero,1			#loading 1 in $t3 for its comparison with the no. input given by user

	bne $t2,$t3,Final_End			#branch to Final_End if user haven't enter 1 to continue the program
	j Loop					#if user entered 1 then jump to loop i.e.run the program again
	

Final_End:
	li $v0,4				#printing end msg
	la $a0,msg11
	syscall	

	li $v0,10				#coming out of the loop
	syscall			

.end main					#ending main



.globl counting
.ent counting
counting:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to main after completion of counting
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values(if any)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)
	
	addi $s0,$a2,0				#input string moved to $s0
	addi $s3,$0,0				#initializing counter for vowel a
	addi $s4,$0,0				#initializing counter for vowel e
	addi $s5,$0,0				#initializing counter for vowel i
	addi $s6,$0,0				#initializing counter for vowel o
	addi $s7,$0,0				#initializing counter for vowel u

string:
	lb $s1,0($s0)				#fetching a single char from string and storing it in $s1
	addi $s0,$s0,1				#now $s0 points to next string character
	beq $s1,$0,String_Over			#if string ends branch to "String_Over"
	move $a2,$s1 				#moving the fetched char from $s1 to $a2

	jal A					#calling procedure "A" to compare the char with A and a
	
	nor $s2,$s2,$0				#clearing $s2
	move $s2,$v0				#moving the ans of procedure A from $v0 to $s2
	
	blez $s2,ForE				#if $s2=0 i.e. if the char doesn't match with capital & small A then branch to "ForE"
	add $s3,$s3,$s2				#if $s2 > 0 ,then add $s2(which is 1) in $s3
	j string				#jump to string to fetch the next char

ForE:
	move $a2,$s1 				#moving the fetched char from $s1 to $a2

	jal E					#calling procedure "E" to compare the char with E and e
	
	nor $s2,$s2,$0				#clearing $s2 to store a new value in it
	move $s2,$v0				#moving the ans of procedure E from $v0 to $s2

	blez $s2,ForI				#if $s2=0 i.e. if the char doesn't match with capital and small E then branch to "ForI"
	add $s4,$s4,$s2				#if $s2 > 0 ,then add $s2(which is 1) in $s4
	j string				#jump to string to fetch the next char

ForI:
	move $a2,$s1 				#moving the fetched char from $s1 to $a2

	jal I					#calling procedure "I" to compare the char with I and i
	
	nor $s2,$s2,$0				#clearing $s2 to store a new value in it
	move $s2,$v0				#moving the ans of procedure I from $v0 to $s2

	blez $s2,ForO				#if $s2=0 i.e. if the char doesn't match with capital and small I then branch to "ForO"
	add $s5,$s5,$s2				#if $s2 > 0 ,then add $s2(which is 1) in $s5
	j string				#jump to string to fetch the next char

ForO:
	move $a2,$s1 				#moving the fetched char from $s1 to $a2

	jal O					#calling procedure "O" to compare the char with O and o
	
	nor $s2,$s2,$0				#clearing $s2 to store a new value in it
	move $s2,$v0				#moving the ans of procedure O from $v0 to $s2

	blez $s2,ForU				#if $s2=0 i.e. if the char doesn't match with capital and small O then branch to "ForU"
	add $s6,$s6,$s2				#if $s2 > 0 ,then add $s2(which is 1) in $s6
	j string				#jump to string to fetch the next char

ForU:
	move $a2,$s1 				#moving the fetched char from $s1 to $a2

	jal U					#calling procedure "U" to compare the char with U and u
	
	nor $s2,$s2,$0				#clearing $s2 to store a new value in it
	move $s2,$v0				#moving the ans of procedure U from $v0 to $s2

	blez $s2,string				#if $s2=0 i.e. if the char doesn't match with capital and small U 
						#then branch to string to fetch the next char from input

	add $s7,$s7,$s2				#if $s2 > 0 ,then add $s2(which is 1) in $s7
	j string				#jump to string to fetch the next char


String_Over:
	nor $s2,$s2,$0				#clearing $s2 to check the first condition
	move $s2,$a3				#moving "input" base address from $a3 to $s2
	addi $s2,$s2,2				#adding 2 in $s2 because  when String_Over is executed,$s0=base_address+2,in order to check that 
						#whether only the first char is null or there's  no input present at all
	beq $s2,$s0,No_String			#branch to No_String when $s2=$s0 which means that there's is no input present

	nor $s2,$s2,$0				#clearing $s2 to store the total no. of vowels in it 
	add $s2,$s3,$s4				#adding total no. of A's and E's and storing in $s2
	add $s2,$s2,$s5				#adding total no. of I's in previous sum
	add $s2,$s2,$s6				#adding total no. of O's in previous sum
	add $s2,$s2,$s7				#adding total no. of U's in previous sum

	beq $s2,$0,No_Vowel			#if the total no. of vowels is zerp i.e. the sentence has no vowels in it,then branch to No_Vowel
	
	move $v1,$s2				#moving the total no. of vowels from $s2 to $v1	when the input is not null and also contain vowels.

	li $v0,4				#printing msg to display the total no. of A's in the sentence
	la $a0,msg2
	syscall

	li $v0,1				#printing the total no. of A's
	move $a0,$s3				#moving total no. of A's from $s3 to $a0
	syscall	

	li $v0,4				#printing msg to display the total no. of E's in the sentence
	la $a0,msg3
	syscall

	li $v0,1				#printing the total no. of E's
	move $a0,$s4				#moving total no. of E's from $s4 to $a0
	syscall	

	li $v0,4				#printing msg to display the total no. of I's in the sentence
	la $a0,msg4
	syscall

	li $v0,1				#printing the total no. of I's
	move $a0,$s5				#moving total no. of I's from $s5 to $a0
	syscall	

	li $v0,4				#printing msg to display the total no. of O's in the sentence
	la $a0,msg5
	syscall

	li $v0,1				#printing the total no. of O's
	move $a0,$s6				#moving total no. of O's from $s6 to $a0
	syscall	

	li $v0,4				#printing msg to display the total no. of U's in the sentence
	la $a0,msg6
	syscall

	li $v0,1				#printing the total no. of U's
	move $a0,$s7				#moving total no. of U's from $s7 to $a0
	syscall	

	j End					#jumping to end to return to main			

No_String:
	move $v1,$s2				#moving 0 from $s2 to $v1
	j End					#jumping to end to return to main

No_Vowel:
	move $v1,$s2				#moving $s2(i.e.base address+2) to $v1
	j End					#jumping to end to return to main

	
End:
	lw $ra,0($sp)				#loading the return address of main in $ra from stack
	lw $s0,4($sp)				#loading back all the previous values of saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position

	jr $ra					#return to main from where the counting procedure was called
.end counting					#ending "counting"


A:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to counting after completion of A
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)

	addi $s0,$a2,0				#fetched char moved to $s0
	addi $s3,$0,0				#initializing $s3 to know whether the fetched char is matched with A or not

	la $s1,vowel_a				#loading base address of "vowel_a" in $s1

Acheck:
	lb $s2,0($s1)				#fetching a single char from "vowel_a" string & storing it in $s2
	beq $s2,$0,endA				#if $s2=$0 i.e. vowel_a string is ended and the fetched char from has been compared with both A & a.
						#Hence branch to "endA"

	addi $s1,$s1,1				#adding 1 in $s1 so it points to the next char of vowel_a string 
	bne $s0,$s2,Acheck			#if the input fetched char and char fetched from vowel_a aren't equal
						#then branch again to Acheck to repeat the same process for next char of vowel_a

	addi $s3,$s3,1				#if input string char matches to A or a then add 1 in $s3 
	j endA					#jump to endA

endA:
	move $v0,$s3				#moving $s3(which contains 1 if the char matches with A or a 
						#and contains 0 when the char doesn't match with any A) to $v0
	
	lw $ra,0($sp)				#loading the return address of "counting" in $ra from stack
	lw $s0,4($sp)				#loading the previous values of all the saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position 

	jr $ra					#return to "counting" from where the procedue "A" was called
.end A						#ending "A"
	


E:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to counting after completion of E
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)

	addi $s0,$a2,0				#fetched char moved to $s0		
	addi $s3,$0,0				#initializing $s3 to know whether the fetched char is matched with E or not

	la $s1,vowel_e				#loading base address of "vowel_e" in $s1

Echeck:
	lb $s2,0($s1)				#fetching a single char from "vowel_e" string & storing it in $s2
	beq $s2,$0,endE				#if $s2=$0 i.e. vowel_e string is ended and the fetched char from has been compared with both E & e
						#Hence branch to "endE"

	addi $s1,$s1,1				#adding 1 in $s1 so it points to the next char of vowel_e string 
	bne $s0,$s2,Echeck			#if the input fetched char and char fetched from vowel_e aren't equal
						#then branch again to Echeck to repeat the same process for next char of vowel_e

	addi $s3,$s3,1				#if input string char matches to E or e then add 1 in $s3
	j endE					#jump to endE

endE:
	move $v0,$s3				#moving $s3(which contains 1 if the char matches with E or e
						#and contains 0 when the char doesn't match with any E) to $v0				
	
	lw $ra,0($sp)				#loading the return address of "counting" in $ra from stack
	lw $s0,4($sp)				#loading the previous values of all the saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position 

	jr $ra					#return to "counting" from where the procedue "E" was called
.end E						#ending "E"


I:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to counting after completion of I
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)

	addi $s0,$a2,0				#fetched char moved to $s0		
	addi $s3,$0,0				#initializing $s3 to know whether the fetched char is matched with I or not

	la $s1,vowel_i				#loading base address of "vowel_i" in $s1

Icheck:
	lb $s2,0($s1)				#fetching a single char from "vowel_i" string & storing it in $s2
	beq $s2,$0,endI				#if $s2=$0 i.e. vowel_i string is ended and the fetched char from has been compared with both I & i.
						#Hence branch to "endI"

	addi $s1,$s1,1				#adding 1 in $s1 so it points to the next char of vowel_i string 
	bne $s0,$s2,Icheck			#if the input fetched char and char fetched from vowel_i aren't equal
						#then branch again to Icheck to repeat the same process for next char of vowel_i

	addi $s3,$s3,1				#if input string char matches to I or i then add 1 in $s3
	j endI					#jump to endI

endI:
	move $v0,$s3				#moving $s3(which contains 1 if the char matches with I or i 
						#and contains 0 when the char doesn't match with any I) to $v0
	
	lw $ra,0($sp)				#loading the return address of "counting" in $ra from stack
	lw $s0,4($sp)				#loading the previous values of all the saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position 

	jr $ra					#return to "counting" from where the procedue "I" was called
.end I						#ending "I"


O:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to counting after completion of O
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)

	addi $s0,$a2,0				#fetched char moved to $s0		
	addi $s3,$0,0				#initializing $s3 to know whether the fetched char is matched with O or not

	la $s1,vowel_o				#loading base address of "vowel_o" in $s1

Ocheck:
	lb $s2,0($s1)				#fetching a single char from "vowel_o" string & storing it in $s2
	beq $s2,$0,endO				#if $s2=$0 i.e. vowel_o string is ended and the fetched char from has been compared with both O & o
						#Hence branch to "endO"

	addi $s1,$s1,1				#adding 1 in $s1 so it points to the next char of vowel_o string 
	bne $s0,$s2,Ocheck			#if the input fetched char and char fetched from vowel_o aren't equal
						#then branch again to OAcheck to repeat the same process for next char of vowel_o

	addi $s3,$s3,1				#if input string char matches to O or o then add 1 in $s3
	j endO					#jump to endO

endO:
	move $v0,$s3				#moving $s3(which contains 1 if the char matches with O or o
						#and contains 0 when the char doesn't match with any O) to $v0
	
	lw $ra,0($sp)				#loading the return address of "counting" in $ra from stack
	lw $s0,4($sp)				#loading the previous values of all the saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position 

	jr $ra					#return to "counting" from where the procedue "O" was called
.end O						#ending "O"


U:
	addi $sp,$sp,-36			#setting stack pointer
	sw $ra,0($sp)				#storing return address to link back to counting after completion of U
	sw $s0,4($sp)				#storing all the saved registers in stack to preserve their previous values
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	sw $s6,28($sp)
	sw $s7,32($sp)

	addi $s0,$a2,0				#fetched char moved to $s0	
	addi $s3,$0,0				#initializing $s3 to know whether the fetched char is matched with U or not

	la $s1,vowel_u				#loading base address of "vowel_u" in $s1

Ucheck:
	lb $s2,0($s1)				#fetching a single char from "vowel_u" string & storing it in $s2
	beq $s2,$0,endU				#if $s2=$0 i.e. vowel_u string is ended and the fetched char from has been compared with both U & u.
						#Hence branch to "endU"

	addi $s1,$s1,1				#adding 1 in $s1 so it points to the next char of vowel_u string 
	bne $s0,$s2,Ucheck			#if the input fetched char and char fetched from vowel_u aren't equal
						#then branch again to Ucheck to repeat the same process for next char of vowel_u

	addi $s3,$s3,1				#if input string char matches to U or u then add 1 in $s3
	j endU					#jump to endU

endU:
	move $v0,$s3				#moving $s3(which contains 1 if the char matches with U or u 
						#and contains 0 when the char doesn't match with any U) to $v0
	
	lw $ra,0($sp)				#loading the return address of "counting" in $ra from stack
	lw $s0,4($sp)				#loading the previous values of all the saved registers from stack
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	lw $s6,28($sp)
	lw $s7,32($sp)
	addi $sp,$sp,36				#setting the stack pointer back to the previous position 

	jr $ra					#return to "counting" from where the procedue "U" was called
.end U						#ending "U"
	
	
