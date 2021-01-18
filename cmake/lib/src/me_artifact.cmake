include_guard()

include(me_print)

define_property(
  TARGET
  PROPERTY ME_LINK_TARGETS
  BRIEF_DOCS "Transitive link targets."
  FULL_DOCS "List of targets a transitive link dependency exists.")

function(me_derive_link_target_property target)
  foreach(dependency IN ITEMS ${ARGN})

    get_target_property(unit_type ${dependency} TYPE)
    if(unit_type STREQUAL OBJECT_LIBRARY)
      get_property(
        tmp_target_link_dependencies
        TARGET ${dependency}
        PROPERTY ME_LINK_TARGETS)
      list(APPEND target_link_dependencies ${tmp_target_link_dependencies})
    endif()
    list(APPEND target_link_dependencies ${dependency})

  endforeach()

  list(REMOVE_DUPLICATES target_link_dependencies)

  if(target_link_dependencies)
    set_property(
      TARGET ${target}
      APPEND
      PROPERTY ME_LINK_TARGETS ${target_link_dependencies})
  endif()
endfunction()

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

  me_derive_link_target_property(${target} ${PARAMETER_INTERFACE_DEPENDS}
                                 ${PARAMETER_SOURCE_DEPENDS})

  set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
  set_target_properties(${target} PROPERTIES CXX_STANDARD 17
                                             CXX_STANDARD_REQUIRED ON)

endfunction()

function(me_add_component target)
  cmake_parse_arguments("PARAMETER" "" "" "CONTAINS;CONTAINS_PRIVATE" ${ARGN})

  me_print(STATUS "Component: ${target}")
  me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS:" ${PARAMETER_CONTAINS})
  me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS_PRIVATE:"
                ${PARAMETER_CONTAINS_PRIVATE})

  add_library(${target} OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)

  if(PARAMETER_CONTAINS)
    target_link_libraries(${target} PUBLIC ${PARAMETER_CONTAINS})
  endif()

  me_derive_link_target_property(${target} ${PARAMETER_CONTAINS}
                                 ${PARAMETER_CONTAINS_PRIVATE})

endfunction()

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

function(me_add_unittest unit_name)
  cmake_parse_arguments("UPARAMETER" "" "SOURCE_DIR"
                        "SOURCES;SOURCE_DEPENDS;CONTAINS" ${ARGN})

  if(UPARAMETER_SOURCE_DIR)
    list(APPEND UPARAMETERS SOURCE_DIR ${UPARAMETER_SOURCE_DIR})
  endif()
  if(UPARAMETER_SOURCES)
    list(APPEND UPARAMETERS SOURCES ${UPARAMETER_SOURCES})
  endif()
  if(UPARAMETER_SOURCE_DEPENDS)
    list(APPEND UPARAMETERS SOURCE_DEPENDS ${UPARAMETER_SOURCE_DEPENDS})
  else()
    list(APPEND UPARAMETERS SOURCE_DEPENDS)
  endif()
  list(APPEND UPARAMETERS ${unit_name})

  me_add_unit(unit_unittest_${unit_name} ${UPARAMETERS})

  cmake_parse_arguments("EPARAMETER" "" "" "CONTAINS" ${ARGN})

  me_add_executable(
    unittest_${unit_name} CONTAINS ${unit_name} unit_unittest_${unit_name}
    ${UPARAMETER_SOURCE_DEPENDS} ${EPARAMETER_CONTAINS})

  add_test(unittest_${unit_name} unittest_${unit_name})
endfunction()
