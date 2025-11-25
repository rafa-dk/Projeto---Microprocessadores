.global MUL

MUL:
# Prologo
    subi sp, sp, 8
    stw ra, 4(sp)
    stw fp, 0(sp)
    
    addi fp, sp, 8
    
# r3 = r1 * r2 (r2 pequeno)
mov r7, r0
MULT_LOOP:
    beq r19, r0, MULT_END
    add r7, r7, r6
    subi r19, r19, 1
    br MULT_LOOP

MULT_END:
    ldw ra, 4(sp)
    ldw fp, 0(sp)
    addi sp, sp, 8

    ret
