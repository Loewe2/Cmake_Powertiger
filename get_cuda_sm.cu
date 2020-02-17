#include <cstdio>
#include <cstdlib>
#include <cuda_runtime_api.h>

int main(int argc, char *argv[])
{
    cudaDeviceProp prop;
    cudaError_t status;
    int device_count;
    int min_v = 0;

    status = cudaGetDeviceCount(&device_count);
    if (status != cudaSuccess) {
        fprintf(stderr,"cudaGetDeviceCount() failed: %s\n", cudaGetErrorString(status));
        return -1;
    }
    for(int device_index=0; device_index < device_count; ++device_index){
        status = cudaGetDeviceProperties(&prop, device_index);
        if (status != cudaSuccess) {
            fprintf(stderr,"cudaGetDeviceProperties() for device %i failed: %s\n", device_index, cudaGetErrorString(status));
            return -1;
        }
        int v = prop.major * 10 + prop.minor;
        if(min_v < v) min_v = v;
    }

   
    return min_v;
}