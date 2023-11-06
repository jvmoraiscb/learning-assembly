; Sistemas Embarcados I - 2023/02
;
; Bruno Santos Fernandes 				- 2021100784
; Joao Victor Morais Coimbra de Brito 	- 2021101244

segment data
	BLACK				equ	0						; constantes de cores da tela
	LIGHT_BLUE			equ	9
	BLUE				equ	1
	LIGHT_GREEN			equ	10
	GREEN				equ	2
	LIGHT_CYAN			equ	11
	CYAN				equ	3
	RED					equ	4
	LIGHT_MAGENTA		equ	13
	MAGENTA				equ	5
	BROWN				equ	6
	LIGHT_GRAY			equ	7
	GRAY				equ	8
	PINK				equ	12
	YELLOW				equ	14
	WHITE				equ 15
    BOARD_X1			equ 175						; coordenadas do tabuleiro de 288x288 pixels e aos blocos de texto
	BOARD_X2			equ 271
	BOARD_X3			equ 367
	BOARD_X4			equ 463
	BOARD_Y1			equ 151
	BOARD_Y2			equ 247
	BOARD_Y3			equ 343
	BOARD_Y4			equ 439
    BOARD_L1			equ 3						; coordenadas e strings das casas do tabuleiro
	BOARD_L2			equ 9
	BOARD_L3			equ 15
	BOARD_C1			equ 23
	BOARD_C2			equ 35
	BOARD_C3			equ 47
	BOARD_SQUARE_X1		equ 223
	BOARD_SQUARE_X2		equ 319
	BOARD_SQUARE_X3		equ 415
	BOARD_SQUARE_Y1		equ 391
	BOARD_SQUARE_Y2		equ 295
	BOARD_SQUARE_Y3		equ 199
	BOARD_SQUARE_X_R	equ 35
	BOARD_SQUARE_O_R	equ 38
	STRING_11	    	db '11'
	STRING_12	    	db '12'
	STRING_13	    	db '13'
	STRING_21	 	   	db '21'
	STRING_22	    	db '22'
	STRING_23	 	   	db '23'
	STRING_31	  	 	db '31'
	STRING_32	 	   	db '32'
	STRING_33	 	   	db '33'
	MSG_BOX_X1			equ 79						; coordenadas da caixa de mensagem
	MSG_BOX_X2			equ 559
	MSG_BOX_Y1			equ 15
	MSG_BOX_Y2			equ 63
    MSG_BOX_L    		equ 27
    MSG_BOX_C    		equ 11
	MSG_INVALID_PLAY	db 'Jogada Invalida!'		; buffer da caixa de mensagem
	SIZE_INVALID_PLAY	equ 16
	MSG_INVALID_CMD		db 'Comando Invalido!'
	SIZE_INVALID_CMD	equ 17
	MSG_PLAYER1_TURN	db 'Turno do jogador 1 (X)!'
	SIZE_PLAYER1_TURN	equ 23
	MSG_PLAYER2_TURN	db 'Turno do jogador 2 (O)!'
	SIZE_PLAYER2_TURN	equ 23
	MSG_PLAYER1_WIN		db 'Jogador 1 (X) venceu!'
	SIZE_PLAYER1_WIN	equ 21
	MSG_PLAYER2_WIN		db 'Jogador 2 (O) venceu!'
	SIZE_PLAYER2_WIN	equ 21
	MSG_DRAW			db 'Empate!'
	SIZE_DRAW			equ 7
	MSG_RESET			db '                       '
	SIZE_RESET			equ 23
    CMD_BOX_X1			equ 79						; coordenadas da caixa de comando
	CMD_BOX_X2			equ 559
	CMD_BOX_Y1			equ 79
	CMD_BOX_Y2			equ 127
    STRING_CMD_L    	equ 23
    STRING_CMD_C    	equ 11
    BUFFER_MAX      	equ 58						; buffer da caixa de comando
	TRUE				equ 1						; constantes do jogo
	FALSE				equ 0
	NULL				equ 0
	CHAR_ENTER			equ 0Dh
	CHAR_BACKSPACE		equ 08h
	CHAR_X_UPPER		equ 58h
	CHAR_C_UPPER		equ 43h
	CHAR_C_LOWER		equ 63h
	CHAR_S_LOWER		equ 73h
	CHAR_1				equ 31h
	CHAR_2				equ 32h
	CHAR_3				equ 33h
	PLAYER1				equ 1
	PLAYER2				equ 2
	MAX_MOVES			equ 9
	PLAY_11				equ 1
	PLAY_12				equ 2
	PLAY_13				equ 3
	PLAY_21				equ 4
	PLAY_22				equ 5
	PLAY_23				equ 6
	PLAY_31				equ 7
	PLAY_32				equ 8
	PLAY_33				equ 9
	WIN_11_13			equ 1
	WIN_21_23			equ 2
	WIN_31_33			equ 3
	WIN_11_31			equ 4
	WIN_12_32			equ 5
	WIN_13_33			equ 6
	WIN_11_33			equ 7
	WIN_13_31			equ 8

	player_turn			db 0						; variaveis do jogo
	is_game_over		db 0
	winning_player		db 0
	remaining_moves		db 0
	board_square_11		db 0
	board_square_12		db 0
	board_square_13		db 0
	board_square_21		db 0
	board_square_22		db 0
	board_square_23		db 0
	board_square_31		db 0
	board_square_32		db 0
	board_square_33		db 0
	buffer_size			db 0
	buffer   			resb BUFFER_MAX
    color				db 0						; variaveis referentes a tela: a tela tem 640x480 pixels e os caracteres ocupam 8x16 pixels 
    previous_mode		db 0
	deltax				dw 0						; variaveis referentes as funcoes de desenho
	deltay				dw 0

segment code
..start:
	mov		ax, data								; configuracao padrao
    mov		ds, ax
    mov		ax, stack
    mov		ss, ax
    mov		sp, stacktop
    mov		ah, 0Fh									; salvar modo corrente de video (vendo como esta o modo de video da maquina)
	int		10h
	mov		[previous_mode], al
	mov		al, 12h									; alterar modo de video para grafico 640x480 16 cores
	mov		ah, 0
	int		10h
main_start:
    call	Erase_all								; apaga o jogo anterior
	call	Draw_all								; desenha o tabuleiro, as caixas e as numeracoes
	mov		byte[board_square_11], NULL				; reseta as variaveis
	mov		byte[board_square_12], NULL
	mov		byte[board_square_13], NULL
	mov		byte[board_square_21], NULL
	mov		byte[board_square_22], NULL
	mov		byte[board_square_23], NULL
	mov		byte[board_square_31], NULL
	mov		byte[board_square_32], NULL
	mov		byte[board_square_33], NULL
	mov		byte[winning_player], NULL
	mov		byte[is_game_over], FALSE
	mov		byte[remaining_moves], MAX_MOVES
	mov		byte[player_turn], PLAYER1
main_loop:
	cmp		byte[winning_player], NULL
	jne		main_loop_if_win						; caso winnin_player != '0'
	cmp		byte[remaining_moves], 0
	jne		main_loop_if_player						; caso remaining_moves != '0'
	mov		byte[is_game_over], TRUE				; jogo terminou em empate
	call	Print_draw
	jmp		cmd_loop_start
main_loop_if_win:
	mov		byte[is_game_over], TRUE
	cmp		byte[winning_player], PLAYER2
	je		main_loop_if_win_player2
	call	Print_player1_win
	jmp		cmd_loop_start
main_loop_if_win_player2:
	call	Print_player2_win
	jmp		cmd_loop_start
main_loop_if_player:
	cmp		byte[player_turn], PLAYER2
	je		main_loop_if_player2					; caso dl == 'PLAYER2'
	call	Print_player1_turn						; imprime jogador2
	jmp		cmd_loop_start
main_loop_if_player2:
	call	Print_player2_turn						; imprime jogador1
cmd_loop_start:
	call	Clear_buffer							; limpa o buffer
	mov 	byte[buffer_size], 0					; zera contador de caracteres do buffer
cmd_loop:
	mov 	ah, 7									; interrupcao para receber uma tecla do buffer do teclado e armazenar em al
	int 	21h
	cmp 	al, CHAR_BACKSPACE						; caso al == 'backspace'
	je 		cmd_loop_if_backspace
	cmp 	al, CHAR_ENTER							; caso al == 'enter' (0A ou 0D)
	je 		cmd_loop_if_enter
	jmp 	cmd_loop_else
cmd_loop_if_backspace:								; apaga a ultima tecla do buffer
	cmp 	byte[buffer_size], 0					; caso cx = 0
	je 		cmd_loop								; nao existe o que apagar, entao retorna o loop
	dec 	byte[buffer_size]
	mov		cx, 0
	mov		cl, byte[buffer_size]
	mov 	bx, buffer
	add 	bx, cx
	mov 	byte[bx], 0
	call 	Print_buffer
	jmp 	cmd_loop
cmd_loop_if_enter:									; processa o buffer
	jmp 	cmd_loop_exit
cmd_loop_else:										; adiciona nova tecla ao buffer
	cmp 	byte[buffer_size], BUFFER_MAX			; caso cx = BUFFER_MAX
	je 		cmd_loop								; nao existe o que escrever, entao retorna o loop
	mov		cx, 0
	mov		cl, byte[buffer_size]
	inc 	byte[buffer_size]
	mov 	bx, buffer
	add 	bx, cx
	mov 	byte[bx], al
	call 	Print_buffer
	jmp 	cmd_loop
cmd_loop_exit:										; valida comando digitado
	cmp		byte[buffer_size], 1					; caso buffer_size = 1
	je		cmd_check_size_1						; o buffer so tem tamanho 1, entao so podem ser as instrucoes 'c' ou 's'
	cmp		byte[buffer_size], 3					; caso buffer_size = 3
	je		cmd_check_size_3						; o buffer so tem tamanho 3, entao so podem ser as instrucoes 'Xlc' ou 'Clc'
	jmp		cmd_check_invalid_cmd
cmd_check_size_1:
	cmp		byte[buffer], CHAR_C_LOWER				; caso buffer seja 'c'
	je		cmd_check_c
	cmp		byte[buffer], CHAR_S_LOWER				; caso buffer seja 's'
	je		cmd_check_s
	jmp		cmd_check_invalid_cmd					; caso contrario
cmd_check_size_3:
	cmp		byte[is_game_over], 1					; caso jogo acabou, qualquer jogada e invalida
	je		cmd_check_invalid_cmd
	cmp		byte[buffer], CHAR_X_UPPER				; caso buffer seja 'X'
	je		cmd_check_size_3_1
	cmp		byte[buffer], CHAR_C_UPPER				; caso buffer seja 'C'
	je		cmd_check_size_3_1
	jmp		cmd_check_invalid_cmd
cmd_check_size_3_1:
	cmp		byte[buffer+1], CHAR_1					; caso buffer seja '1'
	je		cmd_check_size_3_2
	cmp		byte[buffer+1], CHAR_2					; caso buffer seja '2'
	je		cmd_check_size_3_2
	cmp		byte[buffer+1], CHAR_3					; caso buffer seja '3'
	je		cmd_check_size_3_2
	jmp		cmd_check_invalid_cmd
