Using non-type template parameters in a `__device__` template-variable causes a parsing error with some functions:
```cpp
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
__device__ constexpr F deviceSymbol = f;

int main() {

    void* kernelFuncPtr;
    cudaMemcpyFromSymbol(&kernelFuncPtr,&deviceSymbol<decltype(&addTest),&addTest>,sizeof(void*));
    printf("this pointer on the device is: %p",kernelFuncPtr);

    //This code does not compile on GCC7/CUDA10, comment it out and it should work
    void* kernelFuncPtr2;
    cudaMemcpyFromSymbol(&kernelFuncPtr2,&deviceSymbol<decltype(&addTest2),&addTest2>,sizeof(void*));
    printf("this pointer will cause a compile-error: %p",kernelFuncPtr2);

    return 0;
}
```

```
In file included from /usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h:220:0:
/tmp/tmpxft_0000359a_00000000-5_main.cudafe1.stub.c: In function ‘void __nv_cudaEntityRegisterCallback(void**)’:
/tmp/tmpxft_0000359a_00000000-5_main.cudafe1.stub.c:1:845: error: parse error in template argument list
 #pragma GCC diagnostic push
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ^                                                        
/tmp/tmpxft_0000359a_00000000-5_main.cudafe1.stub.c:1:845: error: wrong number of template arguments (1, should be 2)
/home/michael/dev/test/main.cu:19:1: note: provided for ‘template<class F, F f> constexpr const F deviceSymbol<F, f>’
 __device__ constexpr F deviceSymbol = f;
 ^~~~~~~~~~~~
CMakeFiles/test.dir/build.make:81: recipe for target 'CMakeFiles/test.dir/main.cu.o' failed
make[3]: *** [CMakeFiles/test.dir/main.cu.o] Error 1
CMakeFiles/Makefile2:94: recipe for target 'CMakeFiles/test.dir/all' failed
make[2]: *** [CMakeFiles/test.dir/all] Error 2
CMakeFiles/Makefile2:101: recipe for target 'CMakeFiles/test.dir/rule' failed
make[1]: *** [CMakeFiles/test.dir/rule] Error 2
Makefile:137: recipe for target 'test' failed
make: *** [test] Error 2

```

 