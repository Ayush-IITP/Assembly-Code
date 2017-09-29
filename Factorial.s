# Assembly Program to calculate Factorial of a number using AT&T syntax 
# Author : Ayush Mishra, Roll Number : 1501CS16

# Data directive : initialize data section     
.data
 num : .space 8
 num1 : .space 8
 msg : .string "Number is too large\n"
 val : .string "1\n"
 prompt : .string "Enter the number :\n"
 
 
 # Text directive : Executable code Section
.text 

.globl _start

_start :                              # starting point of Program
    jmp input                         # jump to input label to get user input
    
_main:                                # main label
     
    movb %cl,num1                     # moving value from cl i.e input reg to num1
    xorq %rcx,%rcx
    xorq %rax,%rax                    # xor to make value in reg rax and rcx 0
    movq num1,%rcx                    # moving num1 to rcx (work as counter) 
    movq num1,%rax                    # moving num1 to rax (store result)
    cmp $0,%rcx                       
    je print1                         #if input is 0 jump to print1 label
    
    
 Repeat:                              # Repeat label that finds factorial and store in rax
    decq %rcx
    cmpq $0,%rcx                       
    je print
    imulq %rcx,%rax                   # rax <- rax*rcx
    cmpq $1,%rcx                      # rcx reg work as counter that decrease from num1 to 0
    jne Repeat

 print:                               # print label to print integer using stack 
      xorq %rsi, %rsi                 # rsi reg will contain number of digit in integer

        loop:                         # loop that push each digit in stack from last to front
        movq $0, %rdx
        movq $10, %rbx
        idivq %rbx                    # rax <- rax/rbx && rdx <- rax % rbx
        addq  $48, %rdx               # converting digit to char
        pushq %rdx                    # push digit in stack
        incq %rsi                     # increment digit count
        cmpq $0, %rax                 # compare rax with zero
        je   next                     # if zero jump to next label
        jmp loop                      # else jump to loop label again

        next:                         # this label extract each digit from stack and print
        cmpq $0, %rsi                 # print until result is not printed
        je   bye
        decq %rsi
        movq %rsi,%rbx
        movq $1, %rax                 # syscall for write  
        movq %rsp, %rsi               # moving buffer to rsi
        movq $1, %rdi                 # stdout
        movq $1, %rdx                 # length of string
        syscall                       # call to interrupt to print
        movq %rbx,%rsi
        addq $8, %rsp                 # rsp <- rsp + 8
        jmp  next
        
 bye:                                 # label for exit
    movq $60,%rax                     # syscall for exit
    movq $0, %rbx                     
    syscall                           # calling interrupt to exit
    
 input :                              # label to take input from user
    movq $1, %rax
    movq $prompt, %rsi
    movq $1, %rdi
    movq $21, %rdx
    syscall                           # for printing prompt
    movl $3,%eax                      # syscall for read
    movl $0,%ebx                      # value for std in
    movl $num,%ecx                    # value inputted get stored in num
    movl $8,%edx                      # 8 byte space
    int $0x80                         # calling interrupt to read
    movb num, %cl
    
    sub $48,%cl                       # convering char to int
    movb %cl,%bl
    cmpb $9,%bl                        # for checking input is greater than 8 or not
    jge bye1
    jmp _main
    
  bye1:                               # label to print number too large
        movq $1, %rax
        movq $msg, %rsi
        movq $1, %rdi
        movq $20, %rdx
        syscall                       # calling interrupt to print number too large
        jmp bye
  print1:                             # label to print factorial of 0
        movq $1, %rax
        movq $val, %rsi
        movq $1, %rdi
        movq $1, %rdx
        syscall
        jmp bye
