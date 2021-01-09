list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../src)
set(ME_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)

include(me_artifact)

add_subdirectory(unit_1)
add_subdirectory(unit_2)
add_subdirectory(unit_3)
add_subdirectory(unit_main)
add_subdirectory(executable_src)
add_subdirectory(executable_src_depends_unit_1)
add_subdirectory(executable_src_depends_unit_2)
add_subdirectory(executable_src_depends_unit_3)
add_subdirectory(executable_depends_unit_main)
