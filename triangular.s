.equ ALAVANCAS, 0x10000040

.data
DIGITS_BUFFER:
    .skip 32

.text
.global ARQTRI
ARQTRI:
    subi sp, sp, 40
    stw ra, 36(sp)
    stw fp, 32(sp)
    stw r5, 28(sp)
    stw r6, 24(sp)
    stw r7, 20(sp)
    stw r8, 16(sp)
    stw r10, 12(sp)
    stw r15, 8(sp)
    stw r17, 4(sp)
    stw r20, 0(sp)

    addi fp, sp, 32

	movi r8, 0		#acumulador = 0
	movi r7, 0		#contador = 1
	movi r15, 0		#numeros armazenados (num)
	movi r16, 0		#result_media = 0
	movi r20, 0x4

/*
Assumimos que o valor das alavancas (0-255) esta em r4
r5 sera usado para o divisor (10)
r6 guardara o quociente
r7 guardara o resto (o dígito decimal)
Usaremos a pilha (stack) para armazenar os digitos temporariamente
*/
CONVERTER:
	movia r10, ALAVANCAS
	ldwio r4, (r10)
	andi r4, r4, 0xFF	#separa os 8 primeiros bits

	#Prepara a pilha para armazenar 8 digitos (32 bytes)
    #subi sp, sp, 32

    movia r5, 10        #Carrega o divisor 10 em r5
    mov r16, r0         #r16 sera nosso contador de digitos
    movia r17, DIGITS_BUFFER # Carrega endereco do buffer em r17


DIVISAO:
    #Divide o numero por 10
    div r6, r4, r5      #r6 = r4 / 10 (quociente)

    #Calcula o resto
    mul r7, r6, r5      #r7 = quociente * 10
    sub r7, r4, r7      #r7 = r4 - (quociente * 10) -> este e o resto (digito)

    #Empilha o digito encontrado
    #O offset e calculado com base no numero de digitos ja processados
    mul r8, r16, r20    #r8 = r16 * 4 (r20 ja tem 4)
    add r8, r17, r8      #r8 = buffer + offset
    stw r7, 0(r8)       #Salva o digito no buffer

    addi r16, r16, 1    #Incrementa o contador de digitos

    mov r4, r6          #O novo numero a ser dividido e o quociente
    bne r4, r0, DIVISAO #Se o quociente nao for zero, continua o loop

/*
Fim da conversao
Neste ponto, os digitos estao no buffer
Por exemplo, se o numero era 123:
buffer[0] -> 3 (unidade)
buffer[4] -> 2 (dezena)
buffer[8] -> 1 (centena)
O registrador r16 contem a quantidade de digitos - 1
*/

movia r4, DIGITS_BUFFER
call DISPLAY

# Libera o espaco alocado na pilha para os digitos
#addi sp, sp, 32

FIM_TRI:

    ldw ra, 36(sp)
    ldw fp, 32(sp)
    ldw r5, 28(sp)
    ldw r6, 24(sp)
    ldw r7, 20(sp)
    ldw r8, 16(sp)
    ldw r10, 12(sp)
    ldw r15, 8(sp)
    ldw r17, 4(sp)
    ldw r20, 0(sp)

    addi sp, sp, 40

    ret