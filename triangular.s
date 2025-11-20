/****
MAIN
****/
.global _start

_start:


#traduzir numero para codigo 7seg
	movia r15, SETE_SEG

	add r15, r15, r16	#SETE_SEG[4PRIMEIROSBITS]

	ldb r15, (r15)	#carrega codigo 7seg (loadbyte)

	movia r11, 0x10000020	#DISPLAYS - HEX 0-HEX 3
	stwio r15, (r11)




FIM:
	br FIM

SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x7, 0x7F, 0x6F, 0x5C, 0x4


