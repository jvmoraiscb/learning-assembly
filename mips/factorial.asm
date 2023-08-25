.data
msg1: .asciiz "Enter a number: "
msg2: .asciiz "The number entered is not valid! "
msg3: .asciiz "! = "

.text
Main:
whileMain:                      # scan a new number while last number is less than 0
    li      $v0, 4              # code for print string
    la      $a0, msg1           # string address
    syscall
    li      $v0, 5              # code for read int | v0 = int
    syscall
    move    $s0, $v0
    slt     $t0, $s0, $0        # (s0 < 0) ? t0 = 1 ? t0 = 0
    beq     $t0, $0, exitMain   # jump to exitMain if (t0 == 0)
    li      $v0, 4              # code for print string
    la      $a0, msg2           # string address
    syscall
    j       whileMain
exitMain:
    mtc1    $s0, $f0            # f0 = s0
    cvt.s.w $f1, $f0            # f1 = (float) f0
    mov.s   $f12, $f1           # f12 = f1 (arg)
    jal     FactorialSingle
    mov.s   $f2, $f0            # f2 = f0 (return)
    move    $a0, $s0            # a0 = s0
    li      $v0, 1              # code for print int | a0 = int to be printed
    syscall
    la      $a0, msg3           # string address
    li      $v0, 4              # code to print string | a0 = address of string to be printed
    syscall
    mov.s   $f12, $f2           # f12 = f2
    li      $v0, 2              # code for print float | f12 = float to be printed
    syscall
    j       Exit

FactorialSingle:                # f12 = x (float number), return f0 = x! (float number factorial)
    li      $t0, 0              # t0 = 0
    mtc1    $t0, $f13           # f13 = (int) t0
    cvt.s.w $f13, $f13          # f13 = (float) f13 --> f13 = 0
    li      $t0, 1              # t0 = 1
    mtc1    $t0, $f14           # f14 = (int) t0
    cvt.s.w $f14, $f14          # f14 = (float) f14 --> f14 = 1
    mov.s   $f0, $f14           # f0 = f14
forFS:
    c.eq.s  $f12, $f13          # if (f12 == f13) flag1 = true
    bc1t    exitFS              # if (flag1 == true)
    mul.s   $f0, $f0, $f12      # f0 = f0 * f12
    sub.s   $f12, $f12, $f14    # f12--
    j forFS
exitFS:
    jr      $ra
Exit: