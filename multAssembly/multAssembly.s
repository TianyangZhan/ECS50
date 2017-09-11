
.global _start

.data
a:
    .long 1

b:
    .long 2

i:
    .long 0

.text
_start:
    movl b, %edi    # edi will be b
    movl $0, %edx   # edx will be upper 32 bits
    movl $0, %eax   # eax will be lower 32 bits

    mult_for_start:
        movl a, %ebx    # ebx will be a
        movl i, %ecx     # ecx will be i

        cmpl $32, i     # for(i = 0; i < 32; ++i)
        jge mult_for_end

        movl %edi, %esi    # esi will be a copy of b
        and $1, %esi    # esi = esi & 1
        jz add_zero     # if(b & 1)

        movl a, %esi    # esi will be a copy of a
        shll %cl, %esi   # esi = a << i
        addl %esi, %eax
        jc inc_upper    # check if there is a carry bit

    mult_for_middle:
        movl $32, %ecx
        subl i, %ecx     # cl will be 32 - i
        cmpl $32, %ecx
        jge add_zero    # if there is no carry bit, ignore the upper 32 bits

        shrl %cl, %ebx   # ebx = a >> (32 - i)
        addl %ebx, %edx

    add_zero:
        incl i          #i++
        shrl $1, %edi     # b = b >> i
        jmp mult_for_start  #back to the biginning of the for loop

    inc_upper:
        addl $1, %edx
        jmp mult_for_middle #back to the middle of the for loop
    mult_for_end:

done:
    movl %eax, %eax
