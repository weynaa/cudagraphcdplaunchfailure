cmake_minimum_required(VERSION 3.17)
project(testProj C CXX CUDA)
find_package(CUDA)

set(CMAKE_CUDA_ARCHITECTURES 52 61 70 75)

set(CMAKE_CXX_STANDARD 17)

add_executable(test main.cu)

set_target_properties(test PROPERTIES CUDA_STANDARD 14)
target_compile_definitions(test PUBLIC WITH_CUDA)
target_link_libraries(test PRIVATE         ${CUDA_LIBRARIES}
        ${CUDA_CUDA_LIBRARY}
        ${CUDA_NVRTC_LIB})

set_target_properties(test PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_target_properties(test PROPERTIES POSITION_INDEPENDENT_CODE ON)
set_target_properties(test PROPERTIES CUDA_RESOLVE_DEVICE_SYMBOLS ON)
