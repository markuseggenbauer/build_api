include(me_artifact) # include DUT

include(me_cmake_test) # me_cmake_test_*() functions
include(unittests_mock_setup.cmake) # setup mocks

me_cmake_test_begin(test_me_add_executable)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  CONTAINS:"
  Unit_1
  Unit_2)
me_mock_expect(add_executable TestExecutable ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_link_libraries TestExecutable PRIVATE Unit_1 Unit_2)

me_add_executable(TestExecutable CONTAINS Unit_1 Unit_2)

me_cmake_test_end()
