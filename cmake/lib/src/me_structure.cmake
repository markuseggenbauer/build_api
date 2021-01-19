include_guard()

include(me_print)
include(me_internal)

function(me_add_unit_internal target)
  cmake_parse_arguments(
    "PARAMETER" "" "INTERFACE_DIR;SOURCE_DIR;TYPE"
    "INTERFACES;INTERFACE_DEPENDS;SOURCES;SOURCE_DEPENDS" ${ARGN})

  if(PARAMETER_INTERFACES OR PARAMETER_INTERFACE_DEPENDS)

    if(NOT PARAMETER_INTERFACE_DIR AND PARAMETER_INTERFACES)
      set(PARAMETER_INTERFACE_DIR ".")
    endif()

    list(TRANSFORM PARAMETER_INTERFACES PREPEND "${PARAMETER_INTERFACE_DIR}/")

    me_print(VERBOSE "  INTERFACE_DIR: ${PARAMETER_INTERFACE_DIR}")
    me_print_list(LOG_TYPE VERBOSE CAPTION "  INTERFACES:"
                  ${PARAMETER_INTERFACES})
    me_print_list(LOG_TYPE VERBOSE CAPTION "  INTERFACE_DEPENDS:"
                  ${PARAMETER_INTERFACE_DEPENDS})

  endif()

  if(PARAMETER_SOURCES)
    if(NOT PARAMETER_SOURCE_DIR)
      set(PARAMETER_SOURCE_DIR ".")
    endif()

    list(TRANSFORM PARAMETER_SOURCES PREPEND "${PARAMETER_SOURCE_DIR}/")

    me_print(VERBOSE "  SOURCE_DIR: ${PARAMETER_SOURCE_DIR}")
    me_print_list(LOG_TYPE VERBOSE CAPTION "  SOURCES:" ${PARAMETER_SOURCES})
    me_print_list(LOG_TYPE VERBOSE CAPTION "  SOURCE_DEPENDS:"
                  ${PARAMETER_SOURCE_DEPENDS})
  else()
    set(PARAMETER_SOURCES ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
  endif()

  add_library(${target} OBJECT ${PARAMETER_SOURCES})

  if(PARAMETER_INTERFACE_DIR)
    target_include_directories(${target} PUBLIC ${PARAMETER_INTERFACE_DIR})
  endif()

  if(PARAMETER_SOURCE_DIR)
    target_include_directories(${target} PRIVATE ${PARAMETER_SOURCE_DIR})
  endif()

  if(PARAMETER_INTERFACE_DEPENDS)
    target_link_libraries(${target} PUBLIC ${PARAMETER_INTERFACE_DEPENDS})
  endif()

  if(PARAMETER_SOURCE_DEPENDS)
    target_link_libraries(${target} PRIVATE ${PARAMETER_SOURCE_DEPENDS})
  endif()

  me_derive_link_target_property(${target} ${PARAMETER_INTERFACE_DEPENDS}
                                 ${PARAMETER_SOURCE_DEPENDS})

  set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
  set_target_properties(${target} PROPERTIES CXX_STANDARD 17
                                             CXX_STANDARD_REQUIRED ON)

endfunction()

function(me_add_unit target)
  me_print(STATUS "Unit: ${target}")
  me_add_unit_internal(${ARGV})
endfunction()

function(me_add_unit_interface target)
  me_print(STATUS "Interface-Unit: ${target}")
  me_add_unit_internal(${ARGV})
  # TODO: add consistency check (WARNING) - must not depend (*_DEPENDS) on
  # implementation units
endfunction()

function(me_add_unit_implementation target)
  cmake_parse_arguments(
    "PARAMETER" "" "INTERFACE_DIR;SOURCE_DIR;TYPE"
    "INTERFACES;INTERFACE_DEPENDS;SOURCES;SOURCE_DEPENDS" ${ARGN})
  me_print(STATUS "Implementation-Unit: ${target}")

  if(PARAMETER_INTERFACES
     OR PARAMETER_INTERFACE_DIR
     OR PARAMETER_INTERFACES)
    me_print(FATAL_ERROR
             "No interfaces must be defined for an implementation unit.")
  endif()

  me_add_unit_internal(${ARGV})
endfunction()

function(me_add_component target)
  cmake_parse_arguments("PARAMETER" "" "" "IMPLEMENTS;CONTAINS" ${ARGN})

  me_print(STATUS "Component: ${target}")
  me_print_list(LOG_TYPE VERBOSE CAPTION "  IMPLEMENTS:"
                ${PARAMETER_IMPLEMENTS})
  me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS:" ${PARAMETER_CONTAINS})

  add_library(${target} OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)

  if(PARAMETER_CONTAINS)
    target_link_libraries(${target} PUBLIC ${PARAMETER_IMPLEMENTS})
  endif()

  me_derive_link_target_property(${target} ${PARAMETER_IMPLEMENTS}
                                 ${PARAMETER_CONTAINS})

endfunction()
