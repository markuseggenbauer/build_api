include(me_artifact) # include DUT

include(me_cmake_test) # me_cmake_test_*() functions
include(unittests_mock_setup.cmake) # setup mocks

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
