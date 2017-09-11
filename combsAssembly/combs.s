/*
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
*/

.global get_combs

.equ ws, 4

#int** get_combs(int* items, int k, int len)

    #items: the item array
    #k: the number of elements per selection in each recursion
    #len: the number of elements in the item array

get_combs:
#prologue
    push %ebp
    movl %esp, %ebp
    subl $5 * ws, %esp #make space for local variables

    .equ items, 2 * ws
    .equ k,3 * ws
    .equ len, 4 * ws

    #local variables
    .equ cmbs, -1 * ws # the total number of possible combinations
    .equ temp, -2 * ws # the selected elements (current combination) in each recursion
    .equ mat, -3 * ws  # the result array
    .equ row, -4 * ws  # the total number of possible combinations
    .equ i, -5 * ws    # the iterator

    #int row = 0;
    movl $0, row(%ebp)

    #cmbs = num_combs(len, k);
    push k(%ebp)
    push len(%ebp)
    call num_combs
    addl $(2*ws), %esp #clear args
    movl %eax, cmbs(%ebp)

    shll $2, %eax #eax = cmbs * sizeof(int*)
    push %eax
    call malloc
    addl $(1*ws), %esp  #clear args
    movl %eax, mat(%ebp) #int** mat = (int**)malloc(cmbs * sizeof(int*));

    movl k(%ebp), %edx
    shll $2, %edx #edx = k * sizeof(int)
    push %edx
    call malloc # return value will be in eax
    addl $(1*ws), %esp  #clear args
    movl %eax, temp(%ebp) #int* temp = (int*)malloc(k *sizeof(int));

    movl $0, %ecx #ecx will be i
    mat_loop: #for(i = 0; i < cmbs; ++i)
        cmpl cmbs(%ebp), %ecx
        jge end_mat_loop

        movl %ecx, i(%ebp) #save ecx
        movl k(%ebp), %eax
        shll $2, %eax #eax = k * sizeof(int)
        push %eax
        call malloc #return value will be in eax
        addl $(1*ws), %esp  #clear args

        movl i(%ebp), %ecx #restore ecx

        movl mat(%ebp), %edx #edx = mat
        movl %eax, (%edx, %ecx, ws) #mat[i] = (int*)malloc(k * sizeof(int));

        incl %ecx #++i
        jmp mat_loop

    end_mat_loop:

        push mat(%ebp)
        push items(%ebp)
        push temp(%ebp)
        leal row(%ebp), %eax #eax = &row
        push %eax
        push len(%ebp)
        push k(%ebp)
        push k(%ebp)
        call rec_combos  #rec_combos(k,k,len,&row,temp,items,mat);
        addl $7 * ws, %esp #clear args

        movl mat(%ebp), %eax
    #epilogue
        movl %ebp, %esp
        pop %ebp
        ret





#void rec_combos(int k, int num_cols,int len, int* row,int* temp,int* items,int** mat)

    #k: the number of elements per selection in each recursion
    #num_cols: the total number of elements per complete combination
    #len: the current number of elements in the item array
    #row: the total number of possible combinations
    #temp: the selected elements (current combination) in each recursion
    #items: the current item array
    #mat: the result array

rec_combos:
    prologue:
        push %ebp
        movl %esp, %ebp
        subl $1 * ws, %esp #make space for local variables
        push %ebx
        push %edi

        .equ k, 2 * ws
        .equ num_cols, 3 * ws
        .equ len, 4 * ws
        .equ row, 5 * ws
        .equ temp, 6 * ws
        .equ items, 7 * ws
        .equ mat, 8 * ws

        #locals variable
        .equ i, -1 * ws


        if: #if(k == 0)    Base Case
            cmpl $0, k(%ebp)
            jnz else  #_if
            movl $0, %ecx #ecx will be i
            copy_for_start:
                cmpl num_cols(%ebp), %ecx
                jge copy_for_end

                movl row(%ebp), %ebx
                movl (%ebx), %ebx #ebx will be (*row)

                movl mat(%ebp), %edx #edx will be mat
                movl (%edx,%ebx,ws), %edx #edx = mat[*row]
                movl temp(%ebp), %edi #edi = temp
                movl (%edi,%ecx,ws), %edi #edi = temp[i]
                movl %edi, (%edx,%ecx,ws) #mat[*row][i] = temp[i];

                incl %ecx
                jmp copy_for_start

            copy_for_end:
                movl row(%ebp), %eax #eax = row
                incl (%eax) #(*row)++;
                jmp end_rec_combos

        else: # Recursive Case
            movl $0, %ecx #ecx will be i
            rec_for_start: #for(i = 0; i < len; i++)
                cmpl len(%ebp), %ecx
                jge rec_for_end

                movl items(%ebp), %eax #eax = items
                movl (%eax, %ecx, ws), %eax #eax = items[i]
                movl num_cols(%ebp), %edx
                subl k(%ebp), %edx  #edx = num_cols - k
                movl temp(%ebp), %ebx #ebx = temp
                movl %eax, (%ebx, %edx, ws) #temp[num_cols - k] = items[i];

                #rec_combos(k - 1, num_cols, len - i - 1,row,temp,items + i + 1,mat);
                push mat(%ebp)
                movl items(%ebp), %ebx
                leal ws(%ebx, %ecx, ws), %ebx #ebx = items + i + 1
                push %ebx
                push temp(%ebp)
                push row(%ebp)

                movl len(%ebp), %eax
                subl %ecx, %eax
                subl $1, %eax #eax = len - i - 1
                push %eax

                push num_cols(%ebp)

                movl k(%ebp), %edi
                subl $1, %edi #edi = k - 1
                push %edi

                movl %ecx, i(%ebp) #save i
                call rec_combos
                addl $(7 * ws), %esp #clear args

                movl i(%ebp), %ecx #restore %ecx
                incl %ecx #++i

                jmp rec_for_start

            rec_for_end:

        end_rec_combos:

    epiologue:
        pop %edi
        pop %ebx
        movl %ebp, %esp
        pop %ebp
        ret

    
