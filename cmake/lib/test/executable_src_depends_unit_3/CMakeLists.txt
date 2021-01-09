# Test: executable artifact with source and dependency to interface/source unit
# (with transitive interface dependency)
me_add_executable(test_executable_src_depends_unit_3 SOURCES main.cpp DEPENDS
                  test_unit_3)
