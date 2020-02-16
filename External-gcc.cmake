if(${BUILD_GCC} MATCHES "ON")
    message( STATUS "Building GCC version: " ${GCC_TARGET_VERSION} )
    ExternalProject_Add(
        gcc-${GCC_TARGET_VERSION}
            PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/gcc-${GCC_TARGET_VERSION}
            INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/gcc-${GCC_TARGET_VERSION}
            URL ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-${GCC_TARGET_VERSION}/gcc-${GCC_TARGET_VERSION}.tar.xz
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS OFF
            PATCH_COMMAND ./contrib/download_prerequisites
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-languages=c,c++,fortran --disable-multilib --disable-nls
    )
    set(CMAKE_C_COMPILER <INSTALL_DIR>/bin/gcc CACHE PATH "" FORCE)
    set(CMAKE_CXX_COMPILER <INSTALL_DIR>/bin/gcc CACHE PATH "" FORCE)
endif()

#build special gcc version for compatibility with nvcc.
if(${BUILD_GCC_CUDA} MATCHES "ON" )
    message( STATUS "Building GCC version: " ${GCC_CUDA_TARGET_VERSION} "for CUDA")
    ExternalProject_Add(
        gcc-${GCC_CUDA_TARGET_VERSION}
            PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/gcc-${GCC_CUDA_TARGET_VERSION}
            INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/gcc-${GCC_CUDA_TARGET_VERSION}
            URL ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-${GCC_CUDA_TARGET_VERSION}/gcc-${GCC_CUDA_TARGET_VERSION}.tar.xz
            BUILD_IN_SOURCE 0
            BUILD_ALWAYS OFF
            PATCH_COMMAND ./contrib/download_prerequisites
            CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --enable-languages=c,c++,fortran --disable-multilib --disable-nls
    )
    set(CMAKE_CUDA_HOST_COMPILER <INSTALL_DIR>/bin/g++ CACHE PATH "" FORCE )
endif()