cmd_check_size_3_2:
	cmp		byte[buffer+2], CHAR_1					; caso buffer seja '1'
	je		cmd_check_play
	cmp		byte[buffer+2], CHAR_2					; caso buffer seja '2'
	je		cmd_check_play
	cmp		byte[buffer+2], CHAR_3					; caso buffer seja '3'
	je		cmd_check_play
	jmp		cmd_check_invalid_cmd
cmd_check_invalid_cmd:
	call	Print_invalid_cmd
	jmp		cmd_loop_start
cmd_check_c:
	jmp		main_start
cmd_check_s:
	jmp		main_exit
cmd_check_play:										; valida jogada digitada
	mov		ah, byte[buffer+1]
	mov		al, byte[buffer+2]
	mov		bh, byte[buffer]
	call	Check_play
	cmp		ax, NULL
	jne		cmd_check_play_lc						; caso ax != 'null', a jogada e valida
	call	Print_invalid_play						; caso contrario, a jogada e invalida
	jmp		cmd_loop_start
cmd_check_play_lc:									; verifica qual foi a jogada valida
	mov		bl, byte[player_turn]
	mov		byte[color], LIGHT_GRAY					; cor selecionada para desenhar as jogadas
cmd_check_play_11:
	cmp		ax, PLAY_11
	jne		cmd_check_play_12						; caso nao seja essa, verificar a prox
	mov		byte[board_square_11], bl
	call	Draw_play_11
	jmp		cmd_check_play_exit
cmd_check_play_12:
	cmp		ax, PLAY_12
	jne		cmd_check_play_13						; caso nao seja essa, verificar a prox
	mov		byte[board_square_12], bl
	call	Draw_play_12
	jmp		cmd_check_play_exit
cmd_check_play_13:
	cmp		ax, PLAY_13
	jne		cmd_check_play_21						; caso nao seja essa, verificar a prox
	mov		byte[board_square_13], bl
	call	Draw_play_13
	jmp		cmd_check_play_exit
cmd_check_play_21:
	cmp		ax, PLAY_21
	jne		cmd_check_play_22						; caso nao seja essa, verificar a prox
	mov		byte[board_square_21], bl
	call	Draw_play_21
	jmp		cmd_check_play_exit
cmd_check_play_22:
	cmp		ax, PLAY_22
	jne		cmd_check_play_23						; caso nao seja essa, verificar a prox
	mov		byte[board_square_22], bl
	call	Draw_play_22
	jmp		cmd_check_play_exit
cmd_check_play_23:
	cmp		ax, PLAY_23
	jne		cmd_check_play_31						; caso nao seja essa, verificar a prox
	mov		byte[board_square_23], bl
	call	Draw_play_23
	jmp		cmd_check_play_exit
cmd_check_play_31:
	cmp		ax, PLAY_31
	jne		cmd_check_play_32						; caso nao seja essa, verificar a prox
	mov		byte[board_square_31], bl
	call	Draw_play_31
	jmp		cmd_check_play_exit
cmd_check_play_32:
	cmp		ax, PLAY_32
	jne		cmd_check_play_33						; caso nao seja essa, a prox foi a jogada valida (outros casos ja foram verificados)
	mov		byte[board_square_32], bl
	call	Draw_play_32
	jmp		cmd_check_play_exit
cmd_check_play_33:
	mov		byte[board_square_33], bl
	call	Draw_play_33
	jmp		cmd_check_play_exit
cmd_check_play_exit:
	dec		byte[remaining_moves]
cmd_check_win:	
	call	Check_win
	cmp		ax, NULL
	je		cmd_check_win_exit						; caso ax == 'null', ninguem venceu
	mov		bl, byte[player_turn]
	mov		byte[winning_player], bl				; caso contrario, jogador atual venceu
	mov		byte[color], YELLOW						; cor selecionada para desenhar as linhas de vitoria
cmd_check_win_11_13:								; verifica qual foi a sequencia vencedora
	cmp		ax, WIN_11_13
	jne		cmd_check_win_21_23						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_11_13
	jmp		cmd_check_win_exit
cmd_check_win_21_23:
	cmp		ax, WIN_21_23
	jne		cmd_check_win_31_33						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_21_23
	jmp		cmd_check_win_exit
cmd_check_win_31_33:
	cmp		ax, WIN_31_33
	jne		cmd_check_win_11_31						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_31_33
	jmp		cmd_check_win_exit
cmd_check_win_11_31:
	cmp		ax, WIN_11_31
	jne		cmd_check_win_12_32						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_11_31
	jmp		cmd_check_win_exit
cmd_check_win_12_32:
	cmp		ax, WIN_12_32
	jne		cmd_check_win_13_33						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_12_32
	jmp		cmd_check_win_exit
cmd_check_win_13_33:
	cmp		ax, WIN_13_33
	jne		cmd_check_win_11_33						; caso nao seja essa, verificar a prox
	call	Draw_winning_line_13_33
	jmp		cmd_check_win_exit
cmd_check_win_11_33:
	cmp		ax, WIN_11_33
	jne		cmd_check_win_13_31						; caso nao seja essa, a prox foi a sequencia vencedora (outros casos ja foram verificados)
	call	Draw_winning_line_11_33
	jmp		cmd_check_win_exit
cmd_check_win_13_31:
	call	Draw_winning_line_13_31
cmd_check_win_exit:
	call	Change_player_turn
	jmp		main_loop
main_exit:
	call	Erase_all								; limpa a tela
	mov    	ah, 08h									; retorna o controle do programa ao terminal
	int     21h
	mov  	ah, 0									; set video mode
	mov  	al, [previous_mode]						; modo anterior
	int  	10h
	mov     ax, 4C00h
	int     21h

