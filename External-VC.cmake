message( STATUS "Building Vc version: " ${VC_TARGET_VERSION} )

ExternalProject_Add(
    VC
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/Vc
        GIT_REPOSITORY https://github.com/VcDevel/Vc.git
        GIT_TAG ${VC_TARGET_VERSION}
        INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/build/Vc 
        CMAKE_ARGS 
            -Wno-dev 
            -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
            -DCMAKE_BUILD_TYPE=Release 
            -DBUILD_TESTING=OFF 
        BUILD_IN_SOURCE 0
        BUILD_ALWAYS OFF
)