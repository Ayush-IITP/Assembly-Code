# Assembly Program to calculate max of array of number using AT&T syntax 
# Author : Ayush Mishra, Roll Number : 1501CS16

# Data directive : initialize data section     
.data
  s : .quad -3,2,7,5,12,3,6
  msg : .string "\n"


# Text directive : Executable code Section
.text
.globl _start
 
_start:                                        # starting point of Program
        xorq %rax,%rax                         # initialize rax <- 0 ,it will contain max
        movq s,%rax                            # move value of s[0] to rax
        movq $6,%rcx                           # move remaining length of array to traverse
        movq $8,%rdx                           # rdx contain size of quad i.e 8 byte
        

 findmax :                                     # this label find maximum in array
        cmpq s(,%rdx),%rax                     # accesing s[i]
        jl assign                              # if s[i] > rax(current max) change current max
        addq $8,%rdx                           # add 8 byte in rdx as it will be next valid address
        decq %rcx                              # rcx work as counter for array decrement rcx
        cmpq $0,%rcx                           # if array is traversed
        je print                               # jump to print max
        jmp findmax                            # else again findmax
        
 assign :                                      # this label update current max
        movq s(,%rdx),%rax
        addq $8,%rdx
        decq %rcx
        cmpq $0,%rcx
        je print
        jmp findmax
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
        jz   next                     # if zero jump to next label
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
 bye :                                # this label is to exit from program
        movq $1, %rax                 # syscall for write  
        movq $msg, %rsi               # moving buffer to rsi
        movq $1, %rdi                 # stdout
        movq $1, %rdx                 # length of string
        syscall                       # call to interrupt to print
        movq $60,%rax                 # syscall for exit
        movq $0,%rdi
        syscall                       # calling interrupt to exit
