## THIS IS AN EXAMPLE FILE FOR batt_update_asm.s
## You may choose to use all or none of the starter / example code below
## Make sure to implement the below functions in your batt_update_asm.s file:
## set_batt_from_ports set_display_from_batt batt_update

.text
.global  set_batt_from_ports
        
# ENTRY POINT FOR REQUIRED FUNCTION
set_batt_from_ports:
    ## assembly instructions here

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

seven_segment_bitmask:
    .int 0b0111111
    .int 0b0000110
    .int 0b1011011
    .int 0b1001111
    .int 0b1100110
    .int 0b1101101
    .int 0b1111101
    .int 0b0000111
    .int 0b1111111
    .int 0b1101111


# WARNING: Don't forget to switch back to .text as below
# Otherwise you may get weird permission errors when executing 
.text
.global  set_display_from_batt

# ENTRY POINT FOR REQUIRED FUNCTION
set_display_from_batt:
    movq %rdi, %rax                            # %rax = batt
    shr $24, %rax                              # %al = batt.mode
    cmp $1, %al                                # if (batt.mode == 1)
    je percent                                 #     goto percent
    cmp $2, %al                                # else if (batt.mode == 2)
    je voltage                                 #     goto voltage
    movq $1, %rax                              # else return 1
    ret

# data = %ax
# data_temp = %cx
# result = %r8d
# temp = %r11w
# index = %rdx
# seven_segment_bitmask = %r10
# digit = %r9d
percent:
    movl $1, %r8d                              # result = 0b1
    movq %rdi, %rax                            # %rax = batt
    shr $16, %rax                              # %al = batt.percent
    movsbw %al, %ax                            # data = batt.percent
    leaq seven_segment_bitmask(%rip), %r10     # %r10 = seven_segement_bitmask
    
    # Right
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= temp; index = data % temp
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $3, %r9d                              # digit = digit << 3
    addl %r9d, %r8d                            # result += digit
    
    # Middle
    movw %ax, %cx                              # data_temp = data
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= temp; index = data % temp
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $10, %r9d                             # digit = digit << 10
    movl $0, %r11d                             # temp = 0
    cmp $0, %cx                                # if data_temp == 0
    cmove %r11d, %r9d                          #     digit = 0
    addl %r9d, %r8d                            # result += digit

    # Left
    movw %ax, %cx                              # data_temp = data
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= temp; index = data % temp
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $17, %r9d                             # digit = digit << 17
    movl $0, %r11d                             # temp = 0
    cmp $0, %cx                                # if data_temp == 0
    cmove %r11d, %r9d                          #     digit = 0
    addl %r9d, %r8d                            # result += digit

    jmp both                                   # goto both

# data = %ax
# result = %r8d
# temp = %r11w
# index = %edx
# seven_segment_bitmask = %r10
# digit = %r9d
# lastDigit = %rdx
# round = %r9w
voltage:
    movl $6, %r8d                              # result = 0b110
    movw %di, %ax                              # data = batt.mlvolts
    leaq seven_segment_bitmask(%rip), %r10     # %r10 = seven_segement_bitmask

    # Rounding
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= 10; lastDigit = data % 10
    movw $0, %r9w                              # round = 0
    movw $1, %r11w                             # temp = 1
    cmp $5, %rdx                               # if lastDigit >= 5
    cmovge %r11w, %r9w                         #      round = 1
    addw %r9w, %ax                             # data += round
    
    # Right
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= 10; index = data % 10
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $3, %r9d                              # digit == digit << 3
    addl %r9d, %r8d                            # result += digit
    
    # Middle
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= 10; index = data % 10
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $10, %r9d                             # digit == digit << 10
    addl %r9d, %r8d                            # result += digit

    # Left
    movw $10, %r11w                            # temp = 10
    cqto
    idivw %r11w                                # data /= 10; index = data % 10
    movl (%r10, %rdx, 4), %r9d                 # digit = seven_segement_bitmask[index]
    shll $17, %r9d                             # digit == digit << 17
    addl %r9d, %r8d                            # result += digit

    jmp both                                   # goto both

# batteryLevel = %r9d
# result = %r8d
# percent = %al
# temp = %r11d
both:
    movq %rdi, %rax                            # %rax = batt
    shrq $16, %rax                             # percent = batt.percent
    movl $0, %r9d                              # batteryLevel = 0
    movl $0x1000000, %r11d                     # temp = 0x1000000
    cmp $5, %al                                # if percent >= 5
    cmovge %r11d, %r9d                         #     batteryLevel = 0x1000000
    addl %r9d, %r8d                            # result += batteryLevel

    subb $10, %al                              # percent -= 10
    movsbq %al, %rax
    cqto
    movb $20, %r11b                            # temp = 20
    idivb %r11b                                # percent /= 20
    movb %al, %cl                              # %cl = %al
    movl $1, %r9d                              # batteryLevel = 1
    shll %cl, %r9d                             # batteryLevel = batteryLevel << percent
    subl $1, %r9d                              # batteryLevel -= 1
    shll $25, %r9d                             # batteryLevel = batteryLevel << 25
    addl %r9d, %r8d                            # result += batteryLevel

    movl %r8d, (%rsi)                          # *display = result
    movq $0, %rax                              # return 0
    ret


.text
.global batt_update
   
# ENTRY POINT FOR REQUIRED FUNCTION
batt_update:
	## assembly instructions here