; troca o turno do jogador
; parametros: 	byte[player_turn] = PLAYER1/PLAYER2
; retorno: 		-
Change_player_turn:
	cmp		byte[player_turn], PLAYER2				; verifica de quem e a proxima jogada
	je		change_player_turn_player2
change_player_turn_player1:
	mov		byte[player_turn], PLAYER2
	jmp		change_player_turn_exit
change_player_turn_player2:
	mov		byte[player_turn], PLAYER1
change_player_turn_exit:
	ret

; verifica se tres casas possuem o mesmo valor
; parametros: 	ah = casa1, al = casa2, bh = casa3
; retorno: 		ax = TRUE/FALSE
Check_three_squares:
	cmp		ah, NULL								; verifica se a primeira casa e nula
	je		check_three_squares_3
	cmp		ah, al									; verifica se a primeira casa e igual a segunda
	je		check_three_squares_1
	jmp		check_three_squares_3
check_three_squares_1:
	cmp		al, bh									; verifica se a segunda casa e igual a terceira
	je		check_three_squares_2
	jmp		check_three_squares_3
check_three_squares_2:								; se casa1 == casa2 == casa3
	mov		ax, TRUE								; retorna 1 (TRUE)
	jmp		check_three_squares_exit
check_three_squares_3:								; se nao
	mov		ax, FALSE								; retorna 0 (FALSE)
check_three_squares_exit:
	ret

; verifica se o jogador venceu
; parametros: 	byte[board_square_lc] = PLAYER1/PLAYER2/NULL
; retorno:		ax = WIN_LC_LC/NULL
Check_win:
check_win_11_13:
	mov		ah, byte[board_square_11]
	mov		al, byte[board_square_12]
	mov		bh, byte[board_square_13]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_21_23							; testa proximo caso de vitoria
	mov		ax, WIN_11_13							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_21_23:
	mov		ah, byte[board_square_21]
	mov		al, byte[board_square_22]
	mov		bh, byte[board_square_23]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_31_33							; testa proximo caso de vitoria
	mov		ax, WIN_21_23							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_31_33:
	mov		ah, byte[board_square_31]
	mov		al, byte[board_square_32]
	mov		bh, byte[board_square_33]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_11_31							; testa proximo caso de vitoria
	mov		ax, WIN_31_33							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_11_31:
	mov		ah, byte[board_square_11]
	mov		al, byte[board_square_21]
	mov		bh, byte[board_square_31]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_12_32							; testa proximo caso de vitoria
	mov		ax, WIN_11_31							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_12_32:
	mov		ah, byte[board_square_12]
	mov		al, byte[board_square_22]
	mov		bh, byte[board_square_32]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_13_33							; testa proximo caso de vitoria
	mov		ax, WIN_12_32							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_13_33:
	mov		ah, byte[board_square_13]
	mov		al, byte[board_square_23]
	mov		bh, byte[board_square_33]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_11_33							; testa proximo caso de vitoria
	mov		ax, WIN_13_33							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_11_33:
	mov		ah, byte[board_square_11]
	mov		al, byte[board_square_22]
	mov		bh, byte[board_square_33]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_13_31							; testa proximo caso de vitoria
	mov		ax, WIN_11_33							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_13_31:
	mov		ah, byte[board_square_13]
	mov		al, byte[board_square_22]
	mov		bh, byte[board_square_31]
	call	Check_three_squares
	cmp		ax, 0									; caso a funcao tenha retornado 0
	je		check_win_null							; testa proximo caso de vitoria
	mov		ax, WIN_13_31							; caso contrario o jogador venceu
	jmp		check_win_exit
check_win_null:
	mov		ax, NULL
check_win_exit:
	ret

; verifica se a jogada e valida
; parametros:	ah = l, al = c, bh = CHAR_X_UPPER/CHAR_C_UPPER, byte[player_turn] = PLAYER1/PLAYER2, byte[board_square_lc] = PLAYER1/PLAYER2/NULL
; retorno:		ax = PLAY_LC/NULL
Check_play:
	cmp		bh, CHAR_X_UPPER						; se bh == 'X'
	je		check_play_X
	jmp		check_play_C							; senao se bh == 'C' (outros casos ja foram verificados)
check_play_X:
	cmp		byte[player_turn], PLAYER1				; caso nao esteja no turno dele, a jogada e invalida
	je		check_play_lc
	jmp		check_play_null
check_play_C:
	cmp		byte[player_turn], PLAYER2				; caso nao esteja no turno dele, a jogada e invalida
	je		check_play_lc
	jmp		check_play_null
check_play_lc:
	cmp		ah, CHAR_1								; se ah == '1'
	je		check_play_1c
	cmp		ah, CHAR_2								; se ah == '2'
	je		check_play_2c
	jmp		check_play_3c							; senao se ah == '3' (outros casos ja foram verificados)
check_play_1c:
	cmp		al, CHAR_1								; se al == '1'
	je		check_play_11
	cmp		al, CHAR_2								; se al == '2'
	je		check_play_12
	jmp		check_play_13							; senao se al == '3' (outros casos ja foram verificados)
check_play_2c:
	cmp		al, CHAR_1								; se al == '1'
	je		check_play_21
	cmp		al, CHAR_2								; se al == '2'
	je		check_play_22
	jmp		check_play_23							; senao se al == '3' (outros casos ja foram verificados)
check_play_3c:
	cmp		al, CHAR_1								; se al == '1'
	je		check_play_31
	cmp		al, CHAR_2								; se al == '2'
	je		check_play_32
	jmp		check_play_33							; senao se al == '3'' (outros casos ja foram verificados)
check_play_null:
	mov		ax, NULL
	jmp		check_play_exit
check_play_11:
	cmp		byte[board_square_11], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_11
	jmp		check_play_exit
check_play_12:
	cmp		byte[board_square_12], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_12
	jmp		check_play_exit
