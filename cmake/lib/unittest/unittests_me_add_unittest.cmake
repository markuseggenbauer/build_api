include(me_mock)

macro(define_property)
  me_mock_trace(define_property ${ARGV})
endmacro()

include(me_artifact) # include DUT

me_mock_reset()

# setup mocks
macro(me_add_unit)
  me_mock_trace(me_add_unit ${ARGV})
endmacro()

macro(me_add_executable)
  me_mock_trace(me_add_executable ${ARGV})
endmacro()

macro(add_test)
  me_mock_trace(add_test ${ARGV})
endmacro()

macro(define_property)
  me_mock_trace(define_property ${ARGV})
endmacro()

include(me_cmake_test)

me_cmake_test_begin(test_me_add_unittest)

me_mock_expect(
  me_add_unit
  unit_unittest_name
  SOURCE_DIR
  ssubdir
  SOURCES
  Source1.cpp
  Source2.cpp
  SOURCE_DEPENDS
  Unit_1
  Unit_2
  name)

me_mock_expect(
  me_add_executable
  unittest_name
  CONTAINS
  name
  unit_unittest_name
  Unit_1
  Unit_2
  Main)

me_mock_expect(add_test unittest_name unittest_name)

me_add_unittest(
  name
  SOURCE_DIR
  ssubdir
  SOURCES
  Source1.cpp
  Source2.cpp
  SOURCE_DEPENDS
  Unit_1
  Unit_2
  CONTAINS
  Main)

me_cmake_test_end()
