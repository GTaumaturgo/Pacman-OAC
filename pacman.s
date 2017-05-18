.eqv 

.data	
	charB: .byte 66
	charE: .byte 69
	charF: .byte 70
	
	char0: .byte 48
	char1: .byte 49
	char2: .byte 50
	char3: .byte 51
	char4: .byte 52
	char5: .byte 53
	char6: .byte 54
	
	bitmap: .word 0xff000000
	estou_aq: .asciiz "Estou aqui\n" # mensagem para debug
	erro_arq: .asciiz "ERRO: Erro ao abrir arquivo, provavelmente o arquivo nao foi encontrado\n"
	erro_text:.asciiz "ERRO: algum caractere nao pode ser reconhecido ao aplicar as texturas"
	# arquivos para carregar mapa na memória e as texturas corretamente
	#map_width: .space  1
	#map_height: .space 1
	mapbin: .asciiz "mapas/teste.bin"
	bufbin: .space 768
	maptex: .asciiz "mapas/teste.texture"
	buftex: .space 768
	# arquivos com as texturas.
	tex0: .asciiz "imagens/parede-vertical.bin"
	buf0: .space 100
	tex1: .asciiz "imagens/parede-horizontal.bin"
	buf1: .space 100
	tex2: .asciiz "imagens/parede-curva-CD.bin"
	buf2: .space 100
	tex3: .asciiz "imagens/parede-curva-BE.bin"
	buf3: .space 100
	tex4: .asciiz "imagens/parede-curva-BD.bin"
	buf4: .space 100
	tex5: .asciiz "imagens/parede-curva-CE.bin"
	buf5: .space 100
	tex6: .asciiz "imagens/parede-sozinha.bin"
	buf6: .space 100			
	tex7: .asciiz "imagens/comida.bin"
	buf7: .space 100
	tex8: .asciiz "imagens/comida-grande.bin"
	buf8: .space 100
	tex9: .asciiz "imagens/parede-vazia.bin"
	buf9: .space 100
	
.text
	jal carrega_texturas

	jal carrega_mapa
	
	jal desenha_mapa
	
	li $v0, 10
	syscall
# essa rotina desenha o mapa inicialmente,
# a partir das informações carregadas em memória
desenha_mapa:
	addi $sp, $sp, -4
	
	sw   $ra, 0($sp)
	
	li   $t1, 24
	li   $t3, 32
	li   $t5, 10
	li   $t7  10
	lw   $a0, bitmap
	la   $a1, buftex
	
	jal desenha1
	
	
		
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

desenha1:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	li   $t0, 0
loop_desenha1:	
	beq $t0, $t1, fim_loop_desenha1
	jal desenha2
	
	addi $t0, $t0, 1
	j loop_desenha1
fim_loop_desenha1:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

desenha2:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li   $t2, 0
loop_desenha2:	
	beq $t2, $t3, fim_loop_desenha2
	lb $t8, 0($a1) # t8 = caractere da textura
	# e possiv/el otimizar trocando os beqs por bnes e inserindo vários labels
	lb $t9, charE
	la $a2, buf9
	beq $t8, $t9, apos_escolher
	
	lb $t9, charF
	la $a2, buf7
	beq $t8, $t9, apos_escolher
	
	lb $t9, charB
	la $a2, buf8
	beq $t8, $t9, apos_escolher
	
	lb $t9, char0
	la $a2, buf0
	beq $t8, $t9, apos_escolher
	
	lb $t9, char1
	la $a2, buf1
	beq $t8, $t9, apos_escolher
	
	lb $t9, char2
	la $a2, buf2
	beq $t8, $t9, apos_escolher
	
	lb $t9, char3
	la $a2, buf3
	beq $t8, $t9, apos_escolher
	
	lb $t9, char4
	la $a2, buf4
	beq $t8, $t9, apos_escolher
	
	lb $t9, char5
	la $a2, buf5
	beq $t8, $t9, apos_escolher
	
	lb $t9, char6
	la $a2, buf6
	beq $t8, $t9, apos_escolher
	
	j erro_reconhecimento_textura
apos_escolher:	
	jal desenha3

	addi $t2, $t2, 1
	addi $a1, $a1, 1 # atualiza buftex
	j loop_desenha2
fim_loop_desenha2:
	addi $a0, $a0, 2880
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

desenha3:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	li   $t4, 0
loop_desenha3:

	beq $t4, $t5, fim_loop_desenha3 # se t4 == t5, break
	jal desenha4	
	addi $t4, $t4, 1
	j loop_desenha3
fim_loop_desenha3:
	addi $a0, $a0, -3190
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

desenha4:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	li   $t6, 0
loop_desenha4:
	beq $t6, $t7, fim_loop_desenha4 # se t6 == t7, break
	lb   $a3, 0($a2)
	sb   $a3, 0($a0)
	addi $a2, $a2, 1 # atualiza ponteiro para o buffer
	addi $t6, $t6, 1 # atualiza contador
	addi $a0, $a0, 1 # atualiza bitmap
	j loop_desenha4
fim_loop_desenha4:
	addi $a0, $a0, 310
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
carrega_mapa:
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	#Carrega arquivo.bin em memória
	la $a0, mapbin
	la $a1, bufbin
	la $a2, 768
	jal le_arquivo
	
	#Carrega arquivo ,tex em memória
	la $a0, maptex
	la $a1, buftex
	jal le_arquivo
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

	
# funcao que imprime caso passe por lá, só serve para debug mesmo.
debug:
	addi $sp, $sp, -4
	sw   $a0, 0($sp)
	la $a0, estou_aq
	li $v0, 4
	syscall
	lw  $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# esse procedimento carrega todas as texturas em memória
carrega_texturas: addi $sp, $sp, -4
		  sw   $ra, 0($sp)
		   
		  la $a0, tex0
		  la $a1, buf0
		  li $a2, 100
		  jal le_arquivo
		 
		  la $a0, tex1
		  la $a1, buf1
		  jal le_arquivo
		  			  
		  la $a0, tex2
		  la $a1, buf2
		  jal le_arquivo
	  
		  la $a0, tex3
		  la $a1, buf3
		  jal le_arquivo

		  la $a0, tex4
		  la $a1, buf4
		  jal le_arquivo
					  
		  la $a0, tex5
		  la $a1, buf5
		  jal le_arquivo
		  
		  la $a0, tex6
		  la $a1, buf6
		  jal le_arquivo
		
		  la $a0, tex7
		  la $a1, buf7
		  jal le_arquivo
		  
		  la $a0, tex8
		  la $a1, buf8
		  jal le_arquivo
		  
		  la $a0, tex9
		  la $a1, buf9
		  jal le_arquivo
		
		  lw $ra, 0($sp)
		  addi $sp, $sp, 4
		  jr $ra

# imprime mensagem de erro e encerra o programa	  
file_error: 
	la $a0, erro_arq
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
erro_reconhecimento_textura:
	la $a0, erro_text
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
read_error: li $v0, 10 
 	    syscall
 	    
# esse procedimento recebe:
# nome do arquivo em $a0
# buffer  para escrever o que ler em $a1
# tamanho do arquivo em $a2
le_arquivo: 
	    move $t1, $a1
	    move $t2, $a2
	    li $a1, 0
	    li $a2, 0
	    li $v0, 13	
	    syscall
	    bltz $v0, file_error
	    move $a0, $v0
	    move $a1, $t1
	    move $a2, $t2	    
	    li $v0, 14
	    syscall
	    beqz $v0, return # EOF significa que acabou de ler
	    bltz $v0, read_error # isso nunca deveria ocorrer
	    jr $ra
	    
return: jr $ra
