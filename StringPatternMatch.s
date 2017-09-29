# Assembly Program to find total number of pattern match number using AT&T syntax 
# Author : Ayush Mishra, Roll Number : 1501CS16

# Data directive : initialize data section     
.data 
  test_string : .string "abcdabbabbabbbbb"
  pattern     : .string "bab"
  newline     : .string "\n"
  temp        : .space 8
  
# Text directive : Executable code Section  
.text
  .globl _start
  
  _start :
     movq $15,%rcx                        #rcx <- holds lenght of test_string-pattern_string+1
     movq test_string,%rax                #move first char of test_string in rax
     movq $-1,%rsi                        # rsi holds offset of test_string       
     movq %rsi,temp                  
     xorq %rdi,%rdi                       # rdi holds result    
     movq pattern,%rbx                    # move first char of pattern in rbx 
     loop :
       movq temp,%rsi
       addq $1,%rsi
       movq %rsi,temp
       movq $0,%rdx                       # rdx <- holds offset of pattern string
       cmpq $0,%rcx                       # if required test_string traversed jump to print count
       je print1
       movq pattern(,%rdx),%rbx
       movq test_string(,%rsi),%rax     
       cmp %al,%bl                        # comparing char of both pattern and test_string at current offset
       je loop1                           # if equal jump to loop1 to compare rest of paattern
       decq %rcx
       jmp loop
       
       loop1:                             # loop that matches rest of the string
       addq $1,%rdx
       addq $1,%rsi
       cmpq $2,%rdx
       je found                           # jump to found
       movq pattern(,%rdx),%rbx
       movq test_string(,%rsi),%rax
       cmp %al,%bl
       je loop1 
       decq %rcx
       jmp loop
     
     found:                               # if pattern found increment rdi
       addq $1,%rdi                       # rdi holds the result
       decq %rcx
       jmp loop
       
     print1 :
       movq %rdi,%rax
       jmp print
     
     print:                               # print label to print integer using stack 
      xorq %rsi, %rsi                     # rsi reg will contain number of digit in integer

        loop2:                            # loop that push each digit in stack from last to front
        movq $0, %rdx
        movq $10, %rbx
        idivq %rbx                        # rax <- rax/rbx && rdx <- rax % rbx
        addq  $48, %rdx                   # converting digit to char
        pushq %rdx                        # push digit in stack
        incq %rsi                         # increment digit count
        cmpq $0, %rax                     # compare rax with zero
        jz   next                         # if zero jump to next label
        jmp loop2                         # else jump to loop label again

        next:                             # this label extract each digit from stack and print
        cmpq $0, %rsi                     # print until result is not printed
        je   exit
        decq %rsi
        movq %rsi,%rbx
        movq $1, %rax                     # syscall for write  
        movq %rsp, %rsi                   # moving buffer to rsi
        movq $1, %rdi                     # stdout
        movq $1, %rdx                     # length of string
        syscall                           # call to interrupt to print
        movq %rbx,%rsi
        addq $8, %rsp                     # rsp <- rsp + 8
        jmp  next
        
     exit:
      movq $1,%rax
      movq $newline, %rsi
      movq $1, %rdi
      movq $1, %rdx
      syscall
      movq $60,%rax                       # syscall for exit
      movq $0, %rbx                     
      syscall
