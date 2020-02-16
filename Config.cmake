include(CMakeDependentOption)

###### Configparameter for octotiger #####
set(OCT_BUILD_TYPE "Release")

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING  "Choose the type of build octotiger, options are: None Debug Release RelWithDebInfo." FORCE )
endif()

option(OCT_WITH_CUDA "Build octotiger with CUDA support" OFF)

#TODO sinvoll OMPI optionen !!!!!!
option(OCT_WITH_PARCEL "Parcelport" OFF)
option(OCT_WITH_LIBFABRIC "Parcelport with libfabric" OFF)

option(OCT_WITH_PAPI "Build octotiger with PAPI support" OFF)
option(OCT_WITH_APEX "Build octotiger with APEX support" OFF)

# CUDA
set(CUDA_SM "sm_61")

##### Build options #########
set(PARALLEL_BUILD 80) # TODO: get num cores
set(INSTALL_ROOT ${CMAKE_CURRENT_BINARY_DIR}/build )


cmake_dependent_option(BUILD_MINIMAL_DEPENDENCIES "Look for preinstalled software build only needed dependencies" ON "NOT BUILD_ALL_DEPENDENCIES;NOT  BUILD_SELECTED_DEPENDENCIES" OFF)
cmake_dependent_option(BUILD_ALL_DEPENDENCIES "Don't look for preinstalled software build all dependencies" ON "NOT BUILD_MINIMAL_DEPENDENCIES;NOT BUILD_SELECTED_DEPENDENCIES" OFF)
cmake_dependent_option(BUILD_SELECTED_DEPENDENCIES "Build only selected dependencies" ON "NOT BUILD_ALL_DEPENDENCIES; NOT BUILD_MINIMAL_DEPENDENCIES" OFF)


###### Dependency versions to build if needed ##### 
set( DEPENDENCY_BUILD_TYPE "Release")

set( OPENMPI_TARGET_VERSION 4.0.0 )
set( CMAKE_TARGET_VERSION 3.13.2 )
set( BOOST_TARGET_VERSION 1.68.0 )
set( HDF5_TARGET_VERSION 1.8.12 )
set( SILO_TARGET_VERSION 4.10.2 )
set( HWLOC_TARGET_VERSION 1.11.12 )
set( JEMALLOC_TARGET_VERSION 5.1.0 )
set( VC_TARGET_VERSION 1.4.1)
set( PAPI_TARGET_VERSION 5.7.0 )
set( LIBFABRIC_TARGET_VERSION 1.9.0 )
set( GCC_TARGET_VERSION 8.3.0 )
set( GCC_CUDA_TARGET_VERSION 7.2.0 )
set( HPX_TARGET_VERSION 1.4.0 )
set( CUDA_TARGET_VERSION 9.2)

# if(${BUILD_SELECTED_DEPENDENCIES} MATCHES "ON")
    option(BUILD_OPENMPI "If BUILD_SELECTED_DEPENDENCIES==ON build OpenMPI ${OPENMPI_VERSION}"  OFF)
    option(BUILD_CMAKE "If BUILD_SELECTED_DEPENDENCIES==ON build CMAKE ${CMAKE_VERSION}"  OFF)
    option(BUILD_BOOST "If BUILD_SELECTED_DEPENDENCIES==ON build Boost ${BOOST_VERSION}"  OFF)
    option(BUILD_HDF5 "If BUILD_SELECTED_DEPENDENCIES==ON build HDF5 ${HDF5_VERSION}"  OFF)
    option(BUILD_SILO "If BUILD_SELECTED_DEPENDENCIES==ON build Silo ${SILO_VERSION}"  OFF)
    option(BUILD_HWLOC "If BUILD_SELECTED_DEPENDENCIES==ON build Hwloc ${HWLOC_VERSION}"  OFF)
    option(BUILD_JEMALLOC "If BUILD_SELECTED_DEPENDENCIES==ON build jemalloc ${JEMALLOC_VERSION}"  OFF)
    option(BUILD_VC "If BUILD_SELECTED_DEPENDENCIES==ON build Vc ${VC_VERSION}"  OFF)
    option(BUILD_PAPI "If BUILD_SELECTED_DEPENDENCIES==ON build PAPI ${PAPI_VERSION}"  OFF)
    option(BUILD_LIBFABRIC "If BUILD_SELECTED_DEPENDENCIES==ON build libfabric ${LIBFABRIC_VERSION}"  OFF)
    option(BUILD_GCC "If BUILD_SELECTED_DEPENDENCIES==ON build GCC ${GCC_VERSION}"  OFF)
    option(BUILD_GCC_CUDA "If BUILD_SELECTED_DEPENDENCIES==ON build GCC ${GCC_CUDA_VERSION} for CUDA" OFF)
    option(BUILD_HPX "If BUILD_SELECTED_DEPENDENCIES==ON build Vc ${VC_VERSION}"  OFF)
    option(BUILD_TCMALLOC "If BUILD_SELECTED_DEPENDENCIES==ON build TCMalloc"  OFF)

# endif()


    




