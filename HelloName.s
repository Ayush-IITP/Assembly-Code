# Assembly Program to display "Hello Your Name" using AT&T syntax 
# Author : Ayush Mishra, Roll Number : 1501CS16


# Text directive : Executable code Section
.text
.globl _start

_start :           #starting point of Program
  
    # print
    movl $4, %eax        # System_call for write i.e SYS_write = 4
    movl $1, %ebx        # call to std_out=1
    movl $name, %ecx     # Loading name variable define in data section as buffer
    movl $20, %edx       # specifying length of string variable
    int $0x80            # call to interrupt for printing the name variable
    
    #exit
    movl $1, %eax        # system call for exit i.e sys_exit = 1
    movl $0, %ebx        # Argument for exit i.e return value
    int $0x80            # call to interrupt
    
# Data directive : initialize data section     
.data

  name : .string "Hello Ayush Mishra!\n"       # defining string variable with label name
