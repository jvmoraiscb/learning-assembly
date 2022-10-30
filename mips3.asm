###################################
.data

var1:       .word 0x01
var2:       .word 0x02
var3:       .word 0x03
var4:       .word 0x04

primeiro:   .byte 0x42 # hex to 'B'
ultimo:     .byte 0x53 # hex to 'S'

###################################
.text

Main:
la $t0, var1        # t0 = var1 address
la $t1, var2        # t1 = var2 address
la $t2, var3        # t2 = var3 address
la $t3, var4        # t3 = var4 address

lw $t4, var1        # t4 = var1 value
lw $t5, var2        # t5 = var2 value
lw $t6, var3        # t6 = var3 value
lw $t7, var4        # t7 = var4 value

jal Print_vars      # jump to Print_vars and link the address ($ra = address) of this line + 4 (next line)

sw $t4, 0($t3)      # var1 = t3
sw $t5, 0($t2)      # var1 = t2
sw $t6, 0($t1)      # var1 = t1
sw $t7, 0($t0)      # var1 = t0

jal Print_vars      # jump to Print_vars and link the address ($ra = address) of this line + 4 (next line)
j Exit              # jump to Exit

Print_vars:
li $v0, 1           # syscall code to print_int
lw $t8, var1        # t8 = var1 value
addu $a0, $t8, $0   # a0 = t8 + 0 --> a0 = t8 
syscall

li $v0, 1           # syscall code to print_int
lw $t8, var2        # t8 = var2 value
addu $a0, $t8, $0   # a0 = t8 + 0 --> a0 = t8 
syscall

li $v0, 1           # syscall code to print_int
lw $t8, var3        # t8 = var3 value
addu $a0, $t8, $0   # a0 = t8 + 0 --> a0 = t8 
syscall

li $v0, 1           # syscall code to print_int
lw $t8, var4        # t8 = var4 value
addu $a0, $t8, $0   # a0 = t8 + 0 --> a0 = t8 
syscall

li $v0, 11          # syscall code to print_char
li $a0, ' '         # a0 = ' '
syscall

jr $ra              # return to the linked address

Exit:
