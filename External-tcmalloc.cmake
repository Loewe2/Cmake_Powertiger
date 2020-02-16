message( STATUS "Building TCMalloc"  )

#TODO: does not compile without code modification (currently not usable)
message(FATAL_ERROR "TCMalloc does currently NOT compile without code modifications!")
#TODO: version
ExternalProject_Add(tcmalloc
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/external/tcmalloc
    # Some users can't access domain googlecode.com, so we replace it with a link to our project server
    # URL http://gperftools.googlecode.com/files/gperftools-2.0.tar.gz
    URL http://ipads.se.sjtu.edu.cn/projects/powerlyra/deps/gperftools-2.0.tar.gz
    INSTALL_DIR ${INSTALL_ROOT}/tcmalloc
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --enable-frame-pointers --prefix=<INSTALL_DIR> ${tcmalloc_shared}
)

#link_libraries(tcmalloc)
# set(TCMALLOC-FOUND 1)
# add_definitions(-DHAS_TCMALLOC)