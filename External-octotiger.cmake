set(LDFLAGS "-lz -L${INSTALL_ROOT}/hdf5/lib -lhdf5 -no-pie")

ExternalProject_Add(
    Octotiger
    
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/build/octotiger
    GIT_REPOSITORY https://github.com/STEllAR-GROUP/octotiger.git
    GIT_PROGRESS FALSE
    # CMAKE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/build/cmake/bin/cmake
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/octotiger/build
    CMAKE_ARGS 
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
        -DCMAKE_PREFIX_PATH=<PEFIX> 
        -DHPX_DIR=${CMAKE_CURRENT_BINARY_DIR}/build/hpx/lib/cmake/HPX/  
        -DSilo_INCLUDE_DIR=${CMAKE_CURRENT_BINARY_DIR}/build/silo/include 
        -DSilo_LIBRARY=${CMAKE_CURRENT_BINARY_DIR}/build/silo/lib/libsiloh5.a 
        -DSilo_DIR=${CMAKE_CURRENT_BINARY_DIR}/build/silo 
        -DCMAKE_CXX_FLAGS=-fpermissive -std=c++17 
        -DCMAKE_LINKER_FLAGS= ${LDFLAGS} 
        -DVc_DIR=${INSTALL_ROOT}/Vc/lib/cmake/Vc 
        -DOCTOTIGER_WITH_BLAST_TEST=OFF 
        -DHDF5_INCLUDE_DIR=${INSTALL_ROOT}/hdf5/include 
        -DHDF5_LIBRARY=${INSTALL_ROOT}/hdf5/lib/libhdf5.a
        -DHDF5_ROOT=${INSTALL_ROOT}/hdf5/
        -DCMAKE_CXX_FLAGS=${CXXFLAGS}\ -fpermissive 
        -DCMAKE_EXE_LINKER_FLAGS=${LDCXXFLAGS}\ -lz\ -L${INSTALL_ROOT}/hdf5/lib\ -lhdf5 
        -DOCTOTIGER_WITH_CUDA=${OCT_WITH_CUDA} 
    BUILD_IN_SOURCE 0
    # BUILD_ALWAYS ON
    DEPENDS ${OCTOTIGER_DEPENDENCIES}
)
