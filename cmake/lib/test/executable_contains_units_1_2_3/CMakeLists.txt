# Test: executable artifact containing a single unit
me_add_unit(
  unit_test_executable_contains_unit_1_2_3
  SOURCES
  main.cpp
  SOURCE_DEPENDS
  test_unit_1
  test_unit_2
  test_unit_3)

me_add_executable(
  test_executable_contains_unit_1_2_3 CONTAINS
  unit_test_executable_contains_unit_1_2_3 test_unit_1 test_unit_2 test_unit_3)
