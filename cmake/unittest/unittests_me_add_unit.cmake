include(me_mock)

macro(define_property)
  me_mock_trace(define_property ${ARGV})
endmacro()

include(me_structure) # include DUT

# setup mocks
macro(me_print)
  me_mock_trace(me_print ${ARGV})
endmacro()

macro(me_print_list)
  me_mock_trace(me_print_list ${ARGV})
endmacro()

macro(add_library)
  me_mock_trace(add_library ${ARGV})
endmacro()

macro(target_link_libraries)
  me_mock_trace(target_link_libraries ${ARGV})
endmacro()

macro(set_target_properties)
  me_mock_trace(set_target_properties ${ARGV})
endmacro()

macro(get_property variable command_target target command_property property)
  me_mock_trace(get_property ${command_target} ${target} ${command_property}
                ${property} ${ARGN})
  if(get_property__${command_target}__${target}__${command_property}__${property}
  )
    set(${variable}
        ${get_property__${command_target}__${target}__${command_property}__${property}}
    )
  endif()
endmacro()

macro(get_target_property variable target property)
  me_mock_trace(get_target_property ${target} ${property} ${ARGN})
  if(get_target_property__${target}__${property})
    set(${variable} ${get_target_property__${target}__${property}})
  endif()
endmacro()

macro(set_property)
  me_mock_trace(set_property ${ARGV})
endmacro()

macro(target_include_directories)
  me_mock_trace(target_include_directories ${ARGV})
endmacro()

include(me_cmake_test)

me_cmake_test_begin(test_me_add_unit_empty)

me_mock_expect(me_print STATUS "Unit: TestUnit")
me_mock_expect(add_library TestUnit OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(get_target_property InterfaceA TYPE)
me_mock_expect(get_target_property InterfaceB TYPE)
me_mock_expect(
  set_property
  TARGET
  TestUnit
  APPEND
  PROPERTY
  ME_LINK_TARGETS
  InterfaceA
  InterfaceB)
me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(get_target_property InterfaceA TYPE)
me_mock_expect(get_target_property InterfaceB TYPE)
me_mock_expect(
  set_property
  TARGET
  TestUnit
  APPEND
  PROPERTY
  ME_LINK_TARGETS
  InterfaceA
  InterfaceB)

me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
me_mock_expect(get_target_property iInterfaceA TYPE)
me_mock_expect(get_target_property iInterfaceB TYPE)
me_mock_expect(get_target_property sInterfaceA TYPE)
me_mock_expect(get_target_property sInterfaceB TYPE)
me_mock_expect(
  set_property
  TARGET
  TestUnit
  APPEND
  PROPERTY
  ME_LINK_TARGETS
  iInterfaceA
  iInterfaceB
  sInterfaceA
  sInterfaceB)

me_mock_expect(set_target_properties TestUnit PROPERTIES
               POSITION_INDEPENDENT_CODE ON)
me_mock_expect(
  set_target_properties
  TestUnit
  PROPERTIES
  CXX_STANDARD
  17
  CXX_STANDARD_REQUIRED
  ON)

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
