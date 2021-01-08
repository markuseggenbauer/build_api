include_guard()

include(me_print)

function(me_add_unit target)
  cmake_parse_arguments(
    "PARAMETER" "" "INTERFACE_DIR;SOURCE_DIR"
    "INTERFACES;INTERFACE_DEPENDS;SOURCES;SOURCE_DEPENDS" ${ARGN})

  me_print(STATUS "Unit: ${target}")

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

  set_target_properties(${target} PROPERTY POSITION_INDEPENDENT_CODE ON)

endfunction()

function(me_add_executable target)
  cmake_parse_arguments("PARAMETER" "" "SOURCE_DIR" "SOURCES;DEPENDS" ${ARGN})

  me_print(STATUS "Executable: ${target}")

  if(PARAMETER_SOURCES)
    if(NOT PARAMETER_SOURCE_DIR)
      set(PARAMETER_SOURCE_DIR ".")
    endif()

    list(TRANSFORM PARAMETER_SOURCES PREPEND "${PARAMETER_SOURCE_DIR}/")

    me_print(VERBOSE "  SOURCE_DIR: ${PARAMETER_SOURCE_DIR}")
    me_print_list(LOG_TYPE VERBOSE CAPTION "  SOURCES:" ${PARAMETER_SOURCES})
  else()
    set(PARAMETER_SOURCES ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
  endif()

  me_print_list(LOG_TYPE VERBOSE CAPTION "  DEPENDS:" ${PARAMETER_DEPENDS})

  add_executable(${target} ${PARAMETER_SOURCES})

  if(PARAMETER_SOURCE_DIR)
    target_include_directories(${target} PRIVATE ${PARAMETER_SOURCE_DIR})
  endif()

  if(PARAMETER_DEPENDS)
    target_link_libraries(${target} PRIVATE ${PARAMETER_DEPENDS})
  endif()

endfunction()
