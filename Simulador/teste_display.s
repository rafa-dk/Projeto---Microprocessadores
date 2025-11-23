.global _start

_start:
    # Inicializa o Stack Pointer (sp)
    movia sp, 0x10000

LOOP_PRINCIPAL:
    # ==========================================
    # INICIO DA LOGICA DE TRIANGULAR (ARQTRI)
    # ==========================================
    
    # Inicializacao de registradores
    movi r8, 0      # acumulador
    movi r7, 0      # contador
    movi r15, 0     # numeros armazenados
    movi r16, 0     # result_media / contador de digitos
    movi r20, 4     # constante 4

    # Enderecos
    .equ ALAVANCAS, 0x10000040
    .equ DISPLAYS_BASE, 0x10000020

CONVERTER:
    movia r10, ALAVANCAS
    ldwio r4, 0(r10)    # Le alavancas
    andi r4, r4, 0xFF   # separa os 8 primeiros bits

    # Prepara a pilha para armazenar 3 digitos
    subi sp, sp, 12

    movia r5, 10        # Carrega o divisor 10 em r5
    mov r16, r0         # r16 sera nosso contador de digitos

DIVISAO:
    # Divide o numero por 10
    div r6, r4, r5      # r6 = r4 / 10 (quociente)

    # Calcula o resto
    mul r7, r6, r5      # r7 = quociente * 10
    sub r7, r4, r7      # r7 = r4 - (quociente * 10) -> este e o resto (digito)

    # Empilha o digito encontrado
    mul r8, r16, r20    # r8 = r16 * 4
    add r8, sp, r8      # r8 = sp + offset
    stw r7, 0(r8)       # Salva o digito na pilha

    addi r16, r16, 1    # Incrementa o contador de digitos

    mov r4, r6          # O novo numero a ser dividido e o quociente
    bne r4, r0, DIVISAO # Se o quociente nao for zero, continua o loop

    # ==========================================
    # INICIO DA LOGICA DE DISPLAY
    # ==========================================
    # Fluxo continuo, sem call/ret
    
    movia r9, DISPLAYS_BASE # r9 = Endereco do registrador dos displays
    mov r10, r0             # r10 = contador de displays
    mov r11, r0             # r11 = buffer acumulador (inicia zerado)

DISPLAY_LOOP:
    # Se o contador de displays (r10) for igual ao numero de digitos (r16), terminamos
    beq r10, r16, WRITE_DISPLAYS

    # Calcula o endereco do digito na pilha
    mov r4, sp              # r4 aponta para o inicio dos digitos na pilha
    
    movi r6, 4
    mul r5, r10, r6         # Calcula o offset (indice * 4)
    add r4, r4, r5          # Endereco final
    ldw r7, 0(r4)           # Carrega o digito

    # Converte para 7 segmentos
    movia r8, SETE_SEG
    add r8, r8, r7
    ldb r8, 0(r8)

    # Desloca o padrao para a posicao correta (HEX0=0, HEX1=8, HEX2=16, HEX3=24)
    slli r5, r10, 3         # r5 = r10 * 8
    sll r8, r8, r5          # Desloca o padrao r8 para a esquerda

    # Adiciona ao buffer acumulador
    or r11, r11, r8         # Combina o novo padrao

    # Proximo display
    addi r10, r10, 1
    br DISPLAY_LOOP

WRITE_DISPLAYS:
    # Escreve a palavra completa de 32 bits nos displays
    stwio r11, 0(r9)

END_DISPLAY_LOGIC:
    # ==========================================
    # FINALIZACAO E LOOP
    # ==========================================
    
    # Libera o espaco alocado na pilha para os digitos
    addi sp, sp, 12

    # Volta para o inicio para ler as alavancas novamente
    br LOOP_PRINCIPAL

SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
