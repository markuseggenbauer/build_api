# Test: executable artifact with source and dependency to interface unit
me_add_executable(
  test_executable_src_depends_unit_1
  SOURCE_DIR
  src
  SOURCES
  main.cpp
  DEPENDS
  test_unit_1)
