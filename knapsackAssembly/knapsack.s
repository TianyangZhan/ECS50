
.global knapsack

.equ ws, 4

.text


max:
#prologue:
    push %ebp
    movl %esp, %ebp

    .equ a, 2 * ws
    .equ b, 3 * ws

    movl a(%ebp), %eax #eax will be a
    movl b(%ebp), %ecx #ecx will be b

    cmpl %ecx, %eax
    jge a_bigger

    b_bigger:
        movl %ecx, %eax
        jmp end_max

    a_bigger:
        movl a(%ebp), %eax

    end_max:
        #epilogue
        movl %ebp, %esp
        pop %ebp
        ret


knapsack:
    prologue:
        push %ebp
        movl %esp, %ebp
        subl $ 2 * ws, %esp # make space for local variables
        #save regs
        push %ebx
        push %edi
        push %esi

        .equ weights, 2 * ws
        .equ values, 3 * ws
        .equ num_items, 4* ws
        .equ capacity, 5 * ws
        .equ cur_value, 6 * ws
        #local vars
        .equ i, -1 * ws
        .equ best_value, -2 * ws

        # unsigned int best_value = cur_value;
        movl cur_value(%ebp), %eax
        movl %eax, best_value(%ebp)

        movl $0, %edi #edi will be i
        loop_start: # for(i = 0; i < num_items; i++)
            cmpl num_items(%ebp), %edi
            jge loop_end

            if_start: # if(capacity - weights[i] >= 0 )
                movl capacity(%ebp), %ecx #ecx will be capacity
                movl weights(%ebp), %edx #edx will be weight
                cmpl (%edx,%edi,ws), %ecx
                jl if_end
/*
    best_value = max(best_value,
                    knapsack(weights + i + 1, values + i + 1, 
                            num_items - i - 1, capacity - weights[i],
                            cur_value + values[i]));
 */
                movl values(%ebp), %ebx #ebx will be values
                movl cur_value(%ebp), %esi #esi will be cur_value
                subl (%edx,%edi,ws), %ecx #ecx = capacity - weights[i]
                addl (%ebx,%edi,ws), %esi #esi = cur_value + values[i]

                leal 1*ws(%edx,%edi,ws), %edx #edx = weights + i + 1
                leal 1*ws(%ebx,%edi,ws), %ebx #ebx = values + i + i
                movl num_items(%ebp), %eax #eax will be num_items
                subl %edi, %eax
                subl $1, %eax #eax = num_items - i - 1

                movl %edi, i(%ebp) #save i

                push %esi
                push %ecx
                push %eax
                push %ebx
                push %edx
                call knapsack  #eax will be the return value
                addl $1 * ws, %esp #remove args

                push %eax
                push best_value(%ebp)
                call max #eax will be the return value
                addl $1 * ws, %esp #remove args

                movl %eax, best_value(%ebp)

                movl i(%ebp), %edi # restore i

            if_end:
                incl %edi
                jmp loop_start

        loop_end:
            movl best_value(%ebp), %eax

        epilogue:
            pop %esi
            pop %edi
            pop %ebx
            movl %ebp, %esp
            pop %ebp
            ret
