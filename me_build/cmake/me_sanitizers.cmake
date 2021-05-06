include_guard(GLOBAL)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../externals/sanitizers-cmake/cmake")
set(SANITIZE_LINK_STATIC ON)
find_package(Sanitizers)
