cmake_minimum_required(VERSION 3.16)

project(build_api)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(ME_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(CTest)

add_subdirectory(unittest)
add_subdirectory(test)
