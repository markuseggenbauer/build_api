list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../src)
set(ME_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)

include(me_artifact)

add_subdirectory(unit)
add_subdirectory(component)
add_subdirectory(library)
add_subdirectory(executable)
