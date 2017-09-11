//
// This program creates an alternative representation for letters of the alphabet
//

#include <iostream>
#include <cstdlib> // enable atoi()
using namespace std;

// determine the index of the letter on the alphabet.
int index(int num){
    int count = 0;
    // keep left shifting the bit until it is a 1.
    while( !(num & (1<<count)) ){
        count++;
    }
    return count;
}

// check the 27th bit to decide whether the letter is capitalized.
bool isUpperCase(int num){
    bool upper = false;
    // check if the 27th bit is 1.
    if((num & (1<<26)))
       upper = true;
    return upper;
}

// convert integers to letters and print out them.
void conversion(int argc,const char * argv[]){
    int shift;
    int num;
    char letter;
    
    cout<<"You entered the word: ";
    for(int i = 1; i < argc; ++i){
        num = atoi(argv[i]);
        shift = index(num);
       
        if(isUpperCase(num)){
            letter = 'A' + shift;
            cout<<letter;
        }else{
            letter = 'a' + shift;
            cout<<letter;
        }
    }
    cout<<endl;
}
       

int main(int argc,const char * argv[]) {
    conversion(argc,argv);
    return 0;
}