check_play_13:
	cmp		byte[board_square_13], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_13
	jmp		check_play_exit
check_play_21:
	cmp		byte[board_square_21], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_21
	jmp		check_play_exit
check_play_22:
	cmp		byte[board_square_22], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_22
	jmp		check_play_exit
check_play_23:
	cmp		byte[board_square_23], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_23
	jmp		check_play_exit
check_play_31:
	cmp		byte[board_square_31], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_31
	jmp		check_play_exit
check_play_32:
	cmp		byte[board_square_32], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_32
	jmp		check_play_exit
check_play_33:
	cmp		byte[board_square_33], NULL    			; caso a casa nao esteja vazia, a jogada e invalida
	jne		check_play_null
	mov		ax, PLAY_33
	jmp		check_play_exit
check_play_exit:
	ret

; desenha o tabuleiro do jogo
; parametros:	byte[color] = color
; retorno:		-
Draw_board:
	mov		ax, BOARD_X1
	push	ax
	mov		ax, BOARD_Y2
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_Y2
	push	ax
	call	Line									; desenha linha horizontal 1 do tabuleiro
	mov		ax, BOARD_X1
	push	ax
	mov		ax, BOARD_Y3
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_Y3
	push	ax
	call	Line									; desenha linha horizontal 2 do tabuleiro
	mov		ax, BOARD_X2
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_X2
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; desenha linha vertical 1 do tabuleiro
	mov		ax, BOARD_X3
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_X3
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; desenha linha vertical 2 do tabuleiro
	ret

; desenha a caixa de comando
; parametros:	byte[color] = color
; retorno:		-
Draw_cmd_box:
	mov		ax, CMD_BOX_X1
	push	ax
	mov		ax, CMD_BOX_Y1
	push	ax
	mov		ax, CMD_BOX_X2
	push	ax
	mov		ax, CMD_BOX_Y1
	push	ax
	call	Line									; desenha linha horizontal 1 do bloco de cmd
	mov		ax, CMD_BOX_X1				
	push	ax
	mov		ax, CMD_BOX_Y2
	push	ax
	mov		ax, CMD_BOX_X2
	push	ax
	mov		ax, CMD_BOX_Y2
	push	ax
	call	Line									; desenha linha horizontal 2 do bloco de cmd
	mov		ax, CMD_BOX_X1
	push	ax
	mov		ax, CMD_BOX_Y1
	push	ax
	mov		ax, CMD_BOX_X1
	push	ax
	mov		ax, CMD_BOX_Y2
	push	ax
	call	Line									; desenha linha vertical 1 do bloco de cmd
	mov		ax, CMD_BOX_X2
	push	ax
	mov		ax, CMD_BOX_Y1
	push	ax
	mov		ax, CMD_BOX_X2
	push	ax
	mov		ax, CMD_BOX_Y2
	push	ax
	call	Line									; desenha linha vertical 2 do bloco de cmd
	ret

; desenha a caixa de mensagem
; parametros:	byte[color] = color
; retorno:		-
Draw_msg_box:
	mov		ax, MSG_BOX_X1
	push	ax
	mov		ax, MSG_BOX_Y1
	push	ax
	mov		ax, MSG_BOX_X2
	push	ax
	mov		ax, MSG_BOX_Y1
	push	ax
	call	Line									; desenha linha horizontal 1 do bloco de msg
	mov		ax, MSG_BOX_X1
	push	ax
	mov		ax, MSG_BOX_Y2
	push	ax
	mov		ax, MSG_BOX_X2
	push	ax
	mov		ax, MSG_BOX_Y2
	push	ax
	call	Line									; desenha linha horizontal 2 do bloco de msg
	mov		ax, MSG_BOX_X1
	push	ax
	mov		ax, MSG_BOX_Y1
	push	ax
	mov		ax, MSG_BOX_X1
	push	ax
	mov		ax, MSG_BOX_Y2
	push	ax
	call	Line									; desenha linha vertical 1 do bloco de msg
	mov		ax, MSG_BOX_X2
	push	ax
	mov		ax, MSG_BOX_Y1
	push	ax
	mov		ax, MSG_BOX_X2
	push	ax
	mov		ax, MSG_BOX_Y2
	push	ax
	call	Line									; desenha linha vertical 2 do bloco de msg
	ret

; desenha a numeracao das casas do tabuleiro
; parametros:	byte[color] = color
; retorno:		-
Draw_square_numbers:
	mov     cx, 2
	mov     bx, STRING_11
	mov     dh, BOARD_L1
	mov     dl, BOARD_C1
	call    Print_string							; escreve coordenada da casa 11
	mov     cx, 2
	mov     bx, STRING_12
	mov     dh, BOARD_L1
	mov     dl, BOARD_C2
	call    Print_string							; escreve coordenada da casa 12
	mov     cx, 2
	mov     bx, STRING_13
	mov     dh, BOARD_L1
	mov     dl, BOARD_C3
	call    Print_string							; escreve coordenada da casa 13
	mov     cx, 2
	mov     bx, STRING_21
	mov     dh, BOARD_L2
	mov     dl, BOARD_C1
	call    Print_string							; escreve coordenada da casa 21
	mov     cx, 2
	mov     bx, STRING_22
	mov     dh, BOARD_L2
	mov     dl, BOARD_C2
	call    Print_string							; escreve coordenada da casa 22
	mov     cx, 2
	mov     bx, STRING_23
	mov     dh, BOARD_L2
	mov     dl, BOARD_C3
	call    Print_string							; escreve coordenada da casa 23
	mov     cx, 2
	mov     bx, STRING_31
	mov     dh, BOARD_L3
	mov     dl, BOARD_C1
	call    Print_string							; escreve coordenada da casa 31
	mov     cx, 2
	mov     bx, STRING_32
	mov     dh, BOARD_L3
	mov     dl, BOARD_C2
	call    Print_string							; escreve coordenada da casa 32
	mov     cx, 2
	mov     bx, STRING_33
	mov     dh, BOARD_L3
	mov     dl, BOARD_C3
	call    Print_string							; escreve coordenada da casa 33
	ret

