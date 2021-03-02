include(me_mock)

macro(define_property)
    me_mock_trace(define_property ${ARGV})
endmacro()

include(me_test) # include DUT

# setup mocks
macro(me_add_package)
    me_mock_trace(me_add_package ${ARGV})
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

me_cmake_test_begin(test_me_add_packagetest)

me_mock_expect(
    me_add_package
    package_packagetest_name
    SOURCE_DIR
    ssubdir
    SOURCES
    Source1.cpp
    Source2.cpp
    SOURCE_DEPENDS
    Unit_1
    Unit_2
    name
)

me_mock_expect(
    me_add_executable
    packagetest_name
    CONTAINS
    name
    package_packagetest_name
    Unit_1
    Unit_2
    Main
)

me_mock_expect(add_test packagetest_name packagetest_name)

me_add_packagetest(
    name
    SOURCE_DIR ssubdir
    SOURCES Source1.cpp Source2.cpp
    SOURCE_DEPENDS Unit_1 Unit_2
    CONTAINS Main
)

me_cmake_test_end()
