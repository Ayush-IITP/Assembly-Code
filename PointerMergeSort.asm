.data                                                  #data directive : for variable
  arr : .word  3,2,1,4,15,57,23,2,5,10,14,17,0,8,3     #arr to be sorted
  temp : .space 36
  temp1 : .space 36
  gap : .asciiz " "
  l : .word 0                                          # These will contain local variable 
  r : .word 9                                          # in previous code we used register to hold value
  m : .word 4                                          # reg will act as a pointer to these variable
  i : .word 0                                          # to use it we need to dereference the regsss
  j : .word 0
  k : .word 0
  
 .text                                                 #text directive : for instruction
  addi $sp,$sp,-8                                      #creating activation record for function call i.e sort
  move $t8,$zero
  sw $t8,l                                             # *l = $t8  , l is start of array for each call
  
  addi $t9,$zero,14
  sw $t9,r                                             # *r = $t9 , l is end of array for each call
  
  sw $t8,($sp)
  sw $t9,4($sp)
  
  jal sort                                             # call to sort 
  
  la $t0,arr                                           # $t0 = &arr, to is a pointer to our array arr
  add $s0,$zero,$zero
  
  j print                                              # jump to print function to print sorted result
  
 sort :                                                # recursive sort procedure 
   addi $sp,$sp,-4
   
   sw $ra,($sp)                                        # storing return address on top of stack
   lw $t8,4($sp)
   sw $t8,l                                            # *l = $t8
   
   lw $t9,8($sp)
   sw $t9,r                                            # *r = $t9
   
   lw $t8,l                                            # $t8 = *l
   lw $t9,r                                            # $t9 = *r
   
   bge $t8,$t9,more                                    # check if start>=end
   
   add $t7,$t8,$t9
   div $t7,$t7,2
   sw $t7,m
   
   #First sort called
   addi $sp,$sp,-8
   lw $t8,l
   sw $t8,0($sp)
   lw $t7,m
   sw $t7,4($sp)
   jal sort                                            #call to first sort
   addi $sp,$sp,8
   	
   # second sort called
   lw $t8,4($sp)
   sw $t8,l
   
   lw $t9,8($sp)                                       #accesing required value from stack
   sw $t9,r
   
   add $t7,$t8,$t9
   div $t7,$t7,2
   addi $t7,$t7,1
   sw $t7,m                                            # *m = $t7,m holds the mid of start and end
   
   addi $sp,$sp,-8
   
   lw $t7,m
   sw $t7,0($sp)
   
   lw $t9,r
   sw $t9,4($sp)
   jal sort                                            #call to first sort
   addi $sp,$sp,8
   
     			  			
   #merge called
   
   lw $t8,4($sp)
   sw $t8,l
   
   lw $t9,8($sp)
   sw $t9,r                                           # *r = $t9
   add $t7,$t8,$t9
   div $t7,$t7,2
   sw $t7,m                                           # *m = $t7
   
   move $a0,$t8           
   move $a1,$t7
   move $a2,$t9
   
   jal merge                                          # call to merge procedure
   lw $ra,($sp)
   addi $sp,$sp,4
   jr $ra
   
 more:                                                # this is called when sort return i.e when start>=end
   lw $ra,0($sp)
   addi $sp,$sp,4
   jr $ra  
   
 merge :                                              # merge procedure 
   
   lw $a0,l
   lw $a1,m
   lw $a2,r
   lw $t6,m
   addi $t6,$t6,1
   sw $t6,m
   lw $s7,l
   sw $s7,k
   lw $t5,l                   
   sub $a0,$a1,$a0                
   sub $a1,$a2,$a1              
   sub $a1,$a1,1
   move $s0,$zero                 
   sw $s0,i
   
   move $s1,$zero              
   sw $s1,j
   
    
   loop:                                              # loop fill start to mid in temp
     la $t0,temp
     la $t2,arr                                       # t2 = &arr ,suppose ptr = $t2
     lw $t5,l 
     mul $t5,$t5,4
     add $t2,$t2,$t5
     lw $s0,i
     exec:
       bgt $s0,$a0,loop1
       lw $s6,($t2)
       sw $s6,($t0)
       addi $t0,$t0,4                                 # ptr++ ,for accesing temp        
       addi $t2,$t2,4                                 # ptr1++, for accesing arr
       addi $s0,$s0,1
       j exec  
   
   loop1:                                             # loop1 fill mid+1 to end in temp1
     la $t0,temp1
     la $t2,arr                                       # t2 = &arr ,suppose ptr = $t2
     lw $t6,m
     mul $t6,$t6,4
     add $t2,$t2,$t6
     lw $s1,j
     exec1:
       bgt $s1,$a1,loop2
       lw $s6,($t2)
       sw $s6,($t0)
       addi $t0,$t0,4                                # ptr++ ,for accesing temp1      
       addi $t2,$t2,4                                # ptr++ ,for accesing arr     
       addi $s1,$s1,1
       j exec1      
   
     
   loop2:                                            # loop2 prepare variables for loop3
     move $s0,$zero
     sw $s0,i
     
     move $s1,$zero
     sw $s1,j
     
     lw $s7,k
     add $s7,$s7,$zero
     j loop3
     
   loop3:                                            #loop3 merge two sorted array temp,temp1 and place in arr
     la $t0,arr
     move $t5,$s7
     mul $t5,$t5,4
     add $t0,$t0,$t5
     la $t1,temp
     la $t2,temp1
     exec3:
       bgt $s0,$a0,loop4
       bgt $s1,$a1,loop4
       lw $t4,($t1)
       lw $t5,($t2)
       ble $t4,$t5,if                                # check if temp[ptr] <= temp1[ptr1]
       sw $t5,($t0)
       addi $s1,$s1,1  
       add $t2,$t2,4                                 #temp1 -> ptr++
       add $t0,$t0,4                                 #arr -> ptr1++
       addi $s7,$s7,1
       j exec3
     
  if :
   sw $t4,($t0)
   addi $s0,$s0,1
   addi $t1,$t1,4
   addi $t0,$t0,4
   addi $s7,$s7,1
   j exec3  
      		 
  loop4:                                             # loop4 is to fill remaining element of temp1 in array
    la $t0,temp1
    move $t1,$s1
    mul $t1,$t1,4
    add $t0,$t0,$t1
    la $t2,arr
    move $t5,$s7
    mul $t5,$t5,4
    add $t2,$t2,$t5
    exec4:
      bgt $s1,$a1,loop5
      lw $t4,($t0)
      sw $t4,($t2)
      addi $s1,$s1,1
      addi $s7,$s7,1 
      addi $t2,$t2,4                                #temp1 -> ptr++
      addi $t0,$t0,4                                #arr -> ptr1++
      j exec4
      
  loop5:                                            # loop5 is to fill remaining element of temp in array
    la $t0,temp
    move $t1,$s0
    mul $t1,$t1,4
    add $t0,$t0,$t1
    la $t2,arr
    move $t5,$s7
    mul $t5,$t5,4
    add $t2,$t2,$t5
    exec5:
       bgt $s0,$a0,doreturn
       lw $t4,($t0)
       sw $t4,($t2)
       addi $s0,$s0,1
       addi $s7,$s7,1
       addi $t2,$t2,4
       addi $t0,$t0,4
       j exec5
       
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
    
  exit :                                          # exit procedure help in exiting program safely
  li $v0,10
  syscall
