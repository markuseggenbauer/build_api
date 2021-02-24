include_guard(GLOBAL)

include(me_print)
include(me_structure)
include(me_artifact)

function(me_add_packagetest package_name)
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
  list(APPEND UPARAMETERS ${package_name})

  me_add_package(package_packagetest_${package_name} ${UPARAMETERS})

  cmake_parse_arguments("EPARAMETER" "" "" "CONTAINS" ${ARGN})

  me_add_executable(
    packagetest_${package_name} CONTAINS ${package_name}
    package_packagetest_${package_name} ${UPARAMETER_SOURCE_DEPENDS}
    ${EPARAMETER_CONTAINS})

  add_test(packagetest_${package_name} packagetest_${package_name})
endfunction()
