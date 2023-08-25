.data
num:    .word 10       
res:    .word 0
vout:   .space 400

.text
    la      $s1, vout       # s1 = primeira posição do "vetor"
    lw      $a0, num        # a0 = numero de iterações
    li      $t0, 1          # t0 = iterador (0)
    li      $t1, 0          # t1 = valor anterior da sequencia (valor inicial == 0)
    li      $t2, 1          # t2 = valor atual da sequencia (valor inicial == 1)
loop:
    ble     $a0, $t0, end   # jump para end se a0 <= t0
    sw      $t2, 0($s1)     # armazena o valor atual da sequencia no "vetor"
    addi    $s1, $s1, 4     # s1 = o endereço da próxima posição do "vetor"
    addi    $t0, $t0, 1     # t0 = t0 + 1
    move    $t3, $t2        # t3 = t2
    add     $t2, $t2, $t1   # t2 = t2 + t1  (próximo valor)
    move    $t1, $t3        # t1 = t3       (valor atual)
    b       loop
end:
    sw      $t2, 0($s1)     # armazena o último valor da sequência no "vetor" vout
    sw      $t2, res        # armazena o último valor da sequência na variável res