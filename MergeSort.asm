.data                                                #data directive : for variable
  arr : .word 3,2,1,4,15,57,23,2,5,10,14,17,0,8,3    #arr to be sorted
  temp : .space 36
  temp1 : .space 36
  gap : .asciiz " "
.
.text                                                 #text directive : for instruction
  addi $sp,$sp,-8                                     #creating activation record for function call i.e sort
  move $t8,$zero
  addi $t9,$zero,14
  sw $t8,($sp)
  sw $t9,4($sp)
  jal sort                                            # call to sort
  la $t0,arr                                          # get base address of arr to be sorted
  add $s0,$zero,$zero
  j print                                             # jump to print function
  
  sort :                                              # Sort function
   addi $sp,$sp,-4
   sw $ra,($sp) 
   lw $t8,4($sp)                                      # t8 <- start index
   lw $t9,8($sp)                                      # t9 <- end index
   bge $t8,$t9,more                                   # check if start>=end
   
   add $t7,$t8,$t9
   div $t7,$t7,2                                      # t7 <- (start+end)/2

   #First sort called
   addi $sp,$sp,-8
   sw $t8,0($sp)
   sw $t7,4($sp)
   jal sort
   addi $sp,$sp,8                                     # removing it's record	
   
   # second sort called
   lw $t8,4($sp)
   lw $t9,8($sp)
   add $t7,$t8,$t9
   div $t7,$t7,2
   addi $t7,$t7,1
   addi $sp,$sp,-8
   sw $t7,0($sp)                                     # storing value in stack
   sw $t9,4($sp)
   jal sort 
   addi $sp,$sp,8  			
   
   #merge called
   lw $t8,4($sp)
   lw $t9,8($sp)
   add $t7,$t8,$t9
   div $t7,$t7,2
   move $a0,$t8                                       #a0,a1,a2 argument for merge
   move $a1,$t7                                       # a0 <- start,a1 <- mid,a2 <-end
   move $a2,$t9
   
   jal merge                                          #call to merge function
    
   lw $ra,($sp)
   addi $sp,$sp,4
   jr $ra
   
   more:                                             # this is called when sort return when start>=end
   lw $ra,0($sp)
   addi $sp,$sp,4
   jr $ra   			   			   			   			
      			   			
  merge :                                            # merge procedure 
   
   move $t6,$a1
   addi $t6,$t6,1
   move $s7,$a0
   move $t5,$a0                   
   sub $a0,$a1,$a0               
   sub $a1,$a2,$a1               
   sub $a1,$a1,1
   move $s0,$zero                 
   move $s1,$zero                
   
   loop:                                            # loop fill start to mid in temp
     bgt $s0,$a0,loop1
     mul $s0,$s0,4                                  #arr[4] = arr +4*4 as each element is of 4 byte
     mul $t5,$t5,4
     la $t0,temp
     la $t2,arr
     add $t0,$t0,$s0
     add $t2,$t2,$t5
     lw $s6,($t2)
     sw $s6,($t0)
     div $s0,$s0,4
     div $t5,$t5,4
     addi $s0,$s0,1
     addi $t5,$t5,1
     j loop  
     
   loop1:                                           # loop1 fill mid+1 to end in temp1
     bgt $s1,$a1,loop2
     mul $s1,$s1,4                                  #arr[4] = arr +4*4 as each element is of 4 byte
     mul $t6,$t6,4
     la $t0,temp1
     la $t2,arr
     add $t0,$t0,$s1
     add $t2,$t2,$t6
     div $s1,$s1,4
     div $t6,$t6,4
     lw $s6,($t2)
     sw $s6,($t0)
     addi $s1,$s1,1
     addi $t6,$t6,1
     j loop1 
     
   loop2:                                           # loop2 prepare variables for loop3
     move $s0,$zero
     move $s1,$zero
     add $s7,$s7,$zero
     j loop3
     
   loop3:                                           #loop3 merge two sorted array temp,temp1 and place in arr
     bgt $s0,$a0,loop4
     bgt $s1,$a1,loop4
     la $t0,arr
     la $t1,temp
     la $t2,temp1
     mul $s0,$s0,4
     mul $s1,$s1,4
     mul $s7,$s7,4
     add $t1,$t1,$s0
     add $t2,$t2,$s1
     add $t0,$t0,$s7
     div $s7,$s7,4
     div $s1,$s1,4
     div $s0,$s0,4
     lw $t4,($t1)
     lw $t5,($t2)
     ble $t4,$t5,if                                 # check if temp[idx] <= temp1[idx1]
     sw $t5,($t0)
     addi $s1,$s1,1
     addi $s7,$s7,1
     j loop3
     
  if :
   sw $t4,($t0)
   addi $s0,$s0,1
   addi $s7,$s7,1
   j loop3  
      		 
  loop4:                                           # loop4 is to fill remaining element of temp1 in array
    bgt $s1,$a1,loop5
    la $t0,temp1
    la $t2,arr
    add $s7,$s7,$zero
    mul $s1,$s1,4
    mul $s7,$s7,4
    add $t0,$t0,$s1
    add $t2,$t2,$s7
    div $s7,$s7,4
    div $s1,$s1,4
    lw $t4,($t0)
    sw $t4,($t2)
    addi $s1,$s1,1
    addi $s7,$s7,1
    j loop4
    
  loop5:                                            # loop5 is to fill remaining element of temp in array
    bgt $s0,$a0,doreturn
    la $t0,temp
    la $t2,arr
    add $s7,$s7,$zero
    mul $s0,$s0,4
    mul $s7,$s7,4
    add $t0,$t0,$s0
    add $t2,$t2,$s7
    div $s7,$s7,4
    div $s0,$s0,4
    lw $t4,($t0)
    sw $t4,($t2)
    addi $s0,$s0,1
    addi $s7,$s7,1
    j loop5
    
  doreturn:                                         #doreturn procedure return to the sort procedure
    jr $ra
  
  print:                                            # print procedure help in printing sorted array
    bgt $s0,14,exit
    li $v0,1
    lw $a0,($t0)
    syscall
    addi $t0,$t0,4
    add $s0,$s0,1
    li $v0,4                                        #sys call for printing string
    la $a0,gap
    syscall                                         #executing system call in reg v0
    j print
    
  exit :                                            # exit procedure help in exiting program safely
  li $v0,10
  syscall
