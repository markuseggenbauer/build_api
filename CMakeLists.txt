cmake_minimum_required(VERSION 3.16)

project(build_api)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(me_build_api)

include(CTest)
add_subdirectory(unittest)
add_subdirectory(test)
