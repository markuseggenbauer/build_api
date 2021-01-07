# include DUT
include(me_artifact)

# prepare mocks
include(me_cmake_test)

macro(me_print)
  me_mock_trace(me_print ${ARGN})
endmacro()

macro(me_print_list)
  me_mock_trace(me_print_list ${ARGN})
endmacro()

macro(add_executable)
  me_mock_trace(add_executable ${ARGN})
endmacro()

macro(target_link_libraries)
  me_mock_trace(target_link_libraries ${ARGN})
endmacro()

me_cmake_test_begin(test_me_add_executable_artifact_1)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "Sources:"
  Testfile1.cpp
  Testfile2.cpp)
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "Depends on:"
  ComponentA
  ComponentB)
me_mock_expect(add_executable TestExecutable Testfile1.cpp Testfile2.cpp)
me_mock_expect(target_link_libraries TestExecutable PRIVATE ComponentA
               ComponentB)

me_add_executable_artifact(
  TestExecutable
  SOURCES
  Testfile1.cpp
  Testfile2.cpp
  DEPENDS
  ComponentA
  ComponentB)

me_cmake_test_end()
