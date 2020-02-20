message( STATUS "Building HDF5 version: " ${HDF5_TARGET_VERSION} )


string( REPLACE "." "_" HDF5_TARGET_VERSION_UNDERSCORE ${HDF5_TARGET_VERSION} )


ExternalProject_Add(
    HDF5
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/hdf5
        GIT_REPOSITORY https://github.com/live-clones/hdf5
        GIT_TAG hdf5-${HDF5_TARGET_VERSION_UNDERSCORE}
        GIT_PROGRESS FALSE
        INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/hdf5
        CMAKE_ARGS  
            -Wno-dev 
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
            -DBUILD_TESTING=OFF 
            -DCMAKE_BUILD_TYPE=Release 
            -DCMAKE_CXX_FLAGS=-fPIC
            -DCMAKE_C_FLAGS=-fPIC
        BUILD_IN_SOURCE 0
        BUILD_ALWAYS OFF
)

set($ENV{HDF5_ROOT} ${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/)
set($ENV{LD_LIBRARY_PATH} ${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/lib:$ENV{LD_LIBRARY_PATH})