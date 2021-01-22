include_guard(GLOBAL)

if(build_api_INCLUDE_DIR)
  set(ME_CMAKE_SOURCE_DIR ${build_api_INCLUDE_DIR})
endif()

include(me_structure)
include(me_artifact)
include(me_test)
