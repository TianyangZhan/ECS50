//
//  This program converts an integer number from one base to another
//

#include <iostream>
#include <string>
#include <cmath> // enable pow()
using namespace std;


// Convert the number to base 10
int convto10(int base1,string numInput){
    
    int size = (int)(numInput.size());
    int result = 0;
    
    for(int i = 0; i < size; ++i){
        // If the digit is 0 - 9, convert the digit to number 0 - 9
        if( numInput[i] >= '0' && numInput[i] <= '9'){
            result += ( numInput[i] - '0') * pow(base1,(size - i - 1));
        }
        // If the digit is A - Z, convert the digit to number 10 - 25
        if( numInput[i] >= 'A' && numInput[i] <= 'Z'){
            result += ( numInput[i] - 'A' + 10) * pow(base1,(size - i - 1));
        }
    }
    return result;
}


// Convert the base 10 number to number in new base
void convtoNB(int numTen, int base2,string* numOutput){
    
    while(numTen != 0){
        int rmd = numTen % base2;
        string str;
        // If the digit is 10 - 25, convert the digit to number A - Z
        if(rmd >= 10){
            char digit = 'A' + (rmd - 10);
            numOutput->insert(0,1,digit);
        }else{
            str = to_string(rmd);
            numOutput->insert(0,str);
        }
        numTen /= base2;
    }
}


int main() {
    
    int base1, base2;
    int numTen;
    string numInput;
    string numOutput;
    
    // Prompt the user for inputs
    cout<<"Please enter the number's base: ";
    cin>>base1;
    cout<<"Please enter the number: ";
    cin>>numInput;
    cout<<"Please enter the new base: ";
    cin>>base2;
    
    numTen = convto10(base1,numInput);
    convtoNB(numTen,base2,&numOutput);
    
    cout<<numInput<<" base "<<base1<<" is "<<numOutput<<" base "<<base2<<endl;
}
