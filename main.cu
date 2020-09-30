#include <cuda.h>
#include <cuda_runtime.h>
#include <cstdint>
#include <cstdio>
#include <cuda_device_runtime_api.h>
// mixed types work
__global__ void addTest(const int* bcdasdk, int* c) {
  printf("hello from addTest()\n");
}

// twice the same type in a parameter does not work
__global__ void addTest2(void* a, void* b) {
  printf("hello from addTest2()\n");
}

template<typename... Args>
__global__ void execFnPtr(void(*f)(Args...)){
    (*f)<<<1,1>>>(nullptr,nullptr);
}


template <typename F, F f>
__device__ F deviceSymbol = f;

int main() {
  void (*kernelFuncPtr)(const int*, int*);
  auto err = cudaMemcpyFromSymbol(&kernelFuncPtr,
                       deviceSymbol<decltype(&addTest), &addTest>,
                       sizeof(void*));
  printf("this pointer on the device is: %p\n", kernelFuncPtr);
  execFnPtr<<<1, 1>>>(kernelFuncPtr);

  // This code does not compile on GCC7/CUDA10, comment it out and it should work
  void (*kernelFuncPtr2)(void*, void*);
  err = cudaMemcpyFromSymbol(&kernelFuncPtr2,
                       deviceSymbol<decltype(&addTest2), &addTest2>,
                       sizeof(void*));
  printf("this pointer will cause a compile-error: %p\n", kernelFuncPtr2);

  execFnPtr<<<1, 1>>>(kernelFuncPtr2);

  return 0;
}
