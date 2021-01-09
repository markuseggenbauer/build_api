# Test: interface/source unit with source dependency
me_add_unit(
  test_unit_2
  INTERFACES
  unit_2.hpp
  SOURCES
  unit_2.cpp
  SOURCE_DEPENDS
  test_unit_1)
