# Test: interface/source unit with interface dependency
me_add_unit(
  test_unit_3
  INTERFACES
  unit_3.hpp
  INTERFACE_DEPENDS
  test_unit_1
  SOURCES
  unit_3.cpp)
