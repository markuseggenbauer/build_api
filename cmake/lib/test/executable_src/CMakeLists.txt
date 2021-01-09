# Test: executable artifact with source
me_add_executable(test_executable_src SOURCE_DIR src SOURCES main.cpp)
add_test(test_executable_src test_executable_src)
