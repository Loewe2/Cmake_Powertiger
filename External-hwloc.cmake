message( STATUS "Building Hwloc version: " ${HWLOC_TARGET_VERSION} )

string(REPLACE "." ";" HWLOC_TARGET_VERSION_LIST ${HWLOC_TARGET_VERSION})
list(SUBLIST HWLOC_TARGET_VERSION_LIST 0 2 HWLOC_TARGET_VERSION_LIST)
list(JOIN HWLOC_TARGET_VERSION_LIST "." HWLOC_TARGET_VERSION_SHORT)


ExternalProject_Add(
    hwloc
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/hwloc
        URL https://download.open-mpi.org/release/hwloc/v${HWLOC_TARGET_VERSION_SHORT}/hwloc-${HWLOC_TARGET_VERSION}.tar.gz
        DOWNLOAD_NO_PROGRESS TRUE
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3 TODO
        CONFIGURE_COMMAND ./configure --prefix=${INSTALL_ROOT}/hwloc --disable-opencl
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
)