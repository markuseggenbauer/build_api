# Test: executable artifact with source and dependency to interface/source unit
# (with source dependency)
me_add_executable(test_executable_src_depends_unit_2 SOURCES main.cpp DEPENDS
                  test_unit_2)

add_test(test_executable_src_depends_unit_2 test_executable_src_depends_unit_2)
