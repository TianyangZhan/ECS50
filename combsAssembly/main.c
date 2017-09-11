#include <stdio.h>
#include <stdlib.h>
#include "combs.h"

void print_mat(int** mat, int num_rows, int num_cols);
void free_mat(int** mat, int num_rows, int num_cols);

int max(int a, int b){
  return a > b ? a : b;
}

int min(int a, int b){
  return a < b ? a : b;
}

int num_combs(int n, int k){
  int combs = 1;
  int i;
  
  for(i = n; i > max(k, n-k); i--){
    combs *= i;
  }

  for(i = 2; i <= min(k, n - k); i++){
    combs /= i;
  }
  
  return combs;

}

void rec_combos(int k, int num_cols,int len, int* row,int* temp,int* items,int** mat){
    if(k == 0){
        for(int i = 0; i < num_cols; ++i){
            mat[*row][i] = temp[i];
        }
        (*row)++;
        return;
    }else{
        for(int i = 0; i < len; i++){
            temp[num_cols - k] = items[i];
            rec_combos(k - 1, num_cols, len - i - 1,row,temp,items + i + 1,mat);
        }
    }
}

//my code
int** get_combs(int* items, int k, int len){
    int cmbs = num_combs(len, k);
    int** mat = (int**)malloc(cmbs * sizeof(int*));
    int* temp = (int*)malloc(k *sizeof(int));
    int row = 0;
    
    for(int i = 0; i < cmbs; ++i){
        mat[i] = (int*)malloc(k * sizeof(int));
    }
    rec_combos(k,k,len,&row,temp,items,mat);
    return mat;
}



void print_mat(int** mat, int num_rows, int num_cols){
  int i,j;
  
  for(i = 0; i < num_rows; i++){
    for( j = 0; j < num_cols; j++){
      printf("%d ", mat[i][j]); 
    }
    printf("\n");
  }
}

void free_mat(int** mat, int num_rows, int num_cols){
  int i;
  
  for(i = 0; i < num_rows; i++){
    free(mat[i]);
  }
  free(mat);
}


int main(){
  int num_items;
  int* items; 
  int i,k;
  int** combs;
  printf("How many items do you have: ");
  scanf("%d", &num_items);
  
  items = (int*) malloc(num_items * sizeof(int));
  
  printf("Enter your items: ");
  for(i = 0; i < num_items; i++){
    scanf("%d", &items[i]);
  } 
  
  printf("Enter k: ");
  scanf("%d", &k);
  
  combs = get_combs(items, k, num_items);
  print_mat(combs,num_combs(num_items, k) ,k);
  free(items);
  free_mat(combs,num_combs(num_items, k), k);
  
  return 0;
}

