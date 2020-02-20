message( STATUS "Building Silo version: " ${SILO_TARGET_VERSION} )



ExternalProject_Add(
    Silo
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/silo
        URL http://phys.lsu.edu/~dmarcel/silo-${SILO_TARGET_VERSION}.tar.gz
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3 TODO
        # TODO: sed raus!! (saubere Lib Pfade) sed -i "'s/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g'" configure &&
        PATCH_COMMAND  autoreconf -ifv && ${PROJECT_SOURCE_DIR}/sed.sh
        CONFIGURE_COMMAND  ./configure 
            --prefix=${CMAKE_CURRENT_BINARY_DIR}/build/silo 
            --with-hdf5=${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/include,${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/lib 
            --enable-optimization
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        # UPDATE "" #TODO: better solution
        DEPENDS ${SILO_DEPENDENCIES}
)

set($ENV{LD_LIBRARY_PATH} /import/sgs.local/scratch/vancraar/octo/cmake_test/supberbuild/build/build/silo/lib/:$ENV{LD_LIBRARY_PATH})