//
//  This program implements multiplication on two unsigned integers withou using "*" operator.
//

#include <stdio.h>
#include <stdlib.h>

void multiplication(unsigned int multiplicand,unsigned int multiplier){
    unsigned long long result = 0;
    
    // store the multiplicant in 64 bit number for left shift
    unsigned long long temp = multiplicand;
    
    printf("%u * %u = ",multiplicand,multiplier);
    
    // loop through the bits of multiplier
    while(multiplier != 0){
        // if the bit is a 1, add a mutiple of the multiplicand to the result
        if(multiplier & 1)
            result += temp;
        multiplier = (multiplier >> 1);
        temp = (temp << 1);
    }
    
    printf("%llu\n",result);
}


int main(int argc, const char * argv[]) {
    unsigned int multiplicand,multiplier;
    sscanf(argv[1], "%u", &multiplicand);
    sscanf(argv[2], "%u", &multiplier);
    
    multiplication(multiplicand, multiplier);
    
    return 0;
}
