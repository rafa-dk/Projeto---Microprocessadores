.global DIV

DIV:
# Prologo
    subi sp, sp, 8
    stw ra, 4(sp)
    stw fp, 0(sp)
    
    addi fp, sp, 8
# r6 = r18 / r19
mov r6, r0

DIV_LOOP:
    blt r18, r19, FIM_DIV
    sub r18, r18, r19
    addi r6, r6, 1
    br DIV_LOOP

FIM_DIV:
    ldw ra, 4(sp)
    ldw fp, 0(sp)
    addi sp, sp, 8

    ret