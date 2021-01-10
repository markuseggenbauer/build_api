include(me_artifact) # include DUT

include(me_cmake_test) # me_cmake_test_*() functions

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

me_cmake_test_begin(test_me_add_unit_empty)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(add_library TestUnit OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_interface)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  INTERFACE_DIR: .")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  INTERFACES:"
  ./Interface1.hpp
  ./Interface2.hpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  INTERFACE_DEPENDS:")
me_mock_expect(add_library TestUnit OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_include_directories TestUnit PUBLIC .)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit INTERFACES Interface1.hpp Interface2.hpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_interface_dir)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  INTERFACE_DIR: subdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  INTERFACES:"
  subdir/Interface1.hpp
  subdir/Interface2.hpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  INTERFACE_DEPENDS:")
me_mock_expect(add_library TestUnit OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_include_directories TestUnit PUBLIC subdir)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit INTERFACE_DIR subdir INTERFACES Interface1.hpp
            Interface2.hpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_interface_depends)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  INTERFACE_DIR: ")
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  INTERFACES:")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  INTERFACE_DEPENDS:"
  InterfaceA
  InterfaceB)
me_mock_expect(add_library TestUnit OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(target_link_libraries TestUnit PUBLIC InterfaceA InterfaceB)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit INTERFACE_DEPENDS InterfaceA InterfaceB)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_source)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: .")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  ./Source1.cpp
  ./Source2.cpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  SOURCE_DEPENDS:")
me_mock_expect(add_library TestUnit OBJECT ./Source1.cpp ./Source2.cpp)
me_mock_expect(target_include_directories TestUnit PRIVATE .)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit SOURCES Source1.cpp Source2.cpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_source_dir)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: subdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  subdir/Source1.cpp
  subdir/Source2.cpp)
me_mock_expect(me_print_list LOG_TYPE VERBOSE CAPTION "  SOURCE_DEPENDS:")
me_mock_expect(add_library TestUnit OBJECT subdir/Source1.cpp
               subdir/Source2.cpp)
me_mock_expect(target_include_directories TestUnit PRIVATE subdir)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(TestUnit SOURCE_DIR subdir SOURCES Source1.cpp Source2.cpp)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_source_dir_depends)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: subdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  subdir/Source1.cpp
  subdir/Source2.cpp)
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCE_DEPENDS:"
  InterfaceA
  InterfaceB)
me_mock_expect(add_library TestUnit OBJECT subdir/Source1.cpp
               subdir/Source2.cpp)
me_mock_expect(target_include_directories TestUnit PRIVATE subdir)
me_mock_expect(target_link_libraries TestUnit PRIVATE InterfaceA InterfaceB)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(
  TestUnit
  SOURCE_DIR
  subdir
  SOURCES
  Source1.cpp
  Source2.cpp
  SOURCE_DEPENDS
  InterfaceA
  InterfaceB)

me_cmake_test_end()

me_cmake_test_begin(test_me_add_unit_interface_dir_depends_source_dir_depends)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(me_print VERBOSE "  INTERFACE_DIR: isubdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  INTERFACES:"
  isubdir/Interface1.hpp
  isubdir/Interface2.hpp)
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  INTERFACE_DEPENDS:"
  iInterfaceA
  iInterfaceB)
me_mock_expect(me_print VERBOSE "  SOURCE_DIR: ssubdir")
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCES:"
  ssubdir/Source1.cpp
  ssubdir/Source2.cpp)
me_mock_expect(
  me_print_list
  LOG_TYPE
  VERBOSE
  CAPTION
  "  SOURCE_DEPENDS:"
  sInterfaceA
  sInterfaceB)
me_mock_expect(add_library TestUnit OBJECT ssubdir/Source1.cpp
               ssubdir/Source2.cpp)
me_mock_expect(target_include_directories TestUnit PUBLIC isubdir)
me_mock_expect(target_include_directories TestUnit PRIVATE ssubdir)
me_mock_expect(target_link_libraries TestUnit PUBLIC iInterfaceA iInterfaceB)
me_mock_expect(target_link_libraries TestUnit PRIVATE sInterfaceA sInterfaceB)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)

me_add_unit(
  TestUnit
  INTERFACE_DIR
  isubdir
  INTERFACES
  Interface1.hpp
  Interface2.hpp
  INTERFACE_DEPENDS
  iInterfaceA
  iInterfaceB
  SOURCE_DIR
  ssubdir
  SOURCES
  Source1.cpp
  Source2.cpp
  SOURCE_DEPENDS
  sInterfaceA
  sInterfaceB)

me_cmake_test_end()
