.data
var1: .word 0x00
var2: .word 0x00

.text
    li      $v0, 5          # code for read int | v0 = int
    syscall
    sw      $v0, var1       # var1 = v0
    li      $v0, 5          # code for read int | v0 = int
    syscall
    sw      $v0, var2       # var2 = v0
    lw      $t0, var1       # t0 = var1
    lw      $t1, var2       # t1 = var2
    addu    $t2, $t0, $t1   # t2 = t0 + t1
    move    $a0, $t2        # a0 = t2
    li      $v0, 1          # code for print int | a0 = int to be printed
    syscall
    li      $v0, 11         # syscall code to print_char
    li      $a0, ' '        # a0 = ' '
    syscall
    subu    $t3, $t0, $t1   # t2 = t0 - t1
    move    $a0, $t3        # a0 = t2
    li      $v0, 1          # code for print int | a0 = int to be printed
    syscall

    