include(me_mock)

macro(define_property)
  me_mock_trace(define_property ${ARGV})
endmacro()

include(me_artifact) # include DUT

me_mock_reset()

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

macro(set_property)
  me_mock_trace(set_property ${ARGV})
endmacro()

macro(target_include_directories)
  me_mock_trace(target_include_directories ${ARGV})
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

macro(set_property)
  me_mock_trace(set_property ${ARGV})
endmacro()

include(me_cmake_test)

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
me_mock_expect(get_property TARGET Unit_1 PROPERTY ME_LINK_TARGETS)
me_mock_expect(get_property TARGET Unit_2 PROPERTY ME_LINK_TARGETS)
me_mock_expect(target_link_libraries TestLibrary PRIVATE Unit_1 Unit_2)
me_mock_expect(
  set_property
  TARGET
  TestLibrary
  APPEND
  PROPERTY
  ME_LINK_TARGETS
  TestLibrary)

set(get_property__TARGET__Unit_1__PROPERTY__ME_LINK_TARGETS Unit_1)
set(get_property__TARGET__Unit_2__PROPERTY__ME_LINK_TARGETS Unit_2)

me_add_library(TestLibrary CONTAINS Unit_1 Unit_2)

me_cmake_test_end()
