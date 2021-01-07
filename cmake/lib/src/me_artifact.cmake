include_guard()

include(me_print)

function(me_add_executable_artifact target)
  cmake_parse_arguments("PARAMETER" "" "" "SOURCES;DEPENDS" ${ARGN})

  me_print(STATUS "Executable: ${target}")
  me_print_list(LOG_TYPE VERBOSE CAPTION "Sources:" ${PARAMETER_SOURCES})
  me_print_list(LOG_TYPE VERBOSE CAPTION "Depends on:" ${PARAMETER_DEPENDS})

  add_executable(${target} ${PARAMETER_SOURCES})
  target_link_libraries(${target} PRIVATE ${PARAMETER_DEPENDS})

endfunction()
