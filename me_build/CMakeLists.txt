cmake_minimum_required(VERSION 3.16)

project(me_build)
include(CTest)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(me_build)

add_subdirectory(test)
