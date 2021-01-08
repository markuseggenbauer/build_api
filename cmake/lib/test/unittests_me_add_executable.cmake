include(me_artifact) # include DUT

include(me_cmake_test) # me_cmake_test_*() functions
include(unittests_mock_setup.cmake) # setup mocks

me_cmake_test_begin(test_me_add_executable_sources)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: .")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  ./Testfile1.cpp
  ./Testfile2.cpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  DEPENDS:")
me_mock_expect(add_executable TestExecutable ./Testfile1.cpp ./Testfile2.cpp)
me_mock_expect(target_include_directories TestExecutable PRIVATE .)

me_add_executable(TestExecutable SOURCES Testfile1.cpp Testfile2.cpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_executable_sources_dir)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: subdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  subdir/Testfile1.cpp
  subdir/Testfile2.cpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  DEPENDS:")
me_mock_expect(add_executable TestExecutable subdir/Testfile1.cpp
               subdir/Testfile2.cpp)
me_mock_expect(target_include_directories TestExecutable PRIVATE subdir)

me_add_executable(TestExecutable SOURCE_DIR subdir SOURCES Testfile1.cpp
                  Testfile2.cpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_executable_dependencies)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  DEPENDS:"
  ComponentA
  ComponentB)
me_mock_expect(add_executable TestExecutable ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_link_libraries TestExecutable PRIVATE ComponentA
               ComponentB)

me_add_executable(TestExecutable DEPENDS ComponentA ComponentB)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_executable_sources_dir_dependencies)

me_mock_expect(me_print STATUS "Executable: TestExecutable")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: subdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  subdir/Testfile1.cpp
  subdir/Testfile2.cpp)
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  DEPENDS:"
  ComponentA
  ComponentB)
me_mock_expect(add_executable TestExecutable subdir/Testfile1.cpp
               subdir/Testfile2.cpp)
me_mock_expect(target_include_directories TestExecutable PRIVATE subdir)
me_mock_expect(target_link_libraries TestExecutable PRIVATE ComponentA
               ComponentB)

me_add_executable(
  TestExecutable
  SOURCE_DIR
  subdir
  SOURCES
  Testfile1.cpp
  Testfile2.cpp
  DEPENDS
  ComponentA
  ComponentB)

me_cmake_test_end()
