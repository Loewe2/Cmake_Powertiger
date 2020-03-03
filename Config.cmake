include(CMakeDependentOption)

###### Configparameter for octotiger #####
set(OCT_BUILD_TYPE "Release")

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING  "Choose the type of build octotiger, options are: None Debug Release RelWithDebInfo." FORCE )
endif()

option(OCT_WITH_CUDA "Build octotiger with CUDA support" ON)

#TODO sinvoll OMPI optionen !!!!!!
option(OCT_WITH_PARCEL "Parcelport" OFF)
option(OCT_WITH_LIBFABRIC "Parcelport with libfabric" OFF)

option(OCT_WITH_PAPI "Build octotiger with PAPI support" OFF)
option(OCT_WITH_APEX "Build octotiger with APEX support" OFF)

# CUDA
set(CUDA_SM "sm_61" CACHE STRING "CUDA SM version")

##### Build options #########
set(INSTALL_ROOT ${CMAKE_CURRENT_BINARY_DIR}/build )


cmake_dependent_option(BUILD_MINIMAL_DEPENDENCIES "Look for preinstalled software build only needed dependencies" ON "NOT BUILD_ALL_DEPENDENCIES;NOT  BUILD_SELECTED_DEPENDENCIES" OFF)
cmake_dependent_option(BUILD_ALL_DEPENDENCIES "Don't look for preinstalled software build all dependencies" ON "NOT BUILD_MINIMAL_DEPENDENCIES;NOT BUILD_SELECTED_DEPENDENCIES" OFF)
cmake_dependent_option(BUILD_SELECTED_DEPENDENCIES "Build only selected dependencies" ON "NOT BUILD_ALL_DEPENDENCIES; NOT BUILD_MINIMAL_DEPENDENCIES" OFF)

set(CMAKE_CXX_STANDARD 17 CACHE STRING "CXX standard")
set(CMAKE_CUDA_STANDARD 17 CACHE STRING "CUDA standard")

set(CMAKE_CXX_FLAGS -fPIC\ -march=native\ -mtune=native\ -ffast-math CACHE  STRING "CXXFLAGS")


###### Dependency versions to build if needed ##### 
set( DEPENDENCY_BUILD_TYPE "Release")

set( OPENMPI_TARGET_VERSION 4.0.0 CACHE STRING  "Target version for OpenMPI")
set( CMAKE_TARGET_VERSION 3.13.2 CACHE STRING "Target version for CMAKE")
set( BOOST_TARGET_VERSION 1.68.0 CACHE STRING "Target version for Boost")
set( HDF5_TARGET_VERSION 1.8.12 CACHE STRING "Target version for HDF5")
set( SILO_TARGET_VERSION 4.10.2 CACHE STRING "Target version for Silo")
set( HWLOC_TARGET_VERSION 1.11.12 CACHE STRING "Target version for hwloc")
set( JEMALLOC_TARGET_VERSION 5.1.0 CACHE STRING "Target version for jemalloc")
set( VC_TARGET_VERSION 1.4.1 CACHE STRING "Target version for Vc")
set( PAPI_TARGET_VERSION 5.7.0 CACHE STRING "Target version for Papi")
set( LIBFABRIC_TARGET_VERSION 1.9.0 CACHE STRING "Target version for libfabric")
set( GCC_TARGET_VERSION 8.3.0 CACHE STRING "Target version for gcc")
set( GCC_CUDA_TARGET_VERSION 7.2.0 CACHE STRING "Target version for gcc for cuda host code")
set( HPX_TARGET_VERSION 1.4.0 CACHE STRING "Target version for HPX")
set( CUDA_TARGET_VERSION 9.2 CACHE STRING "Target version for CUDA")

# if(${BUILD_SELECTED_DEPENDENCIES} MATCHES "ON")
    option(BUILD_OPENMPI "build OpenMPI ${OPENMPI_VERSION}"  OFF)
    option(BUILD_CMAKE "build CMAKE ${CMAKE_VERSION}"  OFF)
    option(BUILD_BOOST "build Boost ${BOOST_VERSION}"  OFF)
    option(BUILD_HDF5 "build HDF5 ${HDF5_VERSION}"  OFF)
    option(BUILD_SILO "build Silo ${SILO_VERSION}"  OFF)
    option(BUILD_HWLOC "build Hwloc ${HWLOC_VERSION}"  OFF)
    option(BUILD_JEMALLOC "build jemalloc ${JEMALLOC_VERSION}"  OFF)
    option(BUILD_VC "build Vc ${VC_VERSION}"  OFF)
    option(BUILD_PAPI "build PAPI ${PAPI_VERSION}"  OFF)
    option(BUILD_LIBFABRIC "build libfabric ${LIBFABRIC_VERSION}"  OFF)
    option(BUILD_GCC "build GCC ${GCC_VERSION}"  OFF)
    option(BUILD_GCC_CUDA "build GCC ${GCC_CUDA_VERSION} for CUDA" OFF)
    option(BUILD_HPX "build HPX ${HPX_VERSION}"  OFF)
    option(BUILD_TCMALLOC "build TCMalloc"  OFF)

# endif()


    




