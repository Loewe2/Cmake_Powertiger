cmake_minimum_required(VERSION 3.9)

project(cmake-octotiger-supberbuild)

include(Config.cmake)

set(OCTOTIGER_DEPENDENCIES)
set(HPX_DEPENDENSIES)  
set(SILO_DEPENDENSIES) 

include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
  set(PARALLEL_BUILD ${N})
else()
  set(PARALLEL_BUILD 1)
  message(WARNING "Couldn't determine num cores set PARALLEL_BUILD manual for parallel making")
endif()

######## select all dependencies to build ###########
if(${BUILD_ALL_DEPENDENCIES} MATCHES "ON")
  set(BUILD_CMAKE ON CACHE BOOL "build CMAKE ${CMAKE_VERSION}"  FORCE )
  set(BUILD_GCC ON CACHE BOOL "build GCC ${GCC_VERSION}" FORCE)
  set(BUILD_OPENMPI ON CACHE BOOL "build OpenMPI ${OPENMPI_VERSION}" FORCE)
  set(BUILD_HDF5 ON CACHE BOOL "build HDF5 ${HDF5_VERSION}" FORCE)
  set(BUILD_SILO ON CACHE BOOL "build Silo ${SILO_VERSION}" FORCE)
  set(BUILD_HWLOC ON CACHE BOOL "build Hwloc ${HWLOC_VERSION}" FORCE)
  set(BUILD_JEMALLOC ON CACHE BOOL "build jemalloc ${JEMALLOC_VERSION}" FORCE)
  set(BUILD_VC ON CACHE BOOL "build Vc ${VC_VERSION}" FORCE)
  set(BUILD_PAPI ON CACHE BOOL "build PAPI ${PAPI_VERSION}" FORCE)
  set(BUILD_LIBFABRIC ON CACHE BOOL "build libfabric ${LIBFABRIC_VERSION} " FORCE)
  set(BUILD_HPX ON CACHE BOOL "build HPX ${HPX_VERSION}" FORCE)
  set(BUILD_BOOST ON CACHE BOOL "build Boost ${BOOST_VERSION}" FORCE)

