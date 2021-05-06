include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.18)

set(
    ME_CMAKE_SOURCE_DIR
    "${CMAKE_CURRENT_LIST_DIR}"
    CACHE PATH "ME CMAKE me_build base folder." FORCE
)

include(me_build_variants)
include(me_structure)
include(me_artifact)
include(me_test)
