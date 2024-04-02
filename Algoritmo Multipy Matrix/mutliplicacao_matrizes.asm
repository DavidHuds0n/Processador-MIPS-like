.data
mat1: .word 1, 2, 3, 4       # Matriz 4x4
      .word 5, 6, 7, 8
      .word 9, 10, 11, 12
      .word 13, 14, 15, 16

mat2: .word 1, 0, 0, 0       # Matriz identidade 4x4
      .word 0, 1, 0, 0
      .word 0, 0, 1, 0
      .word 0, 0, 0, 1

mat3: .space 64              # Matriz resultado 4x4 (4 * 4 * 4)

.text
.globl main

main:
    # Load constants
    li $t0, 4	    	   # Tamanho do lado das matriz
    la $s0, mat1           # Endereço de mat1
    la $s1, mat2           # Endereço de mat2
    la $s2, mat3           # Endereço de mat3

    # Initialize loop variables
    li $t1, 0              # linha = 0
outer_loop:
    bge $t1, $t0, exit_outer_loop  # if linha >= 4, exit outer loop
    
    li $t2, 0              # coluna = 0
inner_loop:
    bge $t2, $t0, exit_inner_loop  # if coluna >= 4, exit inner loop
    
    # Initialize somaprod
    li $t3, 0              # somaprod = 0

    li $t4, 0              # i = 0
inner_most_loop:
    bge $t4, $t0, exit_inner_most_loop  # if i >= 4, exit innermost loop

    # Calculate mat1[linha][i] and mat2[i][coluna]
    mul $t5, $t1, $t0      # $t5 = linha * 4
    add $t5, $t5, $t4      # $t5 = (linha * 4) + i
    sll $t5, $t5, 2        # $t5 = (linha * 4 + i) * 4 (convert to byte offset)
    add $t5, $t5, $s0	   # Obtem o endereço do elemento baseado no offset
    lw $t6, 0($t5)         # $t6 = mat1[linha][i]

    mul $t7, $t4, $t0      # $t7 = i * 4
    add $t7, $t7, $t2      # $t7 = (i * 4) + coluna
    sll $t7, $t7, 2        # $t7 = (i * 4 + coluna) * 4 (convert to byte offset)
    add $t7, $t7, $s1      # Obtem o endereço do elemento baseado no offset
    lw $t8, 0($t7)         # $t8 = mat2[i][coluna]

    # Calculate product and add to somaprod
    mul $t6, $t6, $t8     # $t6 = mat1[linha][i] * mat2[i][coluna]
    add $t3, $t3, $t6      # somaprod += mat1[linha][i] * mat2[i][coluna]

    # Increment i
    addi $t4, $t4, 1       # i++

    j inner_most_loop      # Repeat innermost loop

exit_inner_most_loop:
    # Store somaprod in mat3[linha][coluna]
    mul $t9, $t1, $t0      # $t9 = linha * 4
    add $t9, $t9, $t2      # $t9 = (linha * 4) + coluna
    sll $t9, $t9, 2        # $t9 = (linha * 4 + coluna) * 4 (convert to byte offset)
    add $t9, $t9, $s2	   # Obtem o endereço do elemento baseado no offset
    sw $t3, 0($t9)      # mat3[linha][coluna] = somaprod 

    # Increment coluna
    addi $t2, $t2, 1       # coluna++

    j inner_loop           # Repeat inner loop

exit_inner_loop:
    # Increment linha
    addi $t1, $t1, 1       # linha++

    j outer_loop           # Repeat outer loop

exit_outer_loop:
    # Print mat3
    li $t1, 0              # Reset linha = 0
outer_print_loop:
    bge $t1, $t0, exit_print_outer_loop  # if linha >= 4, exit outer print loop
    
    li $t2, 0              # Reset coluna = 0
inner_print_loop:
    bge $t2, $t0, exit_print_inner_loop  # if coluna >= 4, exit inner print loop
    
    # Print mat3[linha][coluna]
    mul $t5, $t1, $t0      # $t5 = linha * 4
    add $t5, $t5, $t2      # $t5 = (linha * 4) + coluna
    sll $t5, $t5, 2        # $t5 = (linha * 4 + coluna) * 4 (convert to byte offset)
    add $t5, $t5, $s2	   # Obtem o endereço do elemento baseado no offset
    lw $a0, 0($t5)         # $a0 = mat3[linha][coluna]
    li $v0, 1              # syscall code for printing integer
    syscall

    # Print space
    li $v0, 11             # syscall code for printing character
    li $a0, ' '            # ASCII code for space
    syscall

    # Increment coluna
    addi $t2, $t2, 1       # coluna++

    j inner_print_loop     # Repeat inner print loop

exit_print_inner_loop:
    # Print new line
    li $v0, 11             # syscall code for printing character
    li $a0, '\n'           # ASCII code for new line
    syscall

    # Increment linha
    addi $t1, $t1, 1       # linha++

    j outer_print_loop     # Repeat outer print loop

exit_print_outer_loop:
    li $v0, 10             # syscall code for exit
    syscall