include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../externals/sanitizers-cmake/cmake")
find_package(Sanitizers)
