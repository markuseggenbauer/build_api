include_guard()

include(me_print)
include(me_internal)

function(me_add_executable target)
  cmake_parse_arguments("PARAMETER" "" "" "CONTAINS" ${ARGN})

  me_print(STATUS "Executable: ${target}")
  me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS:" ${PARAMETER_CONTAINS})

  add_executable(${target} ${ME_CMAKE_SOURCE_DIR}/empty.cpp)

  me_derive_link_target_property(${target} ${PARAMETER_CONTAINS})

  get_property(
    target_link_dependencies
    TARGET ${target}
    PROPERTY ME_LINK_TARGETS)

  target_link_libraries(${target} PRIVATE ${target_link_dependencies})

endfunction()

function(me_add_library target)
  cmake_parse_arguments("PARAMETER" "" "" "CONTAINS" ${ARGN})

  me_print(STATUS "Library: ${target}")
  me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS:" ${PARAMETER_CONTAINS})

  add_library(${target} SHARED ${ME_CMAKE_SOURCE_DIR}/empty.cpp)

  me_derive_link_target_property(${target} ${PARAMETER_CONTAINS})

  get_property(
    target_link_dependencies
    TARGET ${target}
    PROPERTY ME_LINK_TARGETS)

  target_link_libraries(${target} PRIVATE ${target_link_dependencies})

endfunction()
