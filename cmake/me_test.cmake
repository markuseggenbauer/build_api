include_guard(GLOBAL)

include(me_print)
include(me_structure)
include(me_artifact)

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
