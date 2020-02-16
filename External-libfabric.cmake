message( STATUS "Building libfabric version: " ${LIBFABRIC_TARGET_VERSION} )

ExternalProject_Add(
    libfabric
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/libfabric
        URL https://github.com/ofiwg/libfabric/archive/v${LIBFABRIC_TARGET_VERSION}.tar.gz
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3 TODO
        PATCH_COMMAND ./autogen.sh
        CONFIGURE_COMMAND ./configure 
            --disable-verbs 
            --disable-sockets 
            --disable-usnic 
            --disable-udp 
            --disable-rxm 
            --disable-rxd 
            --disable-shm 
            --disable-mrail 
            --disable-tcp 
            --enable-gni 
            --prefix=${INSTALL_ROOT}/libfabric 
            --no-recursion
        BUILD_IN_SOURCE 0
        BUILD_ALWAYS OFF
        BUILD_COMMAND make -j ${PARALLEL_BUILD}
        INSTALL_COMMAND make install
)

