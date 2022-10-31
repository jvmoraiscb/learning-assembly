#
#   sort-array code in C by John L. Hennessey  
#
#   void Sort (int v[], int n)
#   {
#       int i, j;
#       for (i = 0; i< n; i += 1)
#       {
#           for(j = i - 1; j >= 0 && v[j] > v[j + 1]; j -= 1)
#           {
#               Swap(v, j);
#           }
#       }
#   }
#
#   void Swap(int v[], int k)
#   {
#       int temp;
#       temp = v[k];
#       v[k] = v[k+1];
#       v[k+1] = temp;
#   }

.data
msg1: .asciiz "Enter the vector's size: "
msg2: .asciiz "Enter the "
msg3: .asciiz "º vector's element: "
msg4: .asciiz "\nVector: "
msg5: .asciiz "\nSorted vector: "

.text

Main:
    li      $v0, 4              # code for print string
    la      $a0, msg1           # string address
    syscall
    li      $v0, 5              # code for read int | v0 = int
    syscall
    move    $s1, $v0            # s1 = v0 (int)
    move    $a0, $s1            # a0 = number of bytes to be alloc
    li      $v0, 9              # code for alloc a0 bytes | v0 = address
    syscall
    move    $s0, $v0            # s0 = array address
    move    $s2, $0             # s2 = 0
forMain:
    beq     $s2, $s1, exitMain  # jump to exitMain if s2 == s1
    li      $v0, 4              # code for print string
    la      $a0, msg2            # string address
    syscall
    addi    $a0, $s2, 1         # t0 = s2+1     
    li      $v0, 1              # code for print int
    syscall
    li      $v0, 4              # code for print string
    la      $a0, msg3           # string address
    syscall
    li      $v0, 5              # code for read int | v0 = int
    syscall
    sll     $t0, $s2, 2         # s2 = v0 * 4
    addu    $t1, $s0, $t0       # t1 = s0[t0]
    sw      $v0, ($t1)
    addi    $s2, $s2, 1         # s2++
    j       forMain
exitMain:
    li      $v0, 4              # code for print string
    la      $a0, msg4           # string address
    syscall
    move    $a0, $s0            # a0 for PrintArray function
    move    $a1, $s1            # a1 for PrintArray function
    jal     PrintArray
    move    $a0, $s0            # a0 for SortArray function
    move    $a1, $s1            # a1 for SortArray function
    jal     SortArray
    li      $v0, 4              # code for print string
    la      $a0, msg5           # string address
    syscall
    move    $a0, $s0            # a0 for PrintArray function
    move    $a1, $s1            # a1 for PrintArray function
    jal     PrintArray
    j       Exit

PrintArray:                     # a0 = v (array address), a1 = n (array size)
    addi    $sp, $sp, -12       # create space for 1 register
    sw      $s2, 8($sp)         # save s2 in stack
    sw      $s1, 4($sp)         # save s1 in stack
    sw      $s0, 0($sp)         # save s0 in stack
    move    $s0, $a0            # s0 = v
    move    $s1, $a1            # s1 = n
    move    $s2, $0             # s2 = 0 
forPrint:
    beq     $s2, $s1 exitPrint  # jump to exitPrint if s0 = s1
    sll     $t0, $s2, 2         # t0 = s2 * 4
    addu    $t1, $s0, $t0       # t1 = s0[t0]
    lw      $a0, ($t1)          # a0 = s0[t0] value
    li      $v0, 1              # code for print int | a0 = int
    syscall
    li      $v0, 11             # syscall code to print_char
    li      $a0, ' '            # a0 = ' '
    syscall
    addi    $s2, $s2, 1         # s2++
    j       forPrint
exitPrint:
    lw      $s0, 0($sp)         # restore s0 from stack
    lw      $s1, 4($sp)         # restore s0 from stack
    lw      $s2, 8($sp)         # restore s0 from stack
    addi    $sp, $sp, 12        # restore stack
    jr      $ra                 # return

SortArray:                      # a0 = v (array address), a1 = n (array size)
    addi    $sp, $sp, -20       # create space for 5 registers
    sw      $ra, 16($sp)        # save ra in stack
    sw      $s3, 12($sp)        # save s3 in stack
    sw      $s2, 8($sp)         # save s2 in stack
    sw      $s1, 4($sp)         # save s1 in stack
    sw      $s0, 0($sp)         # save s0 in stack
    move    $s2, $a0            # s2 = v
    move    $s3, $a1            # s3 = n
    move    $s0, $0             # s0 = 0 
for1Sort:
    slt     $t0, $s0, $s3       # t0 = 0 if s0 >= n
    beq     $t0, $0, exit1Sort  # jump to exit1 if s0 >= n
    addi    $s1, $s0, -1        # j = i - 1
for2Sort:
    slti    $t0, $s1, 0         # t0 = 1 if s1 < 0
    bne     $t0, $0, exit2Sort  # jump to exit2 if s0 < 0
    sll     $t1, $s1, 2         # t1 = j*4
    add     $t2, $s2, $t1       # t2 = v + j*4 
    lw      $t3, 0($t2)         # t3 = v[j]
    lw      $t4, 4($t2)         # t4 = v[j + 1]
    slt     $t0, $t4, $t3       # t0 = 0 if t4 >= t3
    beq     $t0, $0, exit2Sort  # jump to exit 2 if t4 >= t3
    move    $a0, $s2            # a0 = v
    move    $a1, $s1            # a1 = j
    jal     Swap                
    addi    $s1, $s1, -1        # j -= 1
    j       for2Sort
exit2Sort:
    addi    $s0, $s0, 1         # i += 1
    j       for1Sort
exit1Sort:
    lw      $ra, 16($sp)        # restore ra from stack
    lw      $s3, 12($sp)        # restore s3 from stack
    lw      $s2, 8($sp)         # restore s2 from stack
    lw      $s1, 4($sp)         # restore s1 from stack
    lw      $s0, 0($sp)         # restore s0 from stack
    addi    $sp, $sp, 20        # restore stack
    jr      $ra                 # return to caller

Swap:                           # a0 = v (array address), a1 = k (position in array)
    sll     $t1, $a1,2          # t1 = k * 4    (positions are multiples of four)
    add     $t1, $a0,$t1        # t1 = v + k*4  (t1 = v[k])
    lw      $t0, 0($t1)         # t0 = v[k]
    lw      $t2, 4($t1)         # t2 = v[k+1]
    sw      $t2, 0($t1)         # v[k] = t2      
    sw      $t0, 4($t1)         # v[k+1] = t0
    jr      $ra                 # return

Exit:
