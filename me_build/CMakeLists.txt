cmake_minimum_required(VERSION 3.16)

project(me_build)
include(CTest)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(me_build)

me_define_build_variant(Verification_1 BUILD_PROPERTIES ASan USan)
me_define_build_variant(Verification_2 BUILD_PROPERTIES TSan)

add_subdirectory(test)
