//
// This program reads in a floating point number and outputs its scientific base 2 format.
//

#include <iostream>
#include <string>
using namespace std;

// check the 32th bit to figure out the sign of the number
char convertSign(int num){
    char sign = '+';
    if(num & (1<<31))
        sign = '-';
    return sign;
}

// check the 24~31th bits to calculate the exponent
int exponent(int num){
    int exp = ((num>>23) & 0xFF);
    // convert to the real exponent
    exp -= 127;
    return exp;
}

// check the 1~23th bits to calculate the exponent
void mantissa(int num, string& mts){
    int i = 0;
    // get rid of 0's at the end
    while( !( num & (1<<i) ) ){
        ++i;
    }
    // get the mantissa
    for(; i < 23; ++i){
        if(num & (1<<i)){
            mts = "1" + mts;
        }else{
             mts = "0" + mts;
        }
    }
}

// prompt for input, convert the number, and print out the result
void convertFloat(){
    float userNum;
    int exp;
    string mts;
    char sign;
    
    cout<<"Please enter a float: "<<endl;
    cin>>userNum;
    
    // if the number is 0, print out the result and end the program
    if(userNum == 0){
        cout<<"0E0"<<endl;
        return;
    }
    
    unsigned int float_int = *((unsigned int*)&userNum);
    sign = convertSign(float_int);
    exp = exponent(float_int);
    mantissa(float_int, mts);
    
    // if the number is negative, print out the negative sign;
    // don't print out the sign when it's positive.
    if(sign == '-')
        cout<<sign;
    cout<<"1."<<mts<<"E"<<exp<<endl;
}

int main() {
    convertFloat();
    return 0;
}
