#include <stdio.h>

int main() {
    int linha, coluna;
    int i, somaprod;
    int mat1[4][4] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}};
    int mat2[4][4] = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    int mat3[4][4];
    int M1L = 4, M1C = 4, M2L = 4, M2C = 4;
    
    for (linha = 0; linha < M1L; linha++) {
        for (coluna = 0; coluna < M2C; coluna++) {
            somaprod = 0;
            for (i = 0; i < M1L; i++) 
                somaprod += mat1[linha][i] * mat2[i][coluna];
            mat3[linha][coluna] = somaprod;
        }
    }
    
    // Imprime mat3
    for (linha = 0; linha < M1L; linha++) {
        for (coluna = 0; coluna < M2C; coluna++)
            printf("%d ", mat3[linha][coluna]);
        printf("\n");
    }
    
    //system("PAUSE"); // Não é necessário para execução, pode ser removido
    return 0;
}