; desenha tudo (inicio do jogo)
; parametros:	byte[color] = color
; retorno:		-
Draw_all:
	mov		byte[color], WHITE
	call	Draw_board
	call	Draw_cmd_box
	call	Draw_msg_box
	mov		byte[color], LIGHT_GRAY
	call	Draw_square_numbers
	ret

; desenha um X/O no quadrado 11
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_11:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_11_O							; caso player_turn == 'PLAYER2'
draw_play_11_X:	
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_11_exit
draw_play_11_O:
	mov		ax, BOARD_SQUARE_X1						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_11_exit:
	ret

; desenha um X/O no quadrado 12
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_12:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_12_O							; caso player_turn == 'PLAYER2'
draw_play_12_X:	
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_12_exit
draw_play_12_O:
	mov		ax, BOARD_SQUARE_X2						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_12_exit:
	ret

; desenha um X/O no quadrado 13
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_13:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_13_O							; caso player_turn == 'PLAYER2'
draw_play_13_X:	
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y1-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_13_exit
draw_play_13_O:
	mov		ax, BOARD_SQUARE_X3					; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_13_exit:
	ret

; desenha um X/O no quadrado 21
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_21:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_21_O							; caso player_turn == 'PLAYER2'
draw_play_21_X:	
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_21_exit
draw_play_21_O:
	mov		ax, BOARD_SQUARE_X1						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_21_exit:
	ret

; desenha um X/O no quadrado 22
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_22:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_22_O							; caso player_turn == 'PLAYER2'
draw_play_22_X:	
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_22_exit
draw_play_22_O:
	mov		ax, BOARD_SQUARE_X2						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_22_exit:
	ret

; desenha um X no quadrado 23
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_23:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_23_O							; caso player_turn == 'PLAYER2'
draw_play_23_X:	
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y2-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_23_exit
draw_play_23_O:
	mov		ax, BOARD_SQUARE_X3						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_23_exit:
	ret

; desenha um X no quadrado 31
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_31:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_31_O							; caso player_turn == 'PLAYER2'
draw_play_31_X:	
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X1-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X1+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_31_exit
draw_play_31_O:
	mov		ax, BOARD_SQUARE_X1						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_31_exit:
	ret

; desenha um X/O no quadrado 32
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_32:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_32_O							; caso player_turn == 'PLAYER2'
draw_play_32_X:
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X2-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X2+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_32_exit
draw_play_32_O:
	mov		ax, BOARD_SQUARE_X2						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_32_exit:
	ret

; desenha um X/O no quadrado 33
; parametros:	byte[player_turn] = player, byte[color] = color
; retorno:		-
Draw_play_33:
	cmp		byte[player_turn], PLAYER2
	je		draw_play_33_O							; caso player_turn == 'PLAYER2'
draw_play_33_X:
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	mov		ax, BOARD_SQUARE_X3-BOARD_SQUARE_X_R	; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_X3+BOARD_SQUARE_X_R
	push	ax
	mov		ax, BOARD_SQUARE_Y3-BOARD_SQUARE_X_R
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	jmp		draw_play_33_exit
draw_play_33_O:
	mov		ax, BOARD_SQUARE_X3						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3
	push	ax
	mov		ax, BOARD_SQUARE_O_R
	push	ax
	call	Circle									; chama a funcao com os parametros empilhados
draw_play_33_exit:
	ret

; desenha linha vencedora 11-12-13
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_11_13:
	mov		ax, BOARD_X1							; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y1
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_SQUARE_Y1
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 21-22-23
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_21_23:
	mov		ax, BOARD_X1							; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y2
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_SQUARE_Y2
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 31-32-33
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_31_33:
	mov		ax, BOARD_X1							; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_SQUARE_Y3
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_SQUARE_Y3
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 11-21-31
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_11_31:
	mov		ax, BOARD_SQUARE_X1						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_SQUARE_X1
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 12-22-32
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_12_32:
	mov		ax, BOARD_SQUARE_X2						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_SQUARE_X2
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 13-23-33
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_13_33:
	mov		ax, BOARD_SQUARE_X3						; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_SQUARE_X3
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 11-22-33
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_11_33:
	mov		ax, BOARD_X1							; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; desenha linha vencedora 11-22-33
; parametros:	byte[color] = color
; retorno:		-
Draw_winning_line_13_31:
	mov		ax, BOARD_X1							; salva as coordenadas na pilha
	push	ax
	mov		ax, BOARD_Y1
	push	ax
	mov		ax, BOARD_X4
	push	ax
	mov		ax, BOARD_Y4
	push	ax
	call	Line									; chama a funcao com os parametros empilhados
	ret