########## decide what to build if minimal build #######
elseif(${BUILD_MINIMAL_DEPENDENCIES} MATCHES "ON")
  #gcc
  if(CMAKE_COMPILER_IS_GNUCC AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${GCC_TARGET_VERSION})
    message(STATUS "Using system GCC ${CMAKE_CXX_COMPILER_VERSION}")
  else()
    set(BUILD_GCC ON CACHE BOOL "build GCC ${GCC_VERSION}" FORCE)
  endif()

  if(${OCT_WITH_CUDA} MATCHES ON)
    #cuda
    find_package(CUDA ${CUDA_TARGET_VERSION} REQUIRED)
    message(STATUS "Found CUDA ${CUDA_VERSION_STRING} at ${CUDA_TOOLKIT_ROOT_DIR}")

    #
    if(${DETERMINE_CUDA_SM} MATCHES "ON")
      execute_process(COMMAND nvcc --run /import/sgs.scratch/vancraar/octo/cmake_test/superbuild/get_cuda_sm.cu RESULT_VARIABLE sm)
      execute_process(COMMAND rm -f a.out)
      set(CUDA_SM "sm_${sm}")
    endif()

    #check max supportted gcc version from CUDA #TODO nicer
    if(${CUDA_VERSION} VERSION_LESS 5)
      set(CUDA_MAX_GCC 4.5)
    elseif(${CUDA_VERSION} VERSION_LESS 6)
      set(CUDA_MAX_GCC 4.6)
    elseif(${CUDA_VERSION} VERSION_LESS 7)
      set(CUDA_MAX_GCC 4.7)
    elseif(${CUDA_VERSION} VERSION_LESS 8)
      set(CUDA_MAX_GCC 4.9)
    elseif(${CUDA_VERSION} VERSION_LESS 9)
      set(CUDA_MAX_GCC 5.3)
    elseif(${CUDA_VERSION} VERSION_LESS 9.2)
      set(CUDA_MAX_GCC 6.999)  #TODO better max
    elseif(${CUDA_VERSION} VERSION_LESS 10)
      set(CUDA_MAX_GCC 7.999) #TODO better max
    else()
      set(CUDA_MAX_GCC 8.999)  #TODO better max
    endif()

    if(${CUDA_MAX_GCC} VERSION_LESS ${GCC_CUDA_TARGET_VERSION})
      message(FATAL_ERROR "CUDA ${CUDA_VERSION} does not support desired gcc ${GCC_CUDA_TARGET_VERSION}")
    endif()
    
    #gcc for cuda # TODO check first if CMAKE_CUDA_HOST_COMPILER is given
    if(CMAKE_COMPILER_IS_GNUCC AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${GCC_CUDA_TARGET_VERSION} AND  CMAKE_CXX_COMPILER_VERSION VERSION_LESS_EQUAL ${CUDA_MAX_GCC} )
      message(STATUS "CUDA: Using system GCC ${CMAKE_CXX_COMPILER_VERSION}")
      set(CMAKE_CUDA_HOST_COMPILER  ${CMAKE_CXX_COMPILER} CACHE FILEPATH "cuda host compiler" FORCE )
    else()
      set(BUILD_GCC_CUDA ON CACHE BOOL "build gcc for CUDA" FORCE)
    endif()
  endif()

  #cmake
  if(CMAKE_VERSION VERSION_LESS_EQUAL CMAKE_TARGET_VERSION)
    set(BUILD_CMAKE ON CACHE BOOL "build CMAKE ${CMAKE_VERSION}" FORCE)
  endif()

  #OpenMPI
  if(OCT_WITH_PARCEL MATCHES "ON") # TODO:
    find_package(MPI ${OPENMPI_TARGET_VERSION})
    if(${MPI_FOUND})
      message(STATUS "Using system MPI ${MPI_VERSION}")
    else()
      set(BUILD_OPENMPI ON CACHE BOOL "build OpenMPI ${OPENMPI_VERSION}" FORCE)
      endif()
  endif()

  # boost
  if(${BUILD_BOOST} MATCHES "OFF")
    find_package(Boost ${BOOST_TARGET_VERSION} COMPONENTS system context thread chrono)
      if(${Boost_FOUND})
        if(${Boost_VERSION_STRING} VERSION_GREATER_EQUAL 1.63 AND ${Boost_VERSION_STRING} VERSION_LESS_EQUAL 1.69)

        message(STATUS "Using sysem Boost ${Boost_VERSION_STRING}")
        get_filename_component(
          BOOST_ROOT "${Boost_INCLUDE_DIRS}/../" ABSOLUTE CACHE PATH "BOOST_ROOT"
          )
      else()
        message(WARNING "Boost ${Boost_VERSION} not supportet building own Boost!")
        set(BUILD_BOOST ON CACHE BOOL "build Boost ${BOOST_VERSION}" FORCE)
      endif()
    else()
      set(BUILD_BOOST ON CACHE BOOL "build Boost ${BOOST_VERSION}" FORCE)
    endif()
   endif()

  # HDF5 #TODO: HDF5 got found but missing lib dir
  set(HDF5_USE_STATIC_LIBRARIES ON)
  find_package(HDF5 ${HDF5_TARGET_VERSION})
  if(${HDF5_FOUND})
    message(STATUS "Using sysem HDF5 ${HDF5_VERSION}")
  else()
    set(BUILD_HDF5 ON CACHE BOOL "build HDF5 ${HDF5_VERSION}" FORCE)
  endif()

  # HPX
  find_package(HPX ${HPX_TARGET_VERSION})
  if(${HPX_FOUND})
    if(${HPX_VERSION} VERSION_GREATER_EQUAL 1.4.0)
      message(STATUS "Using sysem HPX ${HPX_VERSION}")
    else()
      message(WARNING "HPX ${HPX_VERSION} not supportet building own HPX!")
      set(BUILD_HPX ON CACHE BOOL "build HPX ${HPX_TARGET_VERSION}" FORCE)
    endif()
  else()
    set(BUILD_HPX ON CACHE BOOL "build HPX ${HPX_TARGET_VERSION}" FORCE) 
  endif()


  # Vc
  find_package(Vc ${VC_TARGET_VERSION})
  if(NOT ${Vc_FOUND})
    set(BUILD_VC ON CACHE BOOL "build Vc ${VC_TARGET_VERSION}" FORCE)
  endif()


  #SILO
  find_package(SILO ${SILO_TARGET_VERSION})
  if(NOT ${SILO_FOUND})
    set(BUILD_SILO ON CACHE BOOL "build Silo ${SILO_VERSION}" FORCE)
  endif()
  

  #TODO determine build for REST
  if(OCT_WITH_PAPI MATCHES "ON")
    set(BUILD_PAPI ON CACHE BOOL "build PAPI ${PAPI_VERSION}" FORCE)
  endif()
  if(OCT_WITH_LIBFABRIC MATCHES "ON")
    set(BUILD_LIBFABRIC ON CACHE BOOL "build libfabric ${LIBFABRIC_VERSION}" FORCE)
  endif()
