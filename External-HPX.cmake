message( STATUS "Building HPX version: " ${HPX_TARGET_VERSION} )



ExternalProject_Add(
    HPX
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/hpx
        GIT_REPOSITORY https://github.com/STEllAR-GROUP/hpx.git
        GIT_TAG ${HPX_TARGET_VERSION}
        GIT_PROGRESS FALSE
        INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/hpx
        CMAKE_ARGS  
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} 
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
            -DCMAKE_BUILD_TYPE=${BUILD_TYPE} 
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
            -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
            -DCMAKE_EXE_LINKER_FLAGS=${LDCXXFLAGS} 
            -DCMAKE_SHARED_LINKER_FLAGS=${LDCXXFLAGS} 
            -DHPX_WITH_CUDA=${OCT_WITH_CUDA} 
            -DHPX_WITH_CXX14=ON 
            -DHPX_WITH_PAPI=${OCT_WITH_PAPI} 
            -DPAPI_ROOT=${INSTALL_ROOT}/papi/ 
            -DCMAKE_EXPORT_COMPILE_COMMANDS=ON 
            -DHPX_WITH_THREAD_IDLE_RATES=ON 
            -DHPX_WITH_DISABLED_SIGNAL_EXCEPTION_HANDLERS=ON 
            -DHWLOC_ROOT=${INSTALL_ROOT}/hwloc/ 
            -DHPX_WITH_MALLOC=JEMALLOC 
            -DJEMALLOC_ROOT=${INSTALL_ROOT}/jemalloc/  
            -DLIBFABRIC_ROOT=${INSTALL_ROOT}/libfabric 
            -DBoost_NO_SYSTEM_PATHS=ON
            -DBOOST_ROOT=${BOOST_ROOT}
            -DBoost_INCLUDE_DIR=${Boost_INCLUDE_DIRS}
            -DHPX_WITH_CUDA_ARCH=${CUDA_SM} 
            -DHPX_WITH_NETWORKING=ON 
            -DHPX_WITH_MORE_THAN_64_THREADS=ON 
            -DHPX_WITH_MAX_CPU_COUNT=256 
            -DHPX_WITH_EXAMPLES=OFF 
            -DHPX_WITH_TESTS=ON 
            -DHPX_WITH_PARCELPORT_MPI=${OCT_WITH_PARCEL} 
            -DHPX_WITH_PARCELPORT_LIBFABRIC=${OCT_WITH_LIBFABRIC} 
            -DHPX_PARCELPORT_LIBFABRIC_PROVIDER=gni 
            -DHPX_PARCELPORT_LIBFABRIC_64K_PAGES:STRING=20 
            -DHPX_PARCELPORT_LIBFABRIC_DEBUG_LOCKS:BOOL=OFF 
            -DHPX_PARCELPORT_LIBFABRIC_ENDPOINT:STRING=rdm 
            -DHPX_PARCELPORT_LIBFABRIC_MAX_PREPOSTS:STRING=512 
            -DHPX_PARCELPORT_LIBFABRIC_MAX_SENDS:STRING=128 
            -DHPX_PARCELPORT_LIBFABRIC_MEMORY_CHUNK_SIZE:STRING=4096 
            -DHPX_PARCELPORT_LIBFABRIC_MEMORY_COPY_THRESHOLD:STRING=4096 
            -DHPX_PARCELPORT_LIBFABRIC_WITH_BOOTSTRAPPING:BOOL=TRUE 
            -DHPX_PARCELPORT_LIBFABRIC_WITH_DEV_MODE:BOOL=OFF 
            -DHPX_PARCELPORT_LIBFABRIC_WITH_LOGGING:BOOL=OFF 
            -DHPX_PARCELPORT_LIBFABRIC_WITH_PERFORMANCE_COUNTERS:BOOL=OFF 
            -DHPX_WITH_APEX=${OCT_WITH_APEX} -DAPEX_WITH_ACTIVEHARMONY=FALSE 
            -DAPEX_WITH_OTF2=FALSE 
            -DAPEX_WITH_BFD=FALSE 
            -DHPX_WITH_APEX_NO_UPDATE=FALSE 
            -DHPX_WITH_APEX_TAG=develop 
            -DCMAKE_CXX_FLAGS=-fPIC\ -march=native\ -mtune=native\ -ffast-math\ -std=c++17
        BUILD_IN_SOURCE 0
        BUILD_ALWAYS OFF
        DEPENDS ${HPX_DEPENDENSIES}
)

