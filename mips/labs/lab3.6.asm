.data
a: .word 0x00
b: .word 0x00

.text
    li      $v0, 5          # code for read int | v0 = int
    syscall
    sw      $v0, a          # a = v0
    li      $v0, 5          # code for read int | v0 = int
    syscall
    sw      $v0, b          # b = v0
    lw      $t0, a          # t0 = a
    lw      $t1, b          # t1 = b
    multu   $t0, $t1        # hi,lo = t0 * t1
    mfhi    $s0             # s0 = hi
    mflo    $s1             # s1 = lo
    move    $a0, $s1        # a0 = lo
    li      $v0, 1          # code for print int | a0 = int to be printed
    syscall