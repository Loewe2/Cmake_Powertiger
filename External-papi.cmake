message( STATUS "Building PAPI version: " ${PAPI_TARGET_VERSION} )
#TODO: cd
ExternalProject_Add(
    papi
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/papi
        URL http://icl.utk.edu/projects/papi/downloads/papi-${PAPI_TARGET_VERSION}.tar.gz
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3 TODO
        CONFIGURE_COMMAND cd src; configure --prefix=${INSTALL_ROOT}/papi --enable-shared ; cd -
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        BUILD_COMMAND cd src; make -j ${PARALLEL_BUILD}; cd -
        INSTALL_COMMAND cd src; make install; cd -
)