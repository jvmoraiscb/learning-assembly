segment code
..start:
	; iniciar os registros de segmento DS e SS e o ponteiro de pilha SP
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,stacktop
	
	; AQUI COMECA A EXECUCAO DO PROGRAMA PRINCIPAL
    mov dx,mensini  ; mensagem de inicio
    mov ah,9
    int 0x21
    mov ax,0        ; primeiro elemento da série
    mov bx,1        ; segundo elemento da série
L10:
    mov dx,ax
    add dx,bx       ; calcula novo elemento da série
    mov ax,bx
    mov bx,dx
    cmp dx, 0x8000
    jb L10
exit:
    call imprimenumero
	mov dx,mensfim  ; mensagem de inicio
    mov ah,9
    int 0x21
quit:
    mov ah,0x4c    	; retorna para o DOS com código 0
    int 0x21
imprimenumero:
	; Aqui, você deve salvar o contexto
	mov di,saida
	call bin2ascii
	mov dx,saida
	mov ah,9
	int 21h
	; Aqui, você deve recuperar o contexto
	ret
	; AQUI TERMINA A EXECUCAO DO PROGRAMA PRINCIPAL
bin2ascii:
	mov byte [saida],0x31
	ret

segment data  	 	;segmento de dados inicializados
mensini: db 'Programa que calcula a Série de Fibonacci. ',13,10,'$'
mensfim: db 'bye',13,10,'$'
saida: db '00000',13,10,'$'
segment stack stack
    resb 256        ; reserva 256 bytes para formar a pilha
stacktop:           ; posição de memória que indica o topo da pilha=SP