elseif( NOT ${BUILD_SELECTED_DEPENDENCIES} MATCHES "ON")
  message(FATAL_ERROR "One build option must be set")
endif()


set(LIBHPX lib64 CACHE STRING "LIBHPX")

########### build dependencies ##################
include(ExternalProject)
# if( ${BUILD_CMAKE} MATCHES "ON" )
  # include( External-cmake.cmake )
  # list(APPEND HPX_DEPENDENSIES cmake)
# endif()

if( ${BUILD_GCC} MATCHES "ON" OR ${BUILD_GCC_CUDA} MATCHES "ON")
  include( External-gcc.cmake )
  if(${BUILD_GCC} MATCHES "ON")
    list(APPEND HPX_DEPENDENSIES gcc-${GCC_TARGET_VERSION})
    list(APPEND OCTOTIGER_DEPENDENCIES gcc-${GCC_TARGET_VERSION})
  endif()
  if(${BUILD_GCC_CUDA} MATCHES "ON")
    list(APPEND HPX_DEPENDENSIES gcc-${GCC_CUDA_TARGET_VERSION})
    list(APPEND OCTOTIGER_DEPENDENCIES gcc-${GCC_CUDA_TARGET_VERSION})
  endif()
endif()

if( ${BUILD_OPENMPI} MATCHES "ON" )
  include( External-OpenMPI.cmake )
endif()


if( ${BUILD_BOOST} MATCHES "ON" )
  include( External-Boost.cmake )
  list(APPEND OCTOTIGER_DEPENDENCIES Boost)
  list(APPEND HPX_DEPENDENSIES Boost)
endif()

if( ${BUILD_HDF5} MATCHES "ON" )
  include( External-hdf5.cmake )
  list(APPEND OCTOTIGER_DEPENDENCIES HDF5)
  list(APPEND SILO_DEPENDENCIES HDF5)
endif()

if( ${BUILD_SILO} MATCHES "ON" )
  include( External-Silo.cmake )
  list(APPEND OCTOTIGER_DEPENDENCIES Silo)
endif()

if( ${BUILD_VC} MATCHES "ON" )
  include( External-VC.cmake )
  list(APPEND OCTOTIGER_DEPENDENCIES VC)
endif()

if( ${BUILD_PAPI} MATCHES "ON" )
  include( External-papi.cmake )
endif()

if( ${BUILD_LIBFABRIC} MATCHES "ON" )
  include( External-libfabric.cmake )
endif()

if( ${BUILD_HPX} MATCHES "ON" )
  include( External-HPX.cmake )
  list(APPEND OCTOTIGER_DEPENDENCIES HPX)
endif()


######### build octotiger ########

include( External-octotiger.cmake )
