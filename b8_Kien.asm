.data
inputMessage: .asciiz "Nhap chuoi can luu: "
hex: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' 
arr: .space 100
str: .space 1000
enter: .asciiz "/n"
errorMessage: .asciiz "Do dai chuoi khong chia het cho 8. Hay nhap lai \n\n"
m: .asciiz "      Disk 1                 Disk 2               Disk 3\n"
m2: .asciiz "----------------       ----------------       ----------------\n"
m3: .asciiz "|     "
m4: .asciiz "     |       "
m5: .asciiz "[[ "
m6: .asciiz "]]       "
comma: .asciiz ","
again: .asciiz "Them lan nua?"
tmpStr: .space 100

.text
	
	
	


input:
	li $v0,4 
	la $a0,inputMessage #In ra inputMessage - yeu cau nhap chuoi
	syscall
	
	li $v0, 8  ## luu chuoi vao str
	la $a0, str
	li $a1, 100
	syscall
	
	move $s0, $a0		# s0 luu dia cua str
	
	
	#Check str length co chia het cho 8
	li $t0,0  # t0 = length
	li $t1,0  # t1 = count
	
countLength:
	add $t2, $s0, $t0 # t2  = dia chi str
	lb $t3, 0($t2)  # load tung byte t3 = str[i]
	nop
	beq $t3,10,divisible_8  # if t3 = '\n' => check chia het cho 8, ket thuc xau
	nop
	addi $t0,$t0,1 #length++
	addi $t1,$t1,1 #count++
	j countLength
	nop
	

 divisible_8:	
 	li $s1,8 #load 8
 	div $t1,$s1 # chia count cho 8
 	mfhi $s2 # load so du ve t0
	beq $s2,0,tinhToan	 	 
 	
 error_chia8du:
 	li $v0, 4
 	la $a0, errorMessage # chia 8 ma du thi in ra loi va tro lai => input
	syscall
	j input
 	
 	#done
 tinhToan:
			
	#in cac disk
	li $v0, 4
	la $a0, m
	syscall
	li $v0, 4
	la $a0, m2
	syscall
	#done
	
	#tinh so lan lap line
	mflo $s2  # s2 = so lan lap line
	li $a2,0 # count line
	
	
	addi $t0,$s0,0 # t0= dia chi goc
	li $t2,1 # type line
line:
	#xac dinh dia chi dau tien cua line
	addi $t1,$t0,4, # t0 la dia chi 4 phan tu block 1, t1 la dia chi 4 block sau
	
	addi  $a2, $a2,1 #count line ++
	bgt  $a2,$s2,end
	
	#tinh parity
	#parity 1
	lb $s3, 0($t0) 
	lb $s4, 0 ($t1)
	xor $t5 , $s3,$s4 # xor 2 bit dau 2 block
	#parity 2
	lb $s3, 1($t0) 
	lb $s4, 1 ($t1)
	xor $t6 , $s3,$s4 # xor 2 bit dau 2 block
	#parity 3
	lb $s3, 2($t0) 
	lb $s4, 2 ($t1)
	xor $a3 , $s3,$s4 # xor 2 bit dau 2 block
	#parity 4
	lb $s3, 3($t0) 
	lb $s4, 3 ($t1)
	xor $t8 , $s3,$s4 # xor 2 bit dau 2 block
	
	li $t3,3
	div $t2,$t3
	mfhi $s5
	beq $s5,0,printLine3
	beq $s5,1, printLine1
	beq $s5,2,printLine2

printLine1:

	#block1
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t0) 
	sb $s7,0($s6)
	
	lb $s7, 1($t0) 
	sb $s7,1($s6)
	
	lb $s7, 2($t0) 
	sb $s7,2($s6)
	
	lb $s7, 3($t0) 
	sb $s7,3($s6)
	
	
	
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
	
	
	li $v0, 4		
	la $a0, m4
	syscall
	
	#block 2
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t1) 
	sb $s7,0($s6)
	
	lb $s7, 1($t1) 
	sb $s7,1($s6)
	
	lb $s7, 2($t1) 
	sb $s7,2($s6)
	
	lb $s7, 3($t1) 
	sb $s7,3($s6)
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
			
	li $v0, 4		
	la $a0, m4
	syscall		

	#block3
	li $v0, 4		
	la $a0, m5
	syscall	

	add $t9,$zero,$t5
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall	
	
	add $t9,$zero,$t6
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$a3
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$t8
	jal HEX
	


	
	li $v0, 4		
	la $a0, m6
	syscall	

	li $v0, 11 
	li $a0, 10
	syscall 
	
	j congDiaChi

