message( STATUS "Building Silo version: " ${SILO_TARGET_VERSION} )



ExternalProject_Add(
    Silo
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/silo
        URL http://phys.lsu.edu/~dmarcel/silo-${SILO_TARGET_VERSION}.tar.gz
        DOWNLOAD_NO_PROGRESS TRUE
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3 TODO
        PATCH_COMMAND autoreconf -ifv
        CONFIGURE_COMMAND  sh ./configure CC=${CMAKE_C_COMPILER}
            --prefix=${CMAKE_CURRENT_BINARY_DIR}/build/silo 
            --with-hdf5=${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/include,${CMAKE_CURRENT_BINARY_DIR}/build/hdf5/lib 
            --enable-optimization
            -C
            -q
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        EXCLUDE_FROM_ALL ON
        # UPDATE "" #TODO: better solution
        DEPENDS ${SILO_DEPENDENCIES}
)