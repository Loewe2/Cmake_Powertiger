message( STATUS "Building CMake version: " ${CMAKE_TARGET_VERSION} )


ExternalProject_Add(
    cmake
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/cmake
        URL https://github.com/Kitware/CMake/releases/download/v${CMAKE_TARGET_VERSION}/cmake-${CMAKE_TARGET_VERSION}.tar.gz
        BUILD_IN_SOURCE 1
        BUILD_ALWAYS OFF
        CONFIGURE_COMMAND ./bootstrap --parallel=${PARALLEL_BUILD} --prefix=${CMAKE_CURRENT_BINARY_DIR}/build/cmake -- -DCMAKE_BUILD_TYPE=Release
)

#set(CMAKE_COMMAND to path)