printLine2:

	#block1
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t0) 
	sb $s7,0($s6)
	
	lb $s7, 1($t0) 
	sb $s7,1($s6)
	
	lb $s7, 2($t0) 
	sb $s7,2($s6)
	
	lb $s7, 3($t0) 
	sb $s7,3($s6)
	
	
	
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
	
	
	li $v0, 4		
	la $a0, m4
	syscall

	#block3
	li $v0, 4		
	la $a0, m5
	syscall	

	add $t9,$zero,$t5
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall	
	
	add $t9,$zero,$t6
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$a3
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$t8
	jal HEX
	
	li $v0, 4		
	la $a0, m6
	syscall	
			
	#block 2
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t1) 
	sb $s7,0($s6)
	
	lb $s7, 1($t1) 
	sb $s7,1($s6)
	
	lb $s7, 2($t1) 
	sb $s7,2($s6)
	
	lb $s7, 3($t1) 
	sb $s7,3($s6)
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
			
	li $v0, 4		
	la $a0, m4
	syscall		



	li $v0, 11 
	li $a0, 10
	syscall 
	
	j congDiaChi
	
printLine3:

	#block3
	li $v0, 4		
	la $a0, m5
	syscall	

	add $t9,$zero,$t5
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall	
	
	add $t9,$zero,$t6
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$a3
	jal HEX
	
	li $v0, 4		
	la $a0, comma
	syscall
	
	add $t9,$zero,$t8
	jal HEX
	


	
	li $v0, 4		
	la $a0, m6
	syscall

	#block1
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t0) 
	sb $s7,0($s6)
	
	lb $s7, 1($t0) 
	sb $s7,1($s6)
	
	lb $s7, 2($t0) 
	sb $s7,2($s6)
	
	lb $s7, 3($t0) 
	sb $s7,3($s6)
	
	
	
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
	
	
	li $v0, 4		
	la $a0, m4
	syscall
	
	#block 2
	li $v0, 4		
	la $a0, m3
	syscall
	
	la $s6, tmpStr
	
	lb $s7, 0($t1) 
	sb $s7,0($s6)
	
	lb $s7, 1($t1) 
	sb $s7,1($s6)
	
	lb $s7, 2($t1) 
	sb $s7,2($s6)
	
	lb $s7, 3($t1) 
	sb $s7,3($s6)
	
	li $v0, 4
	la  $a0, tmpStr 
	syscall
			
	li $v0, 4		
	la $a0, m4
	syscall		

		

	li $v0, 11 
	li $a0, 10
	syscall 	
	
	j congDiaChi


congDiaChi:
	addi $t2,$t2,1#t2++, line type++
	addi $t0,$t0,8 # cong dia chi dau tien len 8
	j line

HEX:	li $t4, 7
loopH:	blt $t4, $0, endloopH
	sll $s6, $t4, 2		# s6 = t4*4
	srlv $a0, $t9, $s6	# a0 = t8>>s6
	andi $a0, $a0, 0x0000000f 	# a0 = a0 & 0000 0000 0000 0000 0000 0000 0000 1111 => lay byte cuoi cung cua a0
	la $t7, hex 
	add $t7, $t7, $a0 
	bgt $t4, 1, nextc
	lb $a0, 0($t7) 		# print hex[a0]
	li $v0, 11
	syscall
	# lb $t6, 0($t7)
	# beq $t6, 48, in
nextc:	addi $t4,$t4,-1
	j loopH
# in:	bgt $t4, 1, loopH
	# move $a0, $t6
	# li $v0, 11
	# syscall
endloopH: jr $ra						
			
end:

	li $v0, 4
	la $a0, m2
	syscall	
	
	
