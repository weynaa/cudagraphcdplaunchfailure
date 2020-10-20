#include <cuda.h>
#include <cuda_runtime.h>
#include <cstdint>
#include <cstdio>
#include <cuda_device_runtime_api.h>
__global__ void childKernel(){
    if(threadIdx.x == 0 && blockIdx.x == 0){
        printf("hello from childKernel\n");
    }
}


__global__ void parentKernel() { 
    childKernel<<<600000, 64>>>();

    auto ret = cudaDeviceSynchronize();
    if(ret != cudaSuccess){
        printf("CudaStreamSynchronize failed with %i",ret);
    }
    printf("done\n");
}


int main() {
  cudaGraph_t graph;
  cudaGraphCreate(&graph,0);
  cudaGraphNode_t node;
  cudaKernelNodeParams params;
  params.func = (void*) parentKernel;
  params.extra = nullptr;
  params.gridDim = dim3(1);
  params.blockDim = dim3(1);
  params.sharedMemBytes = 0;
  params.kernelParams = nullptr;
  cudaGraphAddKernelNode(&node,graph,nullptr,0,&params);

  cudaGraphExec_t instance;
  cudaGraphInstantiate(&instance,graph,nullptr,nullptr,0);
  
  cudaStream_t myStream;
  cudaStreamCreate(&myStream);

  for(int i = 0; i < 100000; ++i){
    cudaGraphLaunch(instance,myStream);
    auto err = cudaStreamSynchronize(myStream);
    if (err != cudaSuccess) {
      printf("CUDA Error %d occured\n", err);
      break;
    }

  }
  cudaGraphExecDestroy(instance);

  cudaGraphDestroy(graph);
  cudaStreamDestroy(myStream);

  return 0;
}
