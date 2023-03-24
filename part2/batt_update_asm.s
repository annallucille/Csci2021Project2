## THIS IS AN EXAMPLE FILE FOR batt_update_asm.s
## You may choose to use all or none of the starter / example code below
## Make sure to implement the below functions in your batt_update_asm.s file:
## set_batt_from_ports set_display_from_batt batt_update

.text
.global  set_batt_from_ports
        
# ENTRY POINT FOR REQUIRED FUNCTION
set_batt_from_ports:
    movw  BATT_VOLTAGE_PORT(%rip), %dx  
    cmpw  $0, %dx
    jl	L7

L1:
    sarw  $1, %dx
    movw  %dx, 0(%rdi)        ## 0(%rdi) == batt->mvolts
    subw  $3000, %dx
    cmpw  $0, %dx
    jl L4

L2:
    sarw  $3, %dx
    cmpw $100, %dx
    jg L5

L3:
    movw %dx, 2(%rdi)
    jmp L6

L4:
    movb  $0, 2(%rdi)
    jmp L6

L5:
    movb  $100, 2(%rdi)
    
L6:
    movb BATT_STATUS_PORT(%rip), %dl  ##stores BATT_STATUS in %edx
    shlb  $3, %dl
    shrb  $7, %dl
    subb  $2, %dl
    negb  %dl
    movb  %dl, 3(%rdi)
    movl $0, %eax
    ret
  
L7:
    movl $1, %eax
    ret


    ## a useful technique for this problem
    ## movX    SOME_GLOBAL_VAR(%rip), %reg
    # load global variable into register
    # Check the C type of the variable
    #    char / short / int / long
    # and use one of
    #    movb / movw / movl / movq 
    # and appropriately sized destination register                                            


### Change to definint semi-global variables used with the next function 
### via the '.data' directive
.data
	
my_int:                     # declare location an single integer named 'my_int'
    .int 1234               # value 1234

other_int:                  # declare another int accessible via name 'other_int'
    .int 0b0101             # binary value as per C

my_array:                   # declare multiple ints sequentially starting at location
    .int 10                 # 'my_array' for an array. Each are spaced 4 bytes from the
    .int 0x00014            # next and can be given values using the same prefixes as 
    .int 0b11110            # are understood by gcc.


# WARNING: Don't forget to switch back to .text as below
# Otherwise you may get weird permission errors when executing 
.text
.global  set_display_from_batt

# ENTRY POINT FOR REQUIRED FUNCTION
set_display_from_batt:  
    ## assembly instructions here

	## two useful techniques for this problem
    movl    my_int(%rip),%eax    # load my_int into register eax
    leaq    my_array(%rip),%rdx  # load pointer to beginning of my_array into rdx


.text
.global batt_update
   
# ENTRY POINT FOR REQUIRED FUNCTION
batt_update:
	## assembly instructions here