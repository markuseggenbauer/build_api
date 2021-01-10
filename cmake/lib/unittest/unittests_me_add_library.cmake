include(me_artifact) # include DUT

# setup mocks
macro(me_print)
  me_mock_trace(me_print ${ARGN})
endmacro()

macro(me_print_list)
  me_mock_trace(me_print_list ${ARGN})
endmacro()

macro(add_library)
  me_mock_trace(add_library ${ARGN})
endmacro()

macro(target_link_libraries)
  me_mock_trace(target_link_libraries ${ARGN})
endmacro()

macro(set_target_properties)
  me_mock_trace(set_target_properties ${ARGN})
endmacro()

macro(target_include_directories)
  me_mock_trace(target_include_directories ${ARGN})
endmacro()

include(me_cmake_test) # me_cmake_test_*() functions

me_cmake_test_begin(test_me_add_library)

me_mock_expect(me_print STATUS "Library: TestLibrary")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  CONTAINS:"
  Unit_1
  Unit_2)
me_mock_expect(add_library TestLibrary SHARED ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_link_libraries TestLibrary PUBLIC Unit_1 Unit_2)

me_add_library(TestLibrary CONTAINS Unit_1 Unit_2)

me_cmake_test_end()