; apaga tudo (fim de jogo)
; parametros:	-
; retorno:		-
Erase_all:
	mov		byte[color], BLACK						; desenha por cima de todos os desenhos possiveis em preto
	call	Draw_board
	call	Draw_cmd_box
	call	Draw_msg_box
	call	Draw_square_numbers
	mov		byte[player_turn], PLAYER1
	call	Draw_play_11
	call	Draw_play_12
	call	Draw_play_13
	call	Draw_play_21
	call	Draw_play_22
	call	Draw_play_23
	call	Draw_play_31
	call	Draw_play_32
	call	Draw_play_33
	mov		byte[player_turn], PLAYER2
	call	Draw_play_11
	call	Draw_play_12
	call	Draw_play_13
	call	Draw_play_21
	call	Draw_play_22
	call	Draw_play_23
	call	Draw_play_31
	call	Draw_play_32
	call	Draw_play_33
	call	Draw_winning_line_11_13
	call	Draw_winning_line_21_23
	call	Draw_winning_line_31_33
	call	Draw_winning_line_11_31
	call	Draw_winning_line_12_32
	call	Draw_winning_line_13_33
	call	Draw_winning_line_11_33
	call	Draw_winning_line_13_31
	call	Clear_buffer
	call	Print_buffer
	call	Print_reset
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_invalid_cmd:
	mov		byte[color], RED	
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_INVALID_CMD					; num de caracteres
	mov     bx, MSG_INVALID_CMD						; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_invalid_play:
	mov		byte[color], RED	
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_INVALID_PLAY					; num de caracteres
	mov     bx, MSG_INVALID_PLAY					; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_player1_turn:
	mov		byte[color], LIGHT_GRAY
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_PLAYER1_TURN					; num de caracteres
	mov     bx, MSG_PLAYER1_TURN					; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_player2_turn:
	mov		byte[color], LIGHT_GRAY	
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_PLAYER2_TURN					; num de caracteres
	mov     bx, MSG_PLAYER2_TURN					; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_player1_win:
	mov		byte[color], YELLOW	
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_PLAYER1_WIN					; num de caracteres
	mov     bx, MSG_PLAYER1_WIN						; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_player2_win:
	mov		byte[color], YELLOW
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_PLAYER2_WIN					; num de caracteres
	mov     bx, MSG_PLAYER2_WIN						; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_draw:
	mov		byte[color], LIGHT_CYAN
	call	Print_reset								; reseta a caixa de mensagem
	mov		cx, SIZE_DRAW							; num de caracteres
	mov     bx, MSG_DRAW							; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_buffer:
	mov		byte[color], LIGHT_GRAY
	mov		cx, BUFFER_MAX							; num de caracteres
	mov     bx, buffer		      					; string
	mov     dh, STRING_CMD_L						; linha 0-29
	mov     dl, STRING_CMD_C						; coluna 0-79
	call 	Print_string
	ret

; imprime string especifica com cor especifica
; parametros:	-
; retorno:		-
Print_reset:
	mov		cx, SIZE_RESET							; num de caracteres
	mov     bx, MSG_RESET							; string
	mov     dh, MSG_BOX_L							; linha 0-29
	mov     dl, MSG_BOX_C							; coluna 0-79
	call 	Print_string
	ret

; reseta o buffer
; parametros:	-
; retorno:		-
Clear_buffer:
	mov		cx, 0									; zera o contador
clear_buffer_loop:
	cmp		cx, BUFFER_MAX							; se cx = buffer max
	je		clear_buffer_loop_exit					; o loop ja percorreu todo o buffer entao ja pode ser finalizado
	mov 	bx, buffer								; carrega o endereco do buffer
	add 	bx, cx									; adiciona o offset
	mov 	byte[bx], 00h							; preenche a posicao com o Caracter nulo
	inc		cx 										; cx += 1
	jmp		clear_buffer_loop	
clear_buffer_loop_exit:
	ret

; escreve uma string na tela
; parametros:	bx = string, cx = num de caracteres, dh = linha (0-29), dl = coluna (0-79), byte[color] = color
; retorno:		-
Print_string:
print_string_loop:
	call	Cursor
	mov     al, [bx]
	call	Caracter
	inc     bx										; proximo caracter
	inc		dl										; avanca a coluna
	loop    print_string_loop
	ret

; posiciona cursor (fornecida pelo professor)
; parametros:	dh = linha (0-29),  dl = coluna  (0-79)
; retorno:		-
Cursor:
	pushf
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	mov     ah,2
	mov     bh,0
	int     10h
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	ret

; escreve caracter na posicao do cursor (fornecida pelo professor)
; parametros:	al = Caracter a ser escrito, byte[color] = color
; retorno:		-
Caracter:
	pushf
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	mov    	ah,9
	mov    	bh,0
	mov   	cx,1
	mov    	bl,[color]
	int    	10h
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	ret

; funcao plot_xy (fornecida pelo professor)
; parametros:	push x, push y, byte[color] = color (x<639, y<479)
; retorno:		-
Plot_xy:
	push	bp
	mov		bp,sp
	pushf
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	mov     ah,0ch
	mov     al,[color]
	mov     bh,0
	mov     dx,479
	sub		dx,[bp+4]
	mov     cx,[bp+6]
	int     10h
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		4

