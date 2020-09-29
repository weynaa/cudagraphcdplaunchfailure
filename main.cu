#include <iostream>
#include <cstdint>
#include <cuda.h>

//mixed types work
__global__
void addTest( const int* bcdasdk, int* c){

}

//twice the same type in a parameter does not work
__global__
void addTest2( void* a,void*b){

}


template <typename F, F f>
__device__ F deviceSymbol = f;

int main() {

    void* kernelFuncPtr;
    cudaMemcpyFromSymbol(&kernelFuncPtr,&deviceSymbol<decltype(&addTest),&addTest>,sizeof(void*));
    printf("this pointer on the device is: %p",kernelFuncPtr);
    //This code does not compile on GCC7/CUDA10
    void* kernelFuncPtr2;
    cudaMemcpyFromSymbol(&kernelFuncPtr2,&deviceSymbol<decltype(&addTest2),&addTest2>,sizeof(void*));
    printf("this pointer will cause a compile-error: %p",kernelFuncPtr2);

    return 0;
}
