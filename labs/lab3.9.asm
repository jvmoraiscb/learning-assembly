.data
#   0       00000000    00000000000000000000000
#   signal  expoent     fraction
#
Zero:       .float 00000000000000000000000000000000
PlusInf:    .float 01111111100000000000000000000000
MinusInf:   .float 11111111100000000000000000000000
PlusNaN:    .float 01111111100000000000000000000001
MinusNan:   .float 11111111111111111111111111111111

.text
    lwc1    $f12, Zero
    li      $v0, 2          # code for print float | f12 = float to be printed
    syscall
    li      $v0, 11         # syscall code to print_char
    li      $a0, ' '        # a0 = ' '
    syscall
    lwc1    $f12, PlusInf
    li      $v0, 2          # code for print float | f12 = float to be printed
    syscall
    li      $v0, 11         # syscall code to print_char
    li      $a0, ' '        # a0 = ' '
    syscall
    lwc1    $f12, MinusInf
    li      $v0, 2          # code for print float | f12 = float to be printed
    syscall
    li      $v0, 11         # syscall code to print_char
    li      $a0, ' '        # a0 = ' '
    syscall
    lwc1    $f12, PlusNaN
    li      $v0, 2          # code for print float | f12 = float to be printed
    syscall
    li      $v0, 11         # syscall code to print_char
    li      $a0, ' '        # a0 = ' '
    syscall
    lwc1    $f12, MinusNan
    li      $v0, 2          # code for print float | f12 = float to be printed
    syscall
