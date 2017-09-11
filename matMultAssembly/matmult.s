/*
 
 int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b){
 
    int sum = 0;
    int **temp = (int**) malloc(num_rows_a * sizeof(int*));
    for (int i = 0; i < num_rows_a; i++) {
        temp[i] = (int*) malloc(num_cols_b * sizeof(int));
        for (int j = 0; j < num_cols_b; j++) {
            for (int k = 0; k < num_rows_b; k++) {
                sum += a[i][k]*b[k][j];
            }
            temp[i][j] = sum;
            sum = 0;
        }
    }
    return temp;
 }


*/
.global matMult
.equ ws, 4
.text

matMult:
    prologue:
        push %ebp
        movl %esp, %ebp
        subl $5*ws, %esp #make space for locals
        #save regs
        push %ebx
        push %edi
        push %esi

        .equ a, 2 * ws
        .equ nra, 3 * ws
        .equ nca, 4 * ws
        .equ b, 5 * ws
        .equ nrb, 6 * ws
        .equ ncb, 7 * ws
        .equ i, -1 * ws
        .equ j, -2 * ws
        .equ k, -3 * ws
        .equ sum, -4 * ws
        .equ temp, -5 * ws


        movl $0, sum(%ebp) #int sum = 0;

        # int** temp = (int**) malloc(num_rows_a * sizeof(int*));
        movl nra(%ebp), %eax # eax = num_rows_a
        shll $2, %eax #eax = num_rows_a *sizeof(int*)
        push %eax #put malloc's argument on the stack
        call malloc
        addl $1 * ws, %esp #remove args
        movl %eax, temp(%ebp)

        movl $0, %ebx #ebx will be i
        outer_for: # for (int i = 0; i < num_rows_a; i++) {

            cmpl nra(%ebp), %ebx
            jge outer_for_end
            #temp[i] = (int*)malloc(num_cols_b * sizeof(int));
            movl ncb(%ebp), %eax
            shll $2, %eax
            push %eax
            call malloc
            addl $1 * ws, %esp #clear args
            movl temp(%ebp), %esi #esi = temp
            movl %eax, (%esi,%ebx,ws)

            movl $0, %ecx #ecx will be j
        middle_for: # for (int j = 0; j < num_cols_b; j++) {

            cmpl ncb(%ebp), %ecx
            jge middle_for_end

            movl $0, %edx #edx will be k
        inner_for: # for (int k = 0; k < num_rows_b; k++)

            cmpl nrb(%ebp), %edx
            jge inner_for_end

            # sum += a[i][k]*b[k][j];
            movl a(%ebp), %eax
            movl (%eax,%ebx,ws), %eax
            movl (%eax,%edx,ws), %eax

            movl b(%ebp), %edi
            movl (%edi,%edx,ws), %edi
            imul (%edi,%ecx,ws), %eax # eax = a[i][k]*b[k][j]
            addl %eax, sum(%ebp)

            incl %edx
            jmp inner_for

        inner_for_end:
            # temp[i][j] = sum;
            movl sum(%ebp), %eax
	    movl temp(%ebp), %esi #esi = temp
            movl (%esi,%ebx,ws), %esi
            movl %eax, (%esi,%ecx,ws)
            # sum = 0;
            movl $0, sum(%ebp)
            incl %ecx # j++
            jmp middle_for

        middle_for_end:
            incl %ebx # i++
            jmp outer_for

        outer_for_end:
            movl temp(%ebp), %eax

    eiplogue:
        pop %esi
        pop %edi
        pop %ebx
        movl %ebp, %esp
        pop %ebp
        ret


















