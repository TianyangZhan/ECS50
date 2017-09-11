
.global _start

.data

# Make lables num1 and num2
num1:
    .long 123
    .long 456

num2:
    .long 234
    .long 567

.text

_start:

    # EDX will be upper 32 bits
    # EAX will be lower 32 bits

    movl num1, %edx
    movl num1 + 4, %eax

    addl num2 + 4, %eax   # Add lower 32 bits of num1 and num2
    jnc samebits    # if there is no carry bit, just add the upper 32 bits

    incl %edx   # if there is a carry bit, add 1 to the upper 32 bits
    addl num2, %edx
    jmp done

samebits:
    addl num2, %edx

done:
    movl %eax, %eax