; funcao circle (fornecida pelo professor)
; parametros:	push xc, push yc, push r, byte[color] = color  (xc+r<639,yc+r<479)&&(xc-r>0,yc-r>0)
; retorno:		-
Circle:
	push 	bp
	mov	 	bp,sp
	pushf            	;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	mov		ax,[bp+8]   ; resgata xc
	mov		bx,[bp+6]   ; resgata yc
	mov		cx,[bp+4]   ; resgata r
	mov 	dx,bx	
	add		dx,cx      	;ponto extremo superior
	push    ax			
	push	dx
	call 	Plot_xy
	mov		dx,bx
	sub		dx,cx       ;ponto extremo inferior
	push    ax			
	push	dx
	call 	Plot_xy
	mov 	dx,ax	
	add		dx,cx       ;ponto extremo direita
	push    dx			
	push	bx
	call 	Plot_xy
	mov		dx,ax
	sub		dx,cx       ;ponto extremo esquerda
	push    dx			
	push	bx
	call 	Plot_xy
	mov		di,cx
	sub		di,1	 	;di=r-1
	mov		dx,0  		;dx ser  a vari vel x. cx   a variavel y
	;aqui em cima a l gica foi invertida, 1-r => r-1
	;e as compara  es passaram a ser jl => jg, assim garante 
	;valores positivos para d
	stay:					;loop
	mov		si,di
	cmp		si,0
	jg		inf       	;caso d for menor que 0, seleciona pixel superior (n o  salta)
	mov		si,dx		;o jl   importante porque trata-se de conta com sinal
	sal		si,1		;multiplica por doi (shift arithmetic left)
	add		si,3
	add		di,si     	;nesse ponto d=d+2*dx+3
	inc		dx			;incrementa dx
	jmp		plotar
	inf:	
	mov		si,dx
	sub		si,cx  		;faz x - y (dx-cx), e salva em di 
	sal		si,1
	add		si,5
	add		di,si		;nesse ponto d=d+2*(dx-cx)+5
	inc		dx			;incrementa x (dx)
	dec		cx			;decrementa y (cx)
	plotar:	
	mov		si,dx
	add		si,ax
	push    si			;coloca a abcisa x+xc na pilha
	mov		si,cx
	add		si,bx
	push    si			;coloca a ordenada y+yc na pilha
	call 	Plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,dx
	push    si			;coloca a abcisa xc+x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call 	Plot_xy		;toma conta do s timo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc+x na pilha
	call 	Plot_xy		;toma conta do segundo octante
	mov		si,ax
	add		si,cx
	push    si			;coloca a abcisa xc+y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call 	Plot_xy		;toma conta do oitavo octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	add		si,cx
	push    si			;coloca a ordenada yc+y na pilha
	call 	Plot_xy		;toma conta do terceiro octante
	mov		si,ax
	sub		si,dx
	push    si			;coloca a abcisa xc-x na pilha
	mov		si,bx
	sub		si,cx
	push    si			;coloca a ordenada yc-y na pilha
	call 	Plot_xy		;toma conta do sexto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	sub		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call 	Plot_xy		;toma conta do quinto octante
	mov		si,ax
	sub		si,cx
	push    si			;coloca a abcisa xc-y na pilha
	mov		si,bx
	add		si,dx
	push    si			;coloca a ordenada yc-x na pilha
	call 	Plot_xy		;toma conta do quarto octante
	cmp		cx,dx
	jb		fim_circle  ;se cx (y) est  abaixo de dx (x), termina     
	jmp		stay		;se cx (y) est  acima de dx (x), continua no loop
	fim_circle:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		6

; funcao line (fornecida pelo professor)
; parametros:	push x1, push y1, push x2, push y2, byte[color] = color  (x<639, y<479)
; retorno:		-
Line:
	push	bp
	mov		bp,sp
	pushf				;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di
	mov		ax,[bp+10]	; resgata os valores das coordenadas
	mov		bx,[bp+8]  	; resgata os valores das coordenadas
	mov		cx,[bp+6]  	; resgata os valores das coordenadas
	mov		dx,[bp+4]  	; resgata os valores das coordenadas
	cmp		ax,cx
	je		line2
	jb		line1
	xchg	ax,cx
	xchg	bx,dx
	jmp		line1
	line2:					; deltax=0
	cmp		bx,dx  		; subtrai dx de bx
	jb		line3
	xchg	bx,dx       ; troca os valores de bx e dx entre eles
	line3:					; dx > bx
	push	ax
	push	bx
	call 	Plot_xy
	cmp		bx,dx
	jne		line31
	jmp		fim_line
	line31:		inc		bx
	jmp		line3
	line1:
	;comparar modulos de deltax e deltay sabendo que cx>ax
	; cx > ax
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	ja		line32
	neg		dx
	line32:		
	mov		[deltay],dx
	pop		dx
	push	ax
	mov		ax,[deltax]
	cmp		ax,[deltay]
	pop		ax
	jb		line5
	; cx > ax e deltax>deltay
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	mov		[deltay],dx
	pop		dx
	mov		si,ax
	line4:
	push	ax
	push	dx
	push	si
	sub		si,ax			;(x-x1)
	mov		ax,[deltay]
	imul		si
	mov		si,[deltax]		;arREDondar
	shr		si,1
	; se numerador (DX)>0 soma se <0 subtrai
	cmp		dx,0
	jl		ar1
	add		ax,si
	adc		dx,0
	jmp		arc1
	ar1:
	sub		ax,si
	sbb		dx,0
	arc1:
	idiv	word [deltax]
	add		ax,bx
	pop		si
	push	si
	push	ax
	call	Plot_xy
	pop		dx
	pop		ax
	cmp		si,cx
	je		fim_line
	inc		si
	jmp		line4
	line5:		
	cmp		bx,dx
	jb 		line7
	xchg	ax,cx
	xchg	bx,dx
	line7:
	push	cx
	sub		cx,ax
	mov		[deltax],cx
	pop		cx
	push	dx
	sub		dx,bx
	mov		[deltay],dx
	pop		dx
	mov		si,bx
	line6:
	push	dx
	push	si
	push	ax
	sub		si,bx			;(y-y1)
	mov		ax,[deltax]
	imul		si
	mov		si,[deltay]		;arREDondar
	shr		si,1
	; se numerador (DX)>0 soma se <0 subtrai
	cmp		dx,0
	jl		ar2
	add		ax,si
	adc		dx,0
	jmp		arc2
	ar2:		
	sub		ax,si
	sbb		dx,0
	arc2:
	idiv	word [deltay]
	mov		di,ax
	pop		ax
	add		di,ax
	pop		si
	push	di
	push	si
	call	Plot_xy
	pop		dx
	cmp		si,dx
	je		fim_line
	inc		si
	jmp		line6
	fim_line:
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	popf
	pop		bp
	ret		8

segment stack stack
    		resb 		512
stacktop:
