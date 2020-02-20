cmake_minimum_required(VERSION 3.9)

project(cmake-octotiger-supberbuild)

include(Config.cmake)

set(OCTOTIGER_DEPENDENCIES)
set(HPX_DEPENDENSIES)  
set(SILO_DEPENDENSIES) 

######## select all dependencies to build ###########
if(${BUILD_ALL_DEPENDENCIES} MATCHES "ON")
  set(BUILD_CMAKE ON)
  set(BUILD_GCC ON)
  set(BUILD_OPENMPI ON)
  set(BUILD_HDF5 ON)
  set(BUILD_SILO ON)
  set(BUILD_HWLOC ON)
  set(BUILD_JEMALLOC ON)
  set(BUILD_TCMALLOC ON)
  set(BUILD_VC ON)
  set(BUILD_PAPI ON)
  set(BUILD_LIBFABRIC ON)
  set(BUILD_HPX ON)

########## decide what to build if minimal build #######
elseif(${BUILD_MINIMAL_DEPENDENCIES} MATCHES "ON")
  #gcc
  if(CMAKE_COMPILER_IS_GNUCC AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL ${GCC_TARGET_VERSION})
    message(STATUS "Using system GCC ${CMAKE_CXX_COMPILER_VERSION}")
  else()
    set(BUILD_GCC ON)
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
      set(CMAKE_CUDA_HOST_COMPILER  ${CMAKE_CXX_COMPILER} CACHE PATH "" FORCE )
    else()
      set(BUILD_GCC_CUDA ON)
    endif()
  endif()

  #cmake
  if(CMAKE_VERSION VERSION_LESS_EQUAL CMAKE_TARGET_VERSION)
    set(BUILD_CMAKE ON)
  endif()

  #OpenMPI
  if(OCT_WITH_PARCEL MATCHES "ON") # TODO:
    find_package(MPI ${OPENMPI_TARGET_VERSION})
    if(${MPI_FOUND})
      message(STATUS "Using system MPI ${MPI_VERSION}")
    else()
      set(BUILD_OPENMPI ON)
      endif()
  endif()

  # boost
  find_package(Boost ${BOOST_TARGET_VERSION} COMPONENTS system)
  if(${Boost_FOUND})
    message(STATUS "Using sysem Boost ${Boost_VERSION}")
    set(BOOST_ROOT ${Boost_ROOT})
    if(DEFINED Boost_DIR)
      get_filename_component(
      BOOST_ROOT "${Boost_DIR}/../../../" ABSOLUTE
      )
   endif()
   endif()

  # HDF5 #TODO: HDF5 got found but missing lib dir
  # set(HDF5_USE_STATIC_LIBRARIES ON)
  # find_package(HDF5 ${HDF5_TARGET_VERSION})
  # if(${HDF5_FOUND})
  #   message(STATUS "Using sysem HDF5 ${HDF5_VERSION}")
  # else()
    set(BUILD_HDF5 ON)
  # endif()

  # HPX
  # find_package(HPX ${HPX_TARGET_VERSION})
  # if(${HPX_FOUND})
  #   message(STATUS "Using sysem HPX ${HDF5_VERSION}")
  # else()
    set(BUILD_HPX ON)
  # endif()


  #TODO determine build for REST
  set(BUILD_SILO ON)
  set(BUILD_HWLOC ON)
  set(BUILD_JEMALLOC ON)
  # set(BUILD_TCMALLOC ON)
  set(BUILD_HPX ON)
  set(BUILD_VC ON)


  if(OCT_WITH_PAPI MATCHES "ON")
    set(BUILD_PAPI ON)
  endif()
  if(OCT_WITH_LIBFABRIC MATCHES "ON")
    set(BUILD_LIBFABRIC ON)
  endif()
elseif( NOT ${BUILD_SELECTED_DEPENDENCIES} MATCHES "ON")
  message(FATAL_ERROR "One build option must be set")
endif()



set(CXXFLAGS "-fPIC -march=native -mtune=native -ffast-math -std=c++17")
set(LIBHPX lib64)

########### build dependencies ##################
include(ExternalProject)
# if( ${BUILD_CMAKE} MATCHES "ON" )
  # include( External-cmake.cmake )
  # list(APPEND HPX_DEPENDENSIES cmake)
# endif()

# if( ${BUILD_GCC} MATCHES "ON" OR ${BUILD_GCC_CUDA} MATCHES "ON")
  # include( External-gcc.cmake )
  # if(${BUILD_GCC} MATCHES "ON")
    # list(APPEND HPX_DEPENDENSIES gcc-${GCC_VERSION})
  # endif()
  # list(APPEND OCTOTIGER_DEPENDENCIES gcc-${GCC_VERSION})
# endif()

# if( ${BUILD_OPENMPI} MATCHES "ON" )
  # include( External-OpenMPI.cmake )
# endif()



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

if( ${BUILD_HWLOC} MATCHES "ON" )
  include( External-hwloc.cmake )
  list(APPEND HPX_DEPENDENSIES hwloc)
endif()

if( ${BUILD_JEMALLOC} MATCHES "ON" )
  include( External-jemalloc.cmake )
  list(APPEND HPX_DEPENDENSIES jemalloc)
endif()

# # if( ${BUILD_TCMALLOC} MATCHES "ON" )
  # include( External-tcmalloc.cmake )
# #   list(APPEND HPX_DEPENDENSIES tcmalloc)
# # endif()

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
