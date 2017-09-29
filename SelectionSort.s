# Assembly Program to sort array of positive number using AT&T syntax 
# It will sort negative also but will not print as print algorithm is for positive only.
# For negstive we need to compare it with 0 and multiply -1 and then sent to print algorithm and before it printing "-"
# Author : Ayush Mishra, Roll Number : 1501CS16

# Data directive : initialize data section     
.data
  arr : .quad 1,35,99,24,5,1,13,42,34
  num : .space 8
  msg : .string " "
  nline : .string "\n"

# Text directive : Executable code Section
.text
.globl _start

_start:
  movq $9,%rcx                    #rcx <- 9 contain no. of element in array
  movq $0,%rdx                    #rdx <- 0 contain offset of various element 
  call SORT                       # calling sort function
  call printloop                  # calling printloop function it will print sorted array
  call bye                        # calling byefunction which exit the program
  
  
 SORT :                           #sort for sorting array
    movq arr(,%rdx),%rax          #rax <- arr+rdx
    decq %rcx
    movq %rdx,%rdi
    movq %rdx,%rsi
    cmpq $0,%rcx                  #checking whether we reach end of array 
    je  sort1                     #if equal jump to sort1
    call MIN                      # calling min function for finding minimum
    jmp SORT
 MIN:                             #min for finding minimum from rest of array
        addq $8,%rdi
        cmpq $72,%rdi             #if reach end of array
        jge swap1                  
        cmpq %rax,arr(,%rdi)      #if this element less than current minimum
        jl assign                 # then assign rax to this
        jmp MIN                   
   
  swap1 :
      call SWAP                   # call swap function which exchange the value
      ret                         # return to location where min is called i.e line 30 and move forward
      
  SWAP :                          #swap function move minimum element to current index
    movq arr(,%rdx),%rax 
    movq arr(,%rsi),%rbx
    movq %rax,arr(,%rsi)
    movq %rbx,arr(,%rdx)  
    addq $8,%rdx  
    ret                           #return to location where swap is called i.e line 41 and move forward       
        
   assign:                        #this label assign minimum to rax
     movq %rdi,%rsi
     movq arr(,%rdi),%rax
     movq %rdi,%rbx
     jmp MIN
   
   sort1:                         # this is called when array is sorted
     ret                          # this will return to the location from where sort is called i.e 18 and move forward
    printloop :                   #this label print every element of sorted array
      xorq %rcx,%rcx
      movq $0,num
      gameon :             
        movq $1, %rax             # syscall for write  
        movq $msg, %rsi           # moving buffer to rsi
        movq $1, %rdi             # stdout
        movq $1, %rdx             # length of string
        syscall  
        movq num,%rcx  
        movq arr(,%rcx),%rax      #move element to be printed to rax
        addq $8,%rcx
        movq %rcx,num
        cmpq $80,%rcx
        jge bye1                  #if all element is printed jump to exit
        jmp print
        
    print:                        # print label to print integer using stack 
      xorq %rsi, %rsi             # rsi reg will contain number of digit in integer

        loop2:                    # loop that push each digit in stack from last to front
        movq $0, %rdx
        movq $10, %rbx
        idivq %rbx                # rax <- rax/rbx && rdx <- rax % rbx
        addq  $48, %rdx           # converting digit to char
        pushq %rdx                # push digit in stack
        incq %rsi                 # increment digit count
        cmpq $0, %rax             # compare rax with zero
        jz   next                 # if zero jump to next label
        jmp loop2                 # else jump to loop label again

        next:                     # this label extract each digit from stack and print
        cmpq $0, %rsi             # print until result is not printed
        je   gameon
        decq %rsi
        movq %rsi,%rbx
        movq $1, %rax             # syscall for write  
        movq %rsp, %rsi           # moving buffer to rsi
        movq $1, %rdi             # stdout
        movq $1, %rdx             # length of string
        syscall                   # call to interrupt to print
        movq %rbx,%rsi
        addq $8, %rsp             # rsp <- rsp + 8
        jmp  next
   
   bye1:
     ret
   
   bye:                           # label for exit
        movq $1, %rax             # syscall for write  
        movq $nline, %rsi         # moving buffer to rsi
        movq $1, %rdi             # stdout
        movq $1, %rdx             # length of string
        syscall  
    movq $60,%rax                 # syscall for exit
    movq $0, %rbx                     
    syscall                       # calling interrupt to exit
     
    
