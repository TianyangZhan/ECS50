.global _start

.data

string1:
    .space 100
string2:
    .space 100
dist1:
    .space 404
dist2:
    .space 404

.equ ws,4

.text

strlen:
    #prologue
        push %ebp
        movl %esp, %ebp

    .equ str, 2 * ws

    #edx will be str
    #eax will be i
    movl $0, %eax # i = 0
    movl str(%ebp), %edx #edx = str

    for_strlen:
        cmpb $0, (%edx, %eax)
        jz end_for_strlen

        incl %eax
        jmp for_strlen

    end_for_strlen:

    #epilogue
        movl %ebp, %esp
        pop %ebp
        ret


min:
    #prologue
        push %ebp
        movl %esp, %ebp

        push %ecx   #save regs
        push %edx   #save regs

    .equ b,2 * ws
    .equ a,3 * ws

    #ecx will be a
    #edx will be b
    movl a(%ebp), %ecx
    movl b(%ebp), %edx

    cmpl %edx, %ecx
    jge bsmaller

    movl %ecx, %eax
    jmp end_min

    bsmaller:
        movl %edx, %eax

    end_min:

    #epilogue
        pop %edx
        pop %ecx
        movl %ebp, %esp
        pop %ebp
        ret


swap:
    #prologue
        push %ebp
        movl %esp, %ebp
        push %ecx   #save regs

    .equ a, 2 * ws
    .equ b, 3 * ws

    /*
        int* temp = *a;
     *a = *b;
     *b = temp;
        */

    #edx will be temp
    #eax will be b
    #ecx wil be a

    movl a(%ebp), %ecx
    movl (%ecx), %edx #temp = *a

    movl b(%ebp), %eax
    movl (%eax), %eax #eax = *b
    movl %eax, (%ecx) #*a = *b

    movl b(%ebp), %eax
    movl %edx, (%eax) #*b = temp


    #epilogue
        pop %ecx
        movl %ebp, %esp
        pop %ebp
        ret


edit_dist:
    #prologue
        push %ebp
        movl %esp, %ebp
        subl $5 * ws, %esp #subtract space for local vars
        push %ebx   #save regs
        push %esi   #save regs

    .equ curDist, 5 * ws
    .equ oldDist, 4 * ws
    .equ word2, 3 * ws
    .equ word1, 2 * ws
    .equ word1_len, -1 * ws
    .equ word2_len, -2 * ws
    .equ i, -3 * ws
    .equ j, -4 * ws
    .equ dist, -5 * ws

    #word1_len = strlen(word1);
    push word1(%ebp)
    call strlen
    addl $1 * ws, %esp #clear arg
    movl %eax, word1_len(%ebp)

    #word2_len = strlen(word2);
    push word2(%ebp)
    call strlen
    addl $1 * ws, %esp #clear arg
    movl %eax, word2_len(%ebp)

    #ecx will be i
    movl $0, %ecx #i = 0
    movl oldDist(%ebp), %eax
    movl curDist(%ebp), %edx
    movl word2_len(%ebp), %ebx
    incl %ebx #ebx = word2_len + 1

    first_for_loop:
        #for(i = 0; i < word2_len + 1; i++){
        cmpl %ebx, %ecx
        jge end_first_for_loop

        movl %ecx, (%eax, %ecx, ws) #oldDist[i] = i;
        movl %ecx, (%edx, %ecx, ws) #curDist[i] = i;
        incl %ecx
        jmp first_for_loop

    end_first_for_loop:

    #ecx will be i
    movl $1, %ecx #i = 1
    start_i_loop:
        #for(i = 1; i < word1_len + 1; i++)
        movl word1_len(%ebp), %ebx
        incl %ebx   #ebx = word1_len + 1

        cmpl %ebx, %ecx
        jge end_i_loop

        movl %ecx, (%edx) #curDist[0] = i;

        #esi will be j
        movl $1, %esi #j = 1
        start_j_loop:
            #for(j = 1; j < word2_len + 1; j++)
            movl word2_len(%ebp), %ebx
            incl %ebx   #ebx = word2_len + 1
            cmpl %ebx, %esi
            jge end_j_loop

            # if(word1[i-1] == word2[j-1])
            movl word1(%ebp), %eax
            movl word2(%ebp), %edx
            movb -1(%eax, %ecx), %al
            movb -1(%edx, %esi), %dl
            cmpb %al, %dl
            jnz else_start

            movl oldDist(%ebp), %eax
            movl curDist(%ebp), %edx
            #curDist[j] = oldDist[j - 1];
            movl -1*ws(%eax,%esi,ws), %eax
            movl %eax, (%edx,%esi,ws)
            jmp continue_j_loop

            else_start:
            /*
                curDist[j] = min(min(oldDist[j], 
                curDist[j-1]),
                oldDist[j-1]) + 1;
            */
                movl oldDist(%ebp), %eax
                movl curDist(%ebp), %edx
                push -1*ws(%edx, %esi, ws)
                push (%eax,%esi,ws)
                call min    #min(oldDist[j],curDist[j-1])
                addl $2 * ws, %esp #clear arg

                movl oldDist(%ebp), %edx
                push -1*ws(%edx,%esi,ws)
                push %eax
                call min    #min(min(oldDist[j],curDist[j-1]), oldDist[j-1])
                addl $2 * ws, %esp #clear arg

                incl %eax   #min(min(oldDist[j],curDist[j-1]), oldDist[j-1]) + 1

                movl curDist(%ebp), %edx
                movl %eax, (%edx,%esi,ws)   #curDist[j] = min(...) + 1

        continue_j_loop:
            incl %esi # j++
            jmp start_j_loop

        end_j_loop:
            #swap(&oldDist, &curDist);
            leal oldDist(%ebp), %eax     #eax = &oldDist
            leal curDist(%ebp), %edx     #edx = &curDist
            push %edx
            push %eax
            call swap
            addl $2 * ws, %esp #clear arg

            incl %ecx   #i++
            movl oldDist(%ebp), %eax
            movl curDist(%ebp), %edx
            jmp start_i_loop

    end_i_loop:
        #dist = oldDist[word2_len];
        movl oldDist(%ebp), %eax
        movl word2_len(%ebp), %ebx
        movl (%eax,%ebx,ws), %eax
    #epilogue
        pop %esi
        pop %ebx
        movl %ebp, %esp
        pop %ebp
        ret

_start:

    push $dist2
    push $dist1
    push $string2
    push $string1
    call edit_dist
    addl $4 * ws, %esp #clear arg

done:
    movl %eax, %eax
