# Test: executable artifact containing a single unit
me_add_unit(unit_test_executable_contains_component_1 SOURCES main.cpp
            SOURCE_DEPENDS test_component_1)

me_add_executable(test_executable_contains_component_1 CONTAINS
                  unit_test_executable_contains_unit_1_2_3 test_component_1)
