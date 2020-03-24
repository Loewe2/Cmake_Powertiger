message( STATUS "Building Boost version: " ${BOOST_TARGET_VERSION} )

string( REPLACE "." "_" Boost_TARGET_Version_Underscore ${BOOST_TARGET_VERSION} )




ExternalProject_Add(
    Boost
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/boost
        URL http://downloads.sourceforge.net/project/boost/boost/${BOOST_TARGET_VERSION}/boost_${Boost_TARGET_Version_Underscore}.tar.bz2
            https://sourceforge.net/projects/boost/files/boost/${BOOST_TARGET_VERSION}/boost_${Boost_TARGET_Version_Underscore}.tar.bz2      
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3
        DOWNLOAD_NO_PROGRESS TRUE
        INSTALL_DIR ${INSTALL_ROOT}/boost
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        EXCLUDE_FROM_ALL ON
        CONFIGURE_COMMAND CXX=${CMAKE_CXX_COMPILER} CC=${CMAKE_CC_COMPILER} ./bootstrap.sh --prefix=<INSTALL_DIR> --with-toolset=gcc
        BUILD_COMMAND ./b2 
            -j${PARALLEL_BUILD} "${flag1}" ${flag2} 
            --with-atomic 
            --with-filesystem 
            --with-program_options 
            --with-regex 
            --with-system 
            --with-chrono 
            --with-date_time 
            --with-thread ${BOOST_BUILD_TYPE} 
        INSTALL_COMMAND ./b2 -j${PARALLEL_BUILD} install
)

set( BOOST_ROOT ${INSTALL_ROOT}/boost CACHE PATH "BOOST_ROOT" FORCE)
