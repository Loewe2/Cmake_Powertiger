message( STATUS "Building Boost version: " ${BOOST_TARGET_VERSION} )

string( REPLACE "." "_" Boost_TARGET_Version_Underscore ${BOOST_TARGET_VERSION} )




ExternalProject_Add(
    Boost
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/boost
        URL http://downloads.sourceforge.net/project/boost/boost/${BOOST_TARGET_VERSION}/boost_${Boost_TARGET_Version_Underscore}.tar.bz2
        # URL_MD5 f4096c4583947b0eb103c8539f1623a3
        INSTALL_DIR ${INSTALL_ROOT}/boost
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ./bootstrap.sh --prefix=<INSTALL_DIR> --with-toolset=gcc
        BUILD_COMMAND ./b2 -j${PARALLEL_BUILD} "${flag1}" ${flag2} --with-atomic --with-filesystem --with-program_options --with-regex --with-system --with-chrono --with-date_time --with-thread ${BOOST_BUILD_TYPE} 
        INSTALL_COMMAND ./b2 -j${PARALLEL_BUILD} install
)

set_property( TARGET Boost PROPERTY FOLDER "Externals")

ExternalProject_Get_Property( Boost source_dir )
ExternalProject_Get_Property( Boost binary_dir )
set( BOOST_ROOT ${source_dir})
set( Boost_INCLUDE_DIR ${BOOST_ROOT}/include )
set( Boost_INCLUDE_DIR ${BOOST_ROOT}/lib )

SET(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} ${source_dir})
SET(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${BOOST_ROOT}/lib )