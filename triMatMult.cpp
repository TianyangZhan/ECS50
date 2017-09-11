//
// This program multiply the two matrices and display the resulting compressed matrix
//

#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

// open the file and get the data in the file
void readFile(const char* fileName[],int fileNum,int& dimension,vector<int>& matrix){
    int read;
    ifstream myFile;
    
    // open the file
    myFile.open(fileName[fileNum]);
    // read data from the file
    myFile >> read;
    dimension = read;
    while(myFile >> read)
    {
        matrix.push_back(read);
    }
    //close the file
    myFile.close();
}


// recursively multiply the matrix
void recurMult(int index,int maxIndex,int n,vector<int>& matrix1,vector<int>& matrix2,vector<int>& result){
    // base case
    if(n < 1){
        return;
    }else{
        // recursive case
        int element = 0;
        for(; index < maxIndex; ++index){
            for(int j = 0;j <= index - (maxIndex - n); ++j){
                // do index calculation and multiply the matrixs' elements
                element += matrix1[j + maxIndex - n] * matrix2[index + (j * n) - ((1 + j) * j / 2)];
            }
            result[index] = element;
            element = 0;
        }
        // start recursion
        recurMult(index,maxIndex+(n-1),n-1,matrix1,matrix2,result);
    }
}


// multiply the two matrix
void multMat(int n,vector<int>& matrix1,vector<int>& matrix2,vector<int>& result){
    int index = 0;
    int maxIndex = n;
    result = matrix1;
    recurMult(index,maxIndex,n,matrix1,matrix2,result);
}


int main(int argc, const char * argv[]) {
    int dimension1 = 0;
    int dimension2 = 0;
    int i = 0;
    vector<int> matrix1;
    vector<int> matrix2;
    vector<int> result;
    
    readFile(argv,1,dimension1,matrix1);
    readFile(argv,2,dimension2,matrix2);
    
    multMat(dimension1,matrix1,matrix2,result);
    
    // display the result
    for(i = 0; i < (int)result.size() - 1;++i){
        cout<<result[i]<<" ";
    }
    cout<<result[i]<<endl;
}
