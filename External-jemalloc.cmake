message( STATUS "Building jemalloc version: " ${JEMALLOC_TARGET_VERSION} )


ExternalProject_Add(
    jemalloc
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/jemalloc
        URL https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_TARGET_VERSION}/jemalloc-${JEMALLOC_TARGET_VERSION}.tar.bz2
        DOWNLOAD_NO_PROGRESS TRUE
        PATCH_COMMAND ./autogen.sh
        CONFIGURE_COMMAND ./configure --prefix=${INSTALL_ROOT}/jemalloc
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        EXCLUDE_FROM_ALL ON